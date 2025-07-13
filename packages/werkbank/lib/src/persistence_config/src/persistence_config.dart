import 'package:shared_preferences/shared_preferences.dart';
import 'package:werkbank/src/persistence_config/src/store.dart';

interface class PersistenceConfig {
  const PersistenceConfig()
    : this._(createJsonStore: _createSharedPreferencesStore);

  const PersistenceConfig.memory()
    : this._(createJsonStore: _createMemoryStore);

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

  static Future<JsonStore> _createMemoryStore() async {
    return MemoryStore();
  }

  final Future<JsonStore> Function() _createJsonStore;

  Future<JsonStore> createJsonStore() => _createJsonStore();
}
