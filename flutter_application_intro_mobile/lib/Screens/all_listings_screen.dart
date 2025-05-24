import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Widgets/base_scaffold.dart';
import '../models/device_model.dart';
import '../Services/device_service.dart';
import '../Screens/device_detail_screen.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({Key? key}) : super(key: key);

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  List<DeviceModel> _allDevices = [];
  List<DeviceModel> _filteredDevices = [];
  String? _selectedCategory;
  String _locationFilter = '';

  final List<String> _categories = [
    'All',
    'Kitchen',
    'Cleaning',
    'Entertainment',
    'Gardening',
    'Electronics',
    'Tools',
    'Furniture',
    'Sports',
    'Baby & Kids',
    'Party & Events',
    'Other',
  ];

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
      final devices = await DeviceService.getDevices();
      setState(() {
        _allDevices = devices;
        _filteredDevices = devices;
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

  void _applyFilters() {
    List<DeviceModel> filtered = _allDevices;

    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered =
          filtered
              .where((device) => device.category == _selectedCategory)
              .toList();
    }

    if (_locationFilter.isNotEmpty) {
      filtered =
          filtered
              .where(
                (device) => device.address.toLowerCase().contains(
                  _locationFilter.toLowerCase(),
                ),
              )
              .toList();
    }
    setState(() {
      _filteredDevices = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedCategory ?? 'All',
                              items:
                                  _categories
                                      .map(
                                        (cat) => DropdownMenuItem<String>(
                                          value: cat,
                                          child: Text(
                                            cat,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                  _applyFilters();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 300,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Filter by location',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _locationFilter = value;
                                _applyFilters();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                        _filteredDevices.isEmpty
                            ? const Center(child: Text('No listings found.'))
                            : ListView.builder(
                              itemCount: _filteredDevices.length,
                              itemBuilder: (context, index) {
                                final device = _filteredDevices[index];
                                return ListTile(
                                  title: Text(device.title),
                                  subtitle: Text(
                                    '${device.category} — ${device.address}',
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DeviceDetailsScreen(
                                              device: device,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
