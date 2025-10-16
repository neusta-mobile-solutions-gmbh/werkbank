/// @docImport 'package:werkbank/src/addon_api/addon_api.dart';
/// @docImport 'package:werkbank/src/global_state/global_state.dart';
/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werkbank/src/persistence/src/json_store.dart';

/// A configuration object that defines how Werkbank can persist data.
///
/// The default [PersistenceConfig.new] constructor uses
/// shared preferences to persist data across restarts.
/// This is the default config used for a [WerkbankApp], since users of it
/// likely want their data to be persisted across restarts.
///
/// The [PersistenceConfig.memory] constructor uses an in-memory store
/// that does not persist data across restarts.
/// This is the default config used for a [DisplayApp], since its most common
/// use is in tests where the run of one test should not influence another.
///
/// If you are an [Addon] developer, you can use a
/// [GlobalStateController] to manage and persist state across the whole
/// application.
interface class PersistenceConfig {
  const PersistenceConfig()
    // The default [PersistenceConfig] does not have initializations,
    // because they would only be applied if they are present before the
    // respective addon is loaded for the first time.
    // This is very limited in usefulness and would likely cause confusion
    // why the initializations are not applied.
    : this._(createJsonStore: _createSharedPreferencesStore);

  // TODO: Add "treatAsWarmStart" parameter?
  const PersistenceConfig.memory()
    : this._(
        createJsonStore: _createMemoryStore,
      );

  const PersistenceConfig._({
    required Future<JsonStore> Function() createJsonStore,
  }) : _createJsonStore = createJsonStore;

  static Future<JsonStore> _createSharedPreferencesStore() async {
    return SharedPreferencesStore(
      await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      ),
    );
  }

  static SynchronousFuture<JsonStore> _createMemoryStore() {
    return SynchronousFuture(MemoryStore());
  }

  final Future<JsonStore> Function() _createJsonStore;

  Future<JsonStore> createJsonStore() => _createJsonStore();
}
