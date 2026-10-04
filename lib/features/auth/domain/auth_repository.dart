import '../../../core/data/cached_fetcher.dart';
import 'user.dart';

abstract class AuthRepository {
  Future<bool> hasSession();
  Future<User> login(String username, String password);
  Future<User> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  });
  Future<DataResult<User>> getCurrentUser();
  Future<void> logout();
}
