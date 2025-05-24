import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';

class DeviceService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _devicesCollection = _firestore.collection(
    'devices',
  );

  static Future<List<DeviceModel>> getDevices({String? ownerId}) async {
    Query query = _devicesCollection;

    if (ownerId != null && ownerId.isNotEmpty) {
      query = query.where('ownerId', isEqualTo: ownerId);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs.map((doc) {
      return DeviceModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  static Future<DeviceModel?> getDeviceById(String deviceId) async {
    final doc = await _devicesCollection.doc(deviceId).get();

    if (doc.exists && doc.data() != null) {
      return DeviceModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Future<void> addDevice(DeviceModel device) async {
    final docRef = _devicesCollection.doc();

    final deviceWithId = DeviceModel(
      id: docRef.id,
      title: device.title,
      description: device.description,
      category: device.category,
      address: device.address,
      latitude: device.latitude,
      longitude: device.longitude,
      pricePerDay: device.pricePerDay,
      imageUrl: device.imageUrl,
      ownerId: device.ownerId,
      availableFrom: device.availableFrom,
      availableTo: device.availableTo,
    );

    await docRef.set(deviceWithId.toMap());
  }

  static Future<void> updateDevice(DeviceModel device) async {
    final docRef = _devicesCollection.doc(device.id);
    await docRef.update(device.toMap());
  }

  static Future<void> deleteDevice(String deviceId) async {
    await _devicesCollection.doc(deviceId).delete();
  }
}
