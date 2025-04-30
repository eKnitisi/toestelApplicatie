import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/home_screen.dart';
import '../Screens/login_screen.dart';

class AuthService {
  static Future<void> signInWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "ingelogd"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleError(e, context);
    }
  }

  static Future<void> registerWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "ingelogd"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleError(e, context);
    }
  }

  static Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  static void _handleError(FirebaseAuthException e, BuildContext context) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'no user found for that email.';
        break;
      case 'wrong-password':
        message = 'password is wrong.';
        break;
      default:
        message = 'error: ${e.message}';
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
