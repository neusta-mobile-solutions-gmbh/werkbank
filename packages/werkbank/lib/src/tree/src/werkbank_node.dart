import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addon_config/addon_config.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/widgets/widgets.dart';

/// {@category Getting Started}
/// {@category Structure}
/// {@category Writing Use Cases}
/// {@category File Structure}
/// A function too manipulate the [UseCaseComposer] like it would be done at the
/// beginning of a [UseCaseBuilder] definition.
///
/// This builder can be added to a [WerkbankRoot], [WerkbankFolder] or
/// [WerkbankComponent] to do things with the [UseCaseComposer] before the
/// [UseCaseBuilder] of a [WerkbankUseCase] is called.
///
/// Since in typical use, the [UseCaseParentBuilder]s on
/// [WerkbankFolder]s and [WerkbankComponent]s are much smaller than
/// [UseCaseBuilder] definitions, it is fine to simply add them as a callback.
///
/// ```dart
/// WerkbankFolder(
///   name: 'Example Folder',
///   builder: (c) {
///     // Do something with the composer here.
///   }
/// )
/// ```
///
/// But if the builder gets too large, it is recommended to define it as a
/// top level function, similar to a [UseCaseBuilder].
///
/// Like with the [UseCaseBuilder], the available features depend on which
/// [Addon]s are used.
/// See [UseCaseBuilder] for more information.
typedef UseCaseParentBuilder = void Function(UseCaseComposer c);

/// {@category Getting Started}
/// {@category Structure}
/// {@category Writing Use Cases}
/// {@category File Structure}
/// A builder function for a use case.
///
/// A [UseCaseBuilder] is typically created by defining a top level function
/// as follows:
///
/// ```dart
/// WidgetBuilder exampleUseCase(UseCaseComposer c) {
///   // You can do many things with the composer here.
///   return (context) {
///     return ExampleWidget();
///   };
/// }
/// ```
///
/// The [UseCaseComposer] can be used for many useful things, such as
/// adding knobs to the UI, adding metadata to a use case, and much more.
/// However, which specific features are available depends on which [Addon]s
/// are used.
/// See [AddonConfig.new] and the [Addon]s introduced
/// by it for more information on what can be done with the [UseCaseComposer].
///
/// {@category IDE Integration}
typedef UseCaseBuilder = WidgetBuilder Function(UseCaseComposer c);

/// {@category Structure}
/// A node in the Werkbank tree.
sealed class WerkbankNode {}

/// A superclass for [WerkbankNode]s which can have children.
///
/// Specifically the subclasses are
/// [WerkbankRoot], [WerkbankComponent] and [WerkbankFolder].
sealed class WerkbankParentNode<T extends WerkbankChildNode>
    extends WerkbankNode {
  WerkbankParentNode({
    this.builder,
    required this.children,
  });

  /// The [UseCaseParentBuilder] for this node.
  ///
  /// See [UseCaseParentBuilder] for information on how to
  /// define such a builder.
  final UseCaseParentBuilder? builder;

  /// The children of this node.
  final List<T> children;
}

/// A [WerkbankNode] which is a child of a [WerkbankParentNode].
///
/// The subclasses are [WerkbankComponent], [WerkbankFolder], and
/// [WerkbankUseCase].
sealed class WerkbankChildNode extends WerkbankNode {
  WerkbankChildNode({
    required this.name,
  });

  /// The name of the node.
  ///
  /// This will be displayed in the UI and used in the path when accessing
  /// use cases via a URL.
  final String name;
}

/// {@category Getting Started}
/// {@category Structure}
///
/// A [WerkbankNode] that defines a collection of [WerkbankChildNode]s.
///
/// An instance of this is passed to the [WerkbankApp] to define the
/// structure of the app.
///
/// The [children] define your tree structure of [WerkbankFolder]s,
/// [WerkbankComponent]s, and [WerkbankUseCase]s.
class WerkbankRoot extends WerkbankParentNode<WerkbankChildNode> {
  WerkbankRoot({
    super.builder,
    required super.children,
  });
}

/// {@category Getting Started}
/// {@category Structure}
/// {@category File Structure}
/// A [WerkbankNode] that defines a collection of [WerkbankUseCase]s.
/// This is typically used when there are multiple use cases for a single
/// component, such as a button or a switch.
///
/// To group multiple use cases together which do not show off the
/// same component, consider using a [WerkbankFolder] instead.
class WerkbankComponent extends WerkbankParentNode<WerkbankUseCase>
    implements WerkbankChildNode {
  WerkbankComponent({
    required this.name,
    this.isInitiallyCollapsed = false,
    super.builder,
    required List<WerkbankUseCase> useCases,
  }) : super(children: useCases);

  @override
  final String name;

  final bool isInitiallyCollapsed;
}

/// {@category Getting Started}
/// {@category Structure}
/// A [WerkbankNode] that defines a collection of [WerkbankNode]s.
///
/// This can be used to group multiple [WerkbankUseCase]s,
/// [WerkbankComponent]s, and other [WerkbankFolder]s together.
class WerkbankFolder extends WerkbankParentNode<WerkbankChildNode>
    implements WerkbankChildNode {
  WerkbankFolder({
    required this.name,
    this.isInitiallyCollapsed = false,
    super.builder,
    required super.children,
  });

  @override
  final String name;

  final bool isInitiallyCollapsed;
}

/// {@category Getting Started}
/// {@category Structure}
/// {@category Writing Use Cases}
/// {@category File Structure}
/// A [WerkbankNode] that defines a single use case.
class WerkbankUseCase extends WerkbankChildNode {
  WerkbankUseCase({
    required super.name,
    required this.builder,
  });

  /// The [UseCaseBuilder] for this use case.
  ///
  /// See [UseCaseBuilder] for information on how to define such a builder.
  final UseCaseBuilder builder;
}
