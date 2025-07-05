import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signUp(String email, String password);
  Future<User> signIn(String email, String password);
  Future<void> signOut();
}