class ReservationModel {
  final String id;
  final String deviceId;
  final String renterId;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // pending, approved, etc.

  ReservationModel({
    required this.id,
    required this.deviceId,
    required this.renterId,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory ReservationModel.fromMap(String id, Map<String, dynamic> map) {
    final String deviceId = map['deviceId'] ?? '';
    final String renterId = map['renterId'] ?? '';
    final String ownerId = map['ownerId'] ?? '';
    final String status = map['status'] ?? 'pending';

    final String? startDateStr = map['startDate'];
    final String? endDateStr = map['endDate'];

    DateTime parseDate(String? dateStr, String fallbackLabel) {
      if (dateStr == null) {
        return DateTime.now();
      }

      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    return ReservationModel(
      id: id,
      deviceId: deviceId,
      renterId: renterId,
      ownerId: ownerId,
      startDate: parseDate(startDateStr, 'startDate'),
      endDate: parseDate(endDateStr, 'endDate'),
      status: status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'renterId': renterId,
      'ownerId': ownerId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
    };
  }
}
