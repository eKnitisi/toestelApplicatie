import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Widgets/base_scaffold.dart';
import 'package:flutter_application_intro_mobile/Screens/add_rental_screen.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: title,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(context, "Add an appliance to rent out", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddRentalScreen(),
                  ),
                );
              }),
              const SizedBox(height: 24),
              _buildButton(context, "View all listings", () {
                Navigator.pushNamed(context, '/allListings');
              }),
              const SizedBox(height: 24),
              _buildButton(context, "View all listings on map", () {
                Navigator.pushNamed(context, '/map');
              }),

              const SizedBox(height: 24),
              _buildButton(context, "Rental Dashboard", () {
                Navigator.pushNamed(context, '/dashboard');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: BaseScaffold.buttonBlue,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
