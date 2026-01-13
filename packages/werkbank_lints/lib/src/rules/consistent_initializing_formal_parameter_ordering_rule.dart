import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

class ConsistentInitializingFormalParameterOrderingRule extends AnalysisRule {
  ConsistentInitializingFormalParameterOrderingRule()
    : super(
        name: code.name,
        description:
            'Order initializing formal parameters in the same order '
            'as their fields.',
      );

  static const LintCode code = LintCode(
    'consistent_initializing_formal_parameter_ordering',
    'Initializing formal parameter is ordered inconsistently with its field.',
    correctionMessage:
        'Either reorder the parameters or the fields to match each other.',
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addConstructorDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;

  final RuleContext context;

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    final offsetsInDeclaringClass = <ClassFragment, int>{};
    bool testParameterOrder(FormalParameter parameter) {
      switch (parameter) {
        case DefaultFormalParameter():
          return testParameterOrder(parameter.parameter);
        case FieldFormalParameter():
          break;
        case FunctionTypedFormalParameter():
        case SimpleFormalParameter():
        case SuperFormalParameter():
          return true;
      }
      final field = parameter.declaredFragment?.element.field;
      if (field == null) {
        return true;
      }
      final declaringFragment = field.fragments.first;
      Fragment? declaringClass = declaringFragment;
      while (declaringClass != null && declaringClass is! ClassFragment) {
        declaringClass = declaringClass.enclosingFragment;
      }
      if (declaringClass is! ClassFragment) {
        return true;
      }
      final thisOffset = declaringFragment.nameOffset;
      if (thisOffset == null) {
        return true;
      }
      final lastOffset = offsetsInDeclaringClass[declaringClass];
      if (lastOffset != null && thisOffset < lastOffset) {
        rule.reportAtNode(parameter);
        return false;
      } else {
        offsetsInDeclaringClass[declaringClass] = thisOffset;
        return true;
      }
    }

    for (final parameter in node.parameters.parameters) {
      if (parameter.isRequiredPositional && !testParameterOrder(parameter)) {
        break;
      }
    }
    offsetsInDeclaringClass.clear();
    for (final parameter in node.parameters.parameters) {
      if (parameter.isOptionalPositional && !testParameterOrder(parameter)) {
        break;
      }
    }
    offsetsInDeclaringClass.clear();
    for (final parameter in node.parameters.parameters) {
      if (parameter.isNamed && !testParameterOrder(parameter)) {
        break;
      }
    }
  }
}
