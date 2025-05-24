import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/device_model.dart';
import '../Services/rental_service.dart';
import '../services/auth_service.dart';
import '../Widgets/base_scaffold.dart';
import '../Screens/rent_device_screen.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final DeviceModel device;

  const DeviceDetailsScreen({super.key, required this.device});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  String? currentUserId;
  List<DateTime> _blockedDates = [];
  bool _loadingBlockedDates = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadBlockedDates();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    if (mounted) {
      setState(() {
        currentUserId = user?.uid;
      });
    }
  }

  Future<void> _loadBlockedDates() async {
    setState(() {
      _loadingBlockedDates = true;
    });
    final reservations = await RentalService.getRentalsForDevice(
      widget.device.id,
    );

    List<DateTime> blocked = [];
    for (var r in reservations) {
      // Voeg alle dagen van start t/m end toe
      for (
        DateTime d = r.startDate;
        !d.isAfter(r.endDate);
        d = d.add(const Duration(days: 1))
      ) {
        blocked.add(d);
      }
    }

    if (mounted) {
      setState(() {
        _blockedDates = blocked;
        _loadingBlockedDates = false;
      });
    }
  }

  bool _isDateBlocked(DateTime day) {
    return _blockedDates.any((blockedDay) => isSameDay(blockedDay, day));
  }

  void _showAvailableDates() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child:
                _loadingBlockedDates
                    ? const Center(child: CircularProgressIndicator())
                    : TableCalendar(
                      firstDay: widget.device.availableFrom,
                      lastDay: widget.device.availableTo,
                      focusedDay: DateTime.now(),
                      enabledDayPredicate: (day) => !_isDateBlocked(day),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final isBlocked = _isDateBlocked(day);
                          return Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color:
                                  isBlocked
                                      ? Colors.red.withValues(alpha: 0.5)
                                      : Colors.green.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color:
                                    isBlocked
                                        ? Colors.red.shade900
                                        : Colors.green.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        todayBuilder: (context, day, focusedDay) {
                          final isBlocked = _isDateBlocked(day);
                          return Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color:
                                  isBlocked
                                      ? Colors.red.withOpacity(0.7)
                                      : Colors.green.withOpacity(0.7),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color:
                                    isBlocked
                                        ? Colors.red.shade900
                                        : Colors.green.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        disabledBuilder: (context, day, focusedDay) {
                          return Container(
                            margin: const EdgeInsets.all(6),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        );
      },
    );
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
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.broken_image,
                  size: 80,
                  color: Colors.grey,
                ),
              );
            },
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
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadingBlockedDates ? null : _showAvailableDates,
            child: const Text("Show Available Dates"),
          ),
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
