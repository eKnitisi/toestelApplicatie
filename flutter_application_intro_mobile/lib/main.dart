import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_intro_mobile/Screens/add_rental_screen.dart';
import 'package:flutter_application_intro_mobile/Screens/home_screen.dart';
import 'package:flutter_application_intro_mobile/Screens/map_page.dart';
import 'package:flutter_application_intro_mobile/Screens/rental_dashboard.dart';
import 'firebase_options.dart';
import 'Screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => MyHomePage(title: 'Home'),
        '/reservations':
            (context) => const MyHomePage(title: 'My Reservations'),
        '/dashboard':
            (context) => const RentalDashboard(title: 'Rental Dashboard'),
        '/addRental': (context) => const AddRentalScreen(),
        '/map': (context) => const MapPage(),
      },
    );
  }
}
