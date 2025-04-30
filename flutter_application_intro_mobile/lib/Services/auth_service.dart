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
      _handleError(e);
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
      _handleError(e);
    }
  }

  static Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  static void _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        print('No user found for that email.');
        break;
      case 'wrong-password':
        print('Wrong password provided.');
        break;
      case 'weak-password':
        print('Password is too weak.');
        break;
      case 'email-already-in-use':
        print('Email already in use.');
        break;
      default:
        print('Auth Error: ${e.message}');
    }
  }
}
