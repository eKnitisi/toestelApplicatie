import 'package:flutter/material.dart';
import '../Services/auth_service.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showAppBar;
  final bool showLogout;
  final bool centerTitle;
  final Widget? floatingActionButton;

  const BaseScaffold({
    super.key,
    required this.body,
    this.title,
    this.showAppBar = true,
    this.showLogout = true,
    this.centerTitle = true,
    this.floatingActionButton,
  });

  static final eggColor = Colors.grey.shade200;
  static final buttonBlue = Colors.blue.shade700;
  static final logoutRed = Colors.red.shade700;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: eggColor,
      appBar:
          showAppBar
              ? AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: centerTitle,
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
              )
              : null,
      body: Stack(
        children: [
          body,
          Positioned(
            top: 16,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'home_button',
              mini: true,
              backgroundColor: buttonBlue,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              child: const Icon(Icons.home, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButton:
          floatingActionButton ??
          (showLogout
              ? FloatingActionButton(
                backgroundColor: logoutRed,
                onPressed: () async {
                  await AuthService.signOut(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("You have been signed out.")),
                  );
                },
                tooltip: 'Sign Out',
                child: const Icon(Icons.logout, color: Colors.white),
              )
              : null),
    );
  }
}
