import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Screens/add_rental_screen.dart';
import 'package:flutter_application_intro_mobile/Widgets/map_page.dart';
import '../Services/auth_service.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color primaryGreen = Color(0xFF00C853); // helder groen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade600, // zwarte achtergrond
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryGreen),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddRentalScreen()),
                  );
                },
                child: const Text(
                  "Add an appliance to rent",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24), // meer ruimte tussen knoppen
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  );
                },
                child: const Text(
                  "Go to map",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/screen3');
                },
                child: const Text(
                  "Go to Screen 3",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        onPressed: () => AuthService.signOut(context),
        tooltip: 'Sign Out',
        child: const Icon(Icons.logout),
      ),
    );
  }
}
