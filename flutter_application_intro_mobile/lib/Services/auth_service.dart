import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/home_screen.dart';
import '../Screens/login_screen.dart';
import '../models/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hardcoded login voor development
  static Future<void> signInWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: "tibe@mail.com",
        password: "test123",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "Home"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleError(e, context);
    }
  }

  static Future<void> registerWithEmail(
    String email,
    String password,
    String name,
    BuildContext context,
  ) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        uid: cred.user!.uid,
        email: email,
        name: name,
        role: 'tenant',
      );

      await _firestore
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "Home"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleError(e, context);
    }
  }

  static Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  static void _handleError(FirebaseAuthException e, BuildContext context) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Password is wrong.';
        break;
      default:
        message = 'Error: ${e.message}';
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<UserModel?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.id, doc.data()!);
    } else {
      return null;
    }
  }
}
