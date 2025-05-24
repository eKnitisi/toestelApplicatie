import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Services/auth_service.dart';
import 'package:flutter_application_intro_mobile/Widgets/image_placeholder.dart';
import '../models/device_model.dart'; // import your DeviceModel

class ListingsTab extends StatefulWidget {
  const ListingsTab({super.key});

  @override
  State<ListingsTab> createState() => _ListingsTabState();
}

class _ListingsTabState extends State<ListingsTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream:
          _firestore
              .collection('devices')
              .where('ownerId', isEqualTo: _currentUserId)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text("You have no listings yet."));
        }

        final devices =
            docs.map((doc) => DeviceModel.fromMap(doc.id, doc.data())).toList();

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
                          // If the URL fails to load, fallback to placeholder
                          return ImagePlaceholder();
                        },
                      )
                      : ImagePlaceholder(),
              title: Text(device.title),
              subtitle: Text(
                "\$${device.pricePerDay.toStringAsFixed(2)} per day",
              ),
              onTap: () {
                // TODO: Navigate to details or edit page
              },
            );
          },
        );
      },
    );
  }
}
