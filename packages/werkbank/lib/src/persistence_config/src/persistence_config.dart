import 'package:shared_preferences/shared_preferences.dart';
import 'package:werkbank/src/persistence_config/src/store.dart';

class PersistenceConfig {
  factory PersistenceConfig() {
    return PersistenceConfig._(
      createJsonStore: () async => SharedPreferencesStore(
        await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(),
        ),
      ),
    );
  }

  factory PersistenceConfig.memory() {
    return PersistenceConfig._(
      createJsonStore: () async => MemoryStore(),
    );
  }

  PersistenceConfig._({
    required Future<JsonStore> Function() createJsonStore,
  }) : _createJsonStore = createJsonStore;

  final Future<JsonStore> Function() _createJsonStore;

  Future<JsonStore> createJsonStore() => _createJsonStore();
}
