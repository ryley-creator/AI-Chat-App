import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<UserCredential> login(String email, String password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firestore.collection('users').doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'email': email,
      });
      return user;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firestore.collection('users').doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'email': email,
      });
      return user;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
  }
}
