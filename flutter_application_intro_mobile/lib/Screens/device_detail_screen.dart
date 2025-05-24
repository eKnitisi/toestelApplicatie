import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Widgets/base_scaffold.dart';
import '../models/device_model.dart';
import '../screens/rent_device_screen.dart';
import '../services/auth_service.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final DeviceModel device;

  const DeviceDetailsScreen({super.key, required this.device});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    if (mounted) {
      setState(() {
        currentUserId = user?.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.device.ownerId == currentUserId;

    return BaseScaffold(
      body: Column(
        children: [
          Image.network(
            widget.device.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text(
            widget.device.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.device.description),
          const SizedBox(height: 16),
          Text("€${widget.device.pricePerDay.toStringAsFixed(2)} / day"),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child:
                isOwner
                    ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "This is your device",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => CreateReservationScreen(
                                    device: widget.device,
                                  ),
                            ),
                          );
                        },
                        child: const Text("Rent this device"),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
