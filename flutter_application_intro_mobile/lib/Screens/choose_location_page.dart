import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _selectedLocation;
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ),
      );
      setState(() {
        _loadingLocation = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        setState(() {
          _loadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied'),
        ),
      );
      setState(() {
        _loadingLocation = false;
      });
      return;
    }

    // Permissions granted, get position
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _loadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingLocation) {
      return Scaffold(
        appBar: AppBar(title: Text('Select a location')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_selectedLocation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select a location')),
        body: const Center(child: Text('Could not determine location')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Select a location")),
      body: FlutterMap(
        options: MapOptions(
          center: _selectedLocation,
          zoom: 15.0,
          onTap: (tapPosition, point) {
            setState(() {
              _selectedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedLocation!,
                width: 80,
                height: 80,
                builder:
                    (ctx) => const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
        icon: const Icon(Icons.check),
        label: const Text("Confirm"),
      ),
    );
  }
}
