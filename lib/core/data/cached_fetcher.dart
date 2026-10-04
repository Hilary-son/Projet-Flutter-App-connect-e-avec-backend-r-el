import 'package:dio/dio.dart';
import '../error/failures.dart';
import '../network/network_info.dart';
import '../storage/cache_service.dart';

class DataResult<T> {
  final T data;
  final bool fromCache; // true = données hors-ligne
  const DataResult(this.data, {this.fromCache = false});
}

/// Logique commune : réseau -> API + sauvegarde cache ; sinon -> cache ; sinon erreur.
class CachedFetcher {
  CachedFetcher(this._dio, this._cache, this._network);
  final Dio _dio;
  final CacheService _cache;
  final NetworkInfo _network;

  Future<DataResult<List<T>>> fetchList<T>({
    required String path,
    required String listKey,
    required String cacheKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> query,
  }) async {
    DataResult<List<T>>? fromCache() {
      final cached = _cache.readList(cacheKey);
      if (cached == null) return null;
      return DataResult(cached.map(fromJson).toList(), fromCache: true);
    }

    if (await _network.isConnected) {
      try {
        final res = await _dio.get<dynamic>(path, queryParameters: query);
        final raw = (res.data[listKey] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        await _cache.saveList(cacheKey, raw);
        return DataResult(raw.map(fromJson).toList());
      } on DioException catch (e) {
        final cached = fromCache();
        if (cached != null) return cached;
        throw mapDioError(e);
      }
    }

    final cached = fromCache();
    if (cached != null) return cached;
    throw const Failure('Pas de connexion et aucune donnée en cache.');
  }
}
