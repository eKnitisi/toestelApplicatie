import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import '../Services/rental_service.dart';
import '../models/reservation_model.dart';

class RentalsTab extends StatefulWidget {
  const RentalsTab({super.key});

  @override
  State<RentalsTab> createState() => _RentalsTabState();
}

class _RentalsTabState extends State<RentalsTab> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<ReservationModel>>(
      future: RentalService.getRentalsForUser(_currentUserId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final rentals = snapshot.data ?? [];

        if (rentals.isEmpty) {
          return const Center(child: Text("You have no rentals yet."));
        }

        return ListView.builder(
          itemCount: rentals.length,
          itemBuilder: (context, index) {
            final rental = rentals[index];
            return ListTile(
              leading: const Icon(Icons.device_hub),
              title: Text(
                'Device ID: ${rental.deviceId}',
              ), // Voor nu deviceId tonen, kan je uitbreiden met device details
              subtitle: Text(
                '${rental.startDate.toLocal().toShortDateString()} - ${rental.endDate.toLocal().toShortDateString()}',
              ),
              trailing: Text(rental.status),
              onTap: () {
                // TODO: Navigate to rental details or actions
              },
            );
          },
        );
      },
    );
  }
}

extension DateHelpers on DateTime {
  String toShortDateString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}
