import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:yaml/yaml.dart';

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

  _ParameterDefinitionPackages? _parameterDefinitionPackages;

  _ParameterDefinitionPackages _getParameterDefinitionPackages(
    RuleContext context,
  ) {
    if (_parameterDefinitionPackages != null) {
      return _parameterDefinitionPackages!;
    }
    final analysisOptionsContent = context
        .libraryElement
        ?.session
        .analysisContext
        .contextRoot
        .optionsFile
        ?.readAsStringSync();

    if (analysisOptionsContent == null) {
      return _parameterDefinitionPackages = _OnlySamePackageAsUsage();
    }

    final yaml = loadYaml(analysisOptionsContent);
    if (yaml is! YamlMap) {
      return _parameterDefinitionPackages = _OnlySamePackageAsUsage();
    }
    final consistentArgumentOrderingOptions = yaml[code.name];
    if (consistentArgumentOrderingOptions is! YamlMap) {
      return _parameterDefinitionPackages = _OnlySamePackageAsUsage();
    }
    final parameterDefinitionPackages =
        consistentArgumentOrderingOptions['parameter_definition_packages'];
    if (parameterDefinitionPackages == 'all') {
      return _parameterDefinitionPackages = _AllPackages();
    } else if (parameterDefinitionPackages is YamlList) {
      final packages = <String>{
        for (final package in parameterDefinitionPackages)
          if (package is String) package,
      };
      return _parameterDefinitionPackages = _SpecificPackages(packages);
    } else {
      return _parameterDefinitionPackages = _OnlySamePackageAsUsage();
    }
  }

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final parameterDefinitionPackages = _getParameterDefinitionPackages(
      context,
    );
    final visitor = _Visitor(this, context, parameterDefinitionPackages);
    registry.addArgumentList(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context, this.parameterDefinitionPackages);

  final AnalysisRule rule;

  final RuleContext context;

  final _ParameterDefinitionPackages parameterDefinitionPackages;

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
      switch (parameterDefinitionPackages) {
        case _AllPackages():
          break;
        case _SpecificPackages(:final packages):
          if (!packages.contains(
            correspondingParameter.library!.uri.pathSegments.first,
          )) {
            return false;
          }
        case _OnlySamePackageAsUsage():
          if (!context.package!.contains(
            correspondingParameter.library!.firstFragment.source,
          )) {
            return false;
          }
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

sealed class _ParameterDefinitionPackages {}

class _AllPackages extends _ParameterDefinitionPackages {}

class _SpecificPackages extends _ParameterDefinitionPackages {
  _SpecificPackages(this.packages);

  final Set<String> packages;
}

class _OnlySamePackageAsUsage extends _ParameterDefinitionPackages {}
