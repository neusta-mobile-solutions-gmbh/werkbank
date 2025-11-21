import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

class ConsistentSuperParameterOrderingRule extends AnalysisRule {
  ConsistentSuperParameterOrderingRule()
    : super(
        name: code.name,
        description:
            'Order super parameters in the same order '
            'as in the super constructor.',
      );

  static const LintCode code = LintCode(
    'consistent_super_parameter_ordering',
    'Super parameter is ordered inconsistently with the super constructor.',
    correctionMessage: 'Reorder the parameters to match the super constructor.',
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
    final constructorElement = node.declaredFragment?.element;
    if (constructorElement == null) {
      return;
    }
    final superConstructor = constructorElement.superConstructor;
    if (superConstructor == null) {
      return;
    }
    final offsetsInDeclaringClass = <ConstructorFragment, int>{};
    bool testParameterOrder(FormalParameter parameter) {
      switch (parameter) {
        case DefaultFormalParameter():
          return testParameterOrder(parameter.parameter);
        case SuperFormalParameter():
          break;
        case FieldFormalParameter():
        case FunctionTypedFormalParameter():
        case SimpleFormalParameter():
          return true;
      }
      final superConstructorParameter =
          parameter.declaredFragment?.element.superConstructorParameter;
      if (superConstructorParameter == null) {
        return true;
      }
      final declaringFragment = superConstructorParameter.fragments.first;
      Fragment? declaringConstructor = declaringFragment;
      while (declaringConstructor != null &&
          declaringConstructor is! ConstructorFragment) {
        declaringConstructor = declaringConstructor.enclosingFragment;
      }
      if (declaringConstructor is! ConstructorFragment) {
        return true;
      }
      final thisOffset = declaringFragment.offset;
      final lastOffset = offsetsInDeclaringClass[declaringConstructor];
      if (lastOffset != null && thisOffset < lastOffset) {
        rule.reportAtNode(parameter);
        return false;
      } else {
        offsetsInDeclaringClass[declaringConstructor] = thisOffset;
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
