import 'package:flutter/material.dart';
import 'package:flutter_application_intro_mobile/Widgets/base_scaffold.dart';
import '../models/reservation_model.dart';
import '../models/device_model.dart';
import '../Services/rental_service.dart';
import '../Services/auth_service.dart';

class RentalDetailScreen extends StatefulWidget {
  final ReservationModel reservation;
  final DeviceModel device;

  const RentalDetailScreen({
    super.key,
    required this.reservation,
    required this.device,
  });

  @override
  State<RentalDetailScreen> createState() => _RentalDetailScreenState();
}

class _RentalDetailScreenState extends State<RentalDetailScreen> {
  bool _isLoading = false;
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

  Future<void> _acceptRental() async {
    setState(() {
      _isLoading = true;
    });

    final updatedReservation = ReservationModel(
      id: widget.reservation.id,
      deviceId: widget.reservation.deviceId,
      renterId: widget.reservation.renterId,
      ownerId: widget.reservation.ownerId,
      startDate: widget.reservation.startDate,
      endDate: widget.reservation.endDate,
      status: 'approved',
    );

    try {
      await RentalService.updateReservation(updatedReservation);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Rental accepted!')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to accept rental: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservation = widget.reservation;
    final device = widget.device;

    // Wacht tot we de userId hebben geladen
    if (_currentUserId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isOwner = _currentUserId == reservation.ownerId;
    final isRenter = _currentUserId == reservation.renterId;

    return BaseScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
        child: ListView(
          children: [
            Text(
              device.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(device.description, style: const TextStyle(fontSize: 16)),
            const Divider(height: 32),
            Text(
              'Rental period:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${reservation.startDate.toLocal().toShortDateString()} - ${reservation.endDate.toLocal().toShortDateString()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${reservation.status}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (reservation.status == 'pending' && isOwner)
              ElevatedButton(
                onPressed: _isLoading ? null : _acceptRental,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Accept Rental'),
              )
            else if (isRenter)
              Text(
                'Rental status: ${reservation.status}',
                style: const TextStyle(fontSize: 16),
              )
            else
              const Text(
                'This rental has already been processed.',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

extension DateHelpers on DateTime {
  String toShortDateString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}
