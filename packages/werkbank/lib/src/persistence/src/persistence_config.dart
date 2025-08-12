import 'package:shared_preferences/shared_preferences.dart';
import 'package:werkbank/src/persistence/src/json_store.dart';
import 'package:werkbank/src/persistence/src/persistent_controller_initialization.dart';

interface class PersistenceConfig {
  const PersistenceConfig()
    // The default [PersistenceConfig] does not have initializations,
    // because they would only be applied if they are present before the
    // respective addon is loaded for the first time.
    // This is very limited in usefulness and would likely cause confusion
    // why the initializations are not applied.
    : this._(createJsonStore: _createSharedPreferencesStore);

  const PersistenceConfig.memory({
    List<AnyPersistentControllerInitialization> initializations = const [],
  }) : this._(
         createJsonStore: _createMemoryStore,
         initializations: initializations,
       );

  const PersistenceConfig._({
    required Future<JsonStore> Function() createJsonStore,
    this.initializations = const [],
  }) : _createJsonStore = createJsonStore;

  static Future<JsonStore> _createSharedPreferencesStore() async {
    return SharedPreferencesStore(
      await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      ),
    );
  }

  static Future<JsonStore> _createMemoryStore() async {
    return MemoryStore();
  }

  final Future<JsonStore> Function() _createJsonStore;
  final List<AnyPersistentControllerInitialization> initializations;

  Future<JsonStore> createJsonStore() => _createJsonStore();
}
