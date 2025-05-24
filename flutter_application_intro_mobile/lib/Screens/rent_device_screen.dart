import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Widgets/base_scaffold.dart';
import 'package:intl/intl.dart';
import '../models/device_model.dart';
import '../models/reservation_model.dart';
import '../Services/rental_service.dart';
import '../services/auth_service.dart';

class CreateReservationScreen extends StatefulWidget {
  final DeviceModel device;

  const CreateReservationScreen({super.key, required this.device});

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  bool _isSubmitting = false;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate =
        isStart
            ? (_startDate ?? DateTime.now())
            : (_endDate ??
                (_startDate ?? DateTime.now()).add(const Duration(days: 1)));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.device.availableFrom,
      lastDate: widget.device.availableTo,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitReservation() async {
    if (_startDate == null || _endDate == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final user = await AuthService.getCurrentUser();
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    final reservation = ReservationModel(
      id: '',
      deviceId: widget.device.id,
      renterId: user.uid,
      ownerId: widget.device.ownerId,
      startDate: _startDate!,
      endDate: _endDate!,
      status: 'pending',
    );

    await RentalService.createReservation(reservation);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Reservation requested!')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.device.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _startDate == null
                    ? 'Select start date'
                    : 'Start: ${_dateFormat.format(_startDate!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text(
                _endDate == null
                    ? 'Select end date'
                    : 'End: ${_dateFormat.format(_endDate!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  _startDate != null && _endDate != null && !_isSubmitting
                      ? _submitReservation
                      : null,
              child:
                  _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Reserve'),
            ),
          ],
        ),
      ),
    );
  }
}
