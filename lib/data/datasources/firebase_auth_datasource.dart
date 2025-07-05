import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';

class FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  Future<User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return User(id: firebaseUser.uid, email: firebaseUser.email!);
    }
    return null;
  }

  Future<User> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return User(id: credential.user!.uid, email: credential.user!.email!);
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  Future<User> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return User(id: credential.user!.uid, email: credential.user!.email!);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}