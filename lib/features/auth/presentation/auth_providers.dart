import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/cached_fetcher.dart';
import '../../../core/providers.dart';
import '../data/auth_repository_impl.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) =>
    AuthRepositoryImpl(
      ref.watch(dioProvider),
      ref.watch(tokenStorageProvider),
      ref.watch(cacheServiceProvider),
    ));

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthController extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    _init();
    return AuthStatus.unknown;
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> _init() async {
    final ok = await _repo.hasSession();
    state = ok ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  Future<void> login(String username, String password) async {
    await _repo.login(username, password);
    state = AuthStatus.authenticated;
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthStatus.unauthenticated;
  }

  void sessionExpired() => state = AuthStatus.unauthenticated;
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthStatus>(AuthController.new);

final profileProvider = FutureProvider<DataResult<User>>(
    (ref) => ref.watch(authRepositoryProvider).getCurrentUser());
