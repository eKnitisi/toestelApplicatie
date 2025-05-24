import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Screens/choose_location_page.dart';
import '../Widgets/base_scaffold.dart';
import '../Widgets/date_picker.dart';
import '../models/device_model.dart';
import '../Services/auth_service.dart';
import '../Services/device_service.dart'; // DeviceService importeren
import 'package:latlong2/latlong.dart';

class AddRentalScreen extends StatefulWidget {
  const AddRentalScreen({super.key});

  @override
  State<AddRentalScreen> createState() => _AddRentalScreenState();
}

class _AddRentalScreenState extends State<AddRentalScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _categories = [
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
  String? _selectedCategory;
  DateTime? _availableFrom;
  DateTime? _availableTo;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  double? _latitude;
  double? _longitude;

  Future<void> _pickFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _availableFrom ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _availableFrom) {
      setState(() {
        _availableFrom = picked;
        if (_availableTo != null && _availableTo!.isBefore(picked)) {
          _availableTo = null;
        }
      });
    }
  }

  Future<void> _pickToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _availableTo ?? (_availableFrom ?? DateTime.now()),
      firstDate: _availableFrom ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _availableTo) {
      setState(() {
        _availableTo = picked;
      });
    }
  }

  Future<void> _chooseLocation() async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPage()),
    );

    if (selectedLocation != null) {
      setState(() {
        _latitude = selectedLocation.latitude;
        _longitude = selectedLocation.longitude;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_availableFrom == null || _availableTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both availability dates')),
      );
      return;
    }

    if (_availableTo!.isBefore(_availableFrom!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Available To date must be after Available From date'),
        ),
      );
      return;
    }

    final double? price = double.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please choose a location')));
      return;
    }

    final currentUser = await AuthService.getCurrentUser();
    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    final imageUrl =
        _imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : 'https://via.placeholder.com/150';

    final device = DeviceModel(
      id: '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      address: _addressController.text.trim(),
      latitude: _latitude ?? 0.0, // hier gebruik je de echte coords
      longitude: _longitude ?? 0.0,
      pricePerDay: price,
      imageUrl: imageUrl,
      ownerId: currentUser.uid,
      availableFrom: _availableFrom!,
      availableTo: _availableTo!,
    );

    try {
      await DeviceService.addDevice(device);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device added successfully!')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add device: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Add Device',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(60.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_titleController, 'Title'),
              _buildTextField(
                _descriptionController,
                'Description',
                maxLines: 3,
              ),
              _buildTextField(_addressController, 'Address'),

              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _chooseLocation,
                      icon: const Icon(Icons.location_on),
                      label: const Text('Choose Location'),
                    ),
                    if (_latitude != null && _longitude != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected location: ($_latitude, $_longitude)',
                        ),
                      ),
                  ],
                ),
              ),

              _buildTextField(
                _priceController,
                'Price per day (€)',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(_imageUrlController, 'Image URL (optional)'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items:
                    _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator:
                    (value) =>
                        value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              DatePickerField(
                label: 'Available From',
                date: _availableFrom,
                onTap: () => _pickFromDate(context),
              ),
              DatePickerField(
                label: 'Available To',
                date: _availableTo,
                onTap: () => _pickToDate(context),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }
}
