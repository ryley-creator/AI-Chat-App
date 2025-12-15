import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user;
    } catch (error) {
      print('Login error: $error');
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user;
    } catch (error) {
      print('Sign up error: $error');
      return null;
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
  }

  Stream<User?> authState() => auth.authStateChanges();
}
