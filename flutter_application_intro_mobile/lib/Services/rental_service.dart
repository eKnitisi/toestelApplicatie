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
}
