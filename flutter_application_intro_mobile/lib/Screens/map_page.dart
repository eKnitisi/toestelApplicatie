import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../Services/device_service.dart';
import '../models/device_model.dart';
import '../models/reservation_model.dart';
import '../Screens/device_detail_screen.dart';
import '../services/auth_service.dart';
import '../Services/rental_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _initialLocation = LatLng(51.219815, 4.415956);
  List<DeviceModel> _devices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() {
      _loading = true;
    });

    try {
      final user = await AuthService.getCurrentUser();
      if (user == null) {
        throw Exception('User not logged in');
      }

      final devices = await DeviceService.getDevices();
      List<DeviceModel> filteredDevices = [];

      for (final device in devices) {
        if (device.ownerId == user.uid) {
          continue;
        }

        final reservations = await RentalService.getRentalsForDevice(device.id);
        if (_hasAvailableDates(device, reservations)) {
          filteredDevices.add(device);
        }
      }

      setState(() {
        _devices = filteredDevices;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading devices: $e')));
    }
  }

  bool _hasAvailableDates(
    DeviceModel device,
    List<ReservationModel> reservations,
  ) {
    final reservedDays = <DateTime>{};
    for (var r in reservations) {
      for (
        DateTime d = r.startDate;
        !d.isAfter(r.endDate);
        d = d.add(const Duration(days: 1))
      ) {
        reservedDays.add(DateTime(d.year, d.month, d.day));
      }
    }

    for (
      DateTime d = device.availableFrom;
      !d.isAfter(device.availableTo);
      d = d.add(const Duration(days: 1))
    ) {
      final day = DateTime(d.year, d.month, d.day);
      if (!reservedDays.contains(day)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      center: _initialLocation,
                      zoom: 13.0,
                      interactiveFlags: InteractiveFlag.all,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers:
                            _devices
                                .where(
                                  (device) =>
                                      device.latitude != null &&
                                      device.longitude != null,
                                )
                                .map(
                                  (device) => Marker(
                                    width: 120,
                                    height: 80, // iets hoger dan 60
                                    point: LatLng(
                                      device.latitude!,
                                      device.longitude!,
                                    ),
                                    builder:
                                        (ctx) => GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        DeviceDetailsScreen(
                                                          device: device,
                                                        ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            mainAxisSize:
                                                MainAxisSize
                                                    .min, // voorkomt dat de column de max hoogte gebruikt
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ), // minder padding
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  device.title,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.red,
                                                size: 36,
                                              ),
                                            ],
                                          ),
                                        ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
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
                ],
              ),
    );
  }
}
