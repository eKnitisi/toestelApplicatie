class DeviceModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String address;
  final double? latitude;
  final double? longitude;
  final double pricePerDay;
  final String imageUrl;
  final String ownerId;
  final DateTime availableFrom;
  final DateTime availableTo;

  DeviceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerDay,
    required this.imageUrl,
    required this.ownerId,
    required this.availableFrom,
    required this.availableTo,
  });

  factory DeviceModel.fromMap(String id, Map<String, dynamic> map) {
    final location = map['location'] as Map<String, dynamic>? ?? {};
    return DeviceModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      address: map['address'] ?? '',
      latitude: (location['latitude'] ?? 0).toDouble(),
      longitude: (location['longitude'] ?? 0).toDouble(),
      pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      ownerId: map['ownerId'] ?? '',
      availableFrom: DateTime.parse(map['availableFrom']),
      availableTo: DateTime.parse(map['availableTo']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'address': address,
      'location': {'latitude': latitude, 'longitude': longitude},
      'pricePerDay': pricePerDay,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
    };
  }
}
