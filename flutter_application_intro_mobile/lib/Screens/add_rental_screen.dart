import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Widgets/base_scaffold.dart';
import '../Widgets/date_picker.dart';
import '../models/device_model.dart';
import '../Services/auth_service.dart';

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
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

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
      id: '', // Will be set by Firestore doc ID
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      location: _locationController.text.trim(),
      pricePerDay: price,
      imageUrl: imageUrl,
      ownerId: currentUser.uid,
      availableFrom: _availableFrom!,
      availableTo: _availableTo!,
    );

    try {
      final docRef = FirebaseFirestore.instance.collection('devices').doc();
      await docRef.set(device.toMap());

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
              _buildTextField(_locationController, 'Location'),
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
