import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRentalScreen extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Rental')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Rental Name')),
            TextField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addTestDevice(context);
                // Voeg hier je logica toe om het formulier op te slaan of verder te verwerken
                print("Rental Added");
              },
              child: Text('Add Rental'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigeren terug naar het vorige scherm
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addTestDevice(BuildContext context) async {
    final device = <String, dynamic>{
      "deviceName": "Ada Lovelace",
      "description": "Ada",
      "photo": "Lovelace",
      "price": 1815,
      "availability": true,
      "location": {"latitude": 51.5074, "longitude": -0.1278},
    };
    db.collection("devices").add(device).then((DocumentReference doc) {
      print("Device added with ID: ${doc.id}");
    });
  }
}
