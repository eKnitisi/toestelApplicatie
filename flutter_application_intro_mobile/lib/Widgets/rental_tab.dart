import 'package:flutter/material.dart';

class RentalsTab extends StatelessWidget {
  const RentalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real rentals data from Firestore
    final rentals = [
      {
        'title': 'Device A',
        'rentalPeriod': 'May 1 - May 10',
        'status': 'Approved',
      },
      {
        'title': 'Device B',
        'rentalPeriod': 'June 5 - June 15',
        'status': 'Pending',
      },
    ];

    return ListView.builder(
      itemCount: rentals.length,
      itemBuilder: (context, index) {
        final rental = rentals[index];
        return ListTile(
          leading: const Icon(Icons.device_hub),
          title: Text(rental['title']!),
          subtitle: Text(rental['rentalPeriod']!),
          trailing: Text(rental['status']!),
          onTap: () {
            // TODO: Navigate to rental details or actions
          },
        );
      },
    );
  }
}
