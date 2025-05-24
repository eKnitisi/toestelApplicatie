import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Services/device_service.dart';
import 'package:flutter_application_intro_mobile/models/device_model.dart';
import '../Services/auth_service.dart';
import '../Services/rental_service.dart';
import '../models/reservation_model.dart';
import '../Screens/rental_detail_screen.dart';

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

  Future<List<Map<String, dynamic>>> _getRentalsWithDevices(
    String userId,
  ) async {
    final rentals = await RentalService.getRentalsForUser(userId);
    List<Map<String, dynamic>> combinedList = [];

    for (var rental in rentals) {
      final device = await DeviceService.getDeviceById(rental.deviceId);
      combinedList.add({'rental': rental, 'device': device});
    }
    return combinedList;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRentalsWithDevices(_currentUserId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final rentalsWithDevices = snapshot.data ?? [];

        if (rentalsWithDevices.isEmpty) {
          return const Center(child: Text("You have no rentals yet."));
        }

        return ListView.builder(
          itemCount: rentalsWithDevices.length,
          itemBuilder: (context, index) {
            final rental =
                rentalsWithDevices[index]['rental'] as ReservationModel;
            final device = rentalsWithDevices[index]['device'] as DeviceModel?;

            return ListTile(
              leading: const Icon(Icons.device_hub),
              title: Text('Device: ${device?.title ?? 'Unknown name'}'),
              subtitle: Text(
                '${DateHelpers(rental.startDate.toLocal()).toShortDateString()} - ${DateHelpers(rental.endDate.toLocal()).toShortDateString()}',
              ),
              trailing: Text(rental.status),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => RentalDetailScreen(
                          reservation: rental,
                          device:
                              device ??
                              DeviceModel(
                                id: '',
                                title: 'Unknown Device',
                                ownerId: '',
                                pricePerDay: 0.0,
                                imageUrl: '',
                                description: '',
                                category: '',
                                address: '',
                                latitude: 0.0,
                                longitude: 0.0,
                                availableFrom: DateTime.now(),
                                availableTo: DateTime.now().add(
                                  const Duration(days: 1),
                                ),
                              ),
                        ),
                  ),
                );
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
    return "$day/$month/$year";
  }
}
