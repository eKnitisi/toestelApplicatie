import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation_model.dart';

class RentalService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _reservationsCollection = _firestore
      .collection('reservations');

  static Future<List<ReservationModel>> getRentalsForUser(String userId) async {
    final querySnapshot =
        await _reservationsCollection
            .where('renterId', isEqualTo: userId)
            .get();

    return querySnapshot.docs.map((doc) {
      return ReservationModel.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }

  static Future<void> createReservation(ReservationModel reservation) async {
    await _reservationsCollection.add(reservation.toMap());
  }

  static Future<void> updateReservation(ReservationModel reservation) async {
    if (reservation.id.isEmpty) {
      throw Exception('Reservation ID is required for update');
    }
    await _reservationsCollection
        .doc(reservation.id)
        .update(reservation.toMap());
  }

  static Future<List<ReservationModel>> getAllRentals() async {
    final querySnapshot = await _reservationsCollection.get();

    return querySnapshot.docs.map((doc) {
      return ReservationModel.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }
}
