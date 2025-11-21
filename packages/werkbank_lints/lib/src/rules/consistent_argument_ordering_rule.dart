import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

class ConsistentArgumentOrderingRule extends AnalysisRule {
  ConsistentArgumentOrderingRule()
    : super(
        name: code.name,
        description:
            'Order named arguments in the same order '
            'as in the called function.',
      );

  static const LintCode code = LintCode(
    'consistent_argument_ordering',
    'Argument is ordered inconsistently with the called function.',
    correctionMessage: 'Reorder the arguments to match the called function.',
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addArgumentList(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;

  final RuleContext context;

  @override
  void visitArgumentList(ArgumentList node) {
    final offsetsInDeclaringClass = <ExecutableFragment, int>{};
    bool testParameterOrder(NamedExpression argument) {
      final correspondingParameter = argument.correspondingParameter;
      if (correspondingParameter == null) {
        return true;
      }
      if (correspondingParameter.library == null) {
        return true;
      }
      if (!context.package!.contains(
        correspondingParameter.library!.firstFragment.source,
      )) {
        return false;
      }
      final declaringFragment = correspondingParameter.fragments.first;
      Fragment? declaringExecutable = declaringFragment;
      while (declaringExecutable != null &&
          declaringExecutable is! ExecutableFragment) {
        declaringExecutable = declaringExecutable.enclosingFragment;
      }
      if (declaringExecutable is! ExecutableFragment) {
        return true;
      }
      final thisOffset = declaringFragment.offset;
      final lastOffset = offsetsInDeclaringClass[declaringExecutable];
      if (lastOffset != null && thisOffset < lastOffset) {
        rule.reportAtNode(argument.name);
        return false;
      } else {
        offsetsInDeclaringClass[declaringExecutable] = thisOffset;
        return true;
      }
    }

    for (final argument in node.arguments) {
      if (argument is NamedExpression && !testParameterOrder(argument)) {
        break;
      }
    }
  }
}
