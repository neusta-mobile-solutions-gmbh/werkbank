import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:werkbank/src/persistence/persistence.dart';

class JsonStoreProvider extends StatefulWidget {
  const JsonStoreProvider({
    super.key,
    required this.persistenceConfig,
    required this.placeholder,
    required this.child,
  });

  final PersistenceConfig persistenceConfig;
  final Widget placeholder;
  final Widget child;

  static JsonStore read(BuildContext context) {
    final result = context
        .getInheritedWidgetOfExactType<_InheritedJsonStoreProvider>();
    assert(result != null, 'No JsonStoreProvider found in context');
    return result!.jsonStore;
  }

  @override
  State<JsonStoreProvider> createState() => _JsonStoreProviderState();
}

class _JsonStoreProviderState extends State<JsonStoreProvider> {
  JsonStore? _jsonStore;

  @override
  void initState() {
    super.initState();
    unawaited(_initJsonStore());
  }

  Future<void> _initJsonStore() async {
    // We deliberately do not update the store when the widget is rebuilt.
    final jsonStoreFuture = widget.persistenceConfig.createJsonStore();
    if (jsonStoreFuture is SynchronousFuture<JsonStore>) {
      unawaited(
        jsonStoreFuture.then((jsonStore) {
          setState(() {
            _jsonStore = jsonStore;
          });
        }),
      );
      return;
    }

    final jsonStore = await jsonStoreFuture;
    // We defer the first frame
    // until the persistence is ready.
    // This way we avoid an empty first frame.
    RendererBinding.instance.deferFirstFrame();
    setState(() {
      _jsonStore = jsonStore;
    });
    RendererBinding.instance.allowFirstFrame();
  }

  @override
  Widget build(BuildContext context) {
    final jsonStore = _jsonStore;
    if (jsonStore == null) {
      return widget.placeholder;
    }
    return _InheritedJsonStoreProvider(
      jsonStore: jsonStore,
      child: widget.child,
    );
  }
}

class _InheritedJsonStoreProvider extends InheritedWidget {
  const _InheritedJsonStoreProvider({
    required this.jsonStore,
    required super.child,
  });

  final JsonStore jsonStore;

  @override
  bool updateShouldNotify(_InheritedJsonStoreProvider oldWidget) {
    return jsonStore != oldWidget.jsonStore;
  }
}
