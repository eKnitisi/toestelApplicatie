import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Screens/device_detail_screen.dart';
import '../Services/auth_service.dart';
import '../Services/device_service.dart';
import '../Widgets/image_placeholder.dart';
import '../models/device_model.dart';

class ListingsTab extends StatefulWidget {
  const ListingsTab({super.key});

  @override
  State<ListingsTab> createState() => _ListingsTabState();
}

class _ListingsTabState extends State<ListingsTab> {
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

    return FutureBuilder<List<DeviceModel>>(
      future: DeviceService.getDevices(ownerId: _currentUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final devices = snapshot.data ?? [];

        if (devices.isEmpty) {
          return const Center(child: Text("You have no listings yet."));
        }

        return ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return ListTile(
              leading:
                  device.imageUrl.isNotEmpty
                      ? Image.network(
                        device.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return ImagePlaceholder();
                        },
                      )
                      : ImagePlaceholder(),
              title: Text(device.title),
              subtitle: Text(
                "\$${device.pricePerDay.toStringAsFixed(2)} per day",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceDetailsScreen(device: device),
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
