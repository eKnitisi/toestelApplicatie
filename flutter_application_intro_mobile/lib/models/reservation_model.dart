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
    return ReservationModel(
      id: id,
      deviceId: map['deviceId'],
      renterId: map['renterId'],
      ownerId: map['ownerId'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      status: map['status'],
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
