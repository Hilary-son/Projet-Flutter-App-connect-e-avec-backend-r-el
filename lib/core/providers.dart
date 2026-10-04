import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/auth_providers.dart';
import 'data/cached_fetcher.dart';
import 'network/dio_client.dart';
import 'network/network_info.dart';
import 'storage/cache_service.dart';
import 'storage/token_storage.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage());
final cacheServiceProvider = Provider((ref) => CacheService());
final networkInfoProvider = Provider((ref) => NetworkInfo());

final dioProvider = Provider<Dio>((ref) => createDio(
      ref.watch(tokenStorageProvider),
      onSessionExpired: () =>
          ref.read(authControllerProvider.notifier).sessionExpired(),
    ));

final cachedFetcherProvider = Provider((ref) => CachedFetcher(
      ref.watch(dioProvider),
      ref.watch(cacheServiceProvider),
      ref.watch(networkInfoProvider),
    ));

final connectivityProvider =
    StreamProvider<bool>((ref) => ref.watch(networkInfoProvider).onChange);
