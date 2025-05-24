class DeviceModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
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
    required this.location,
    required this.pricePerDay,
    required this.imageUrl,
    required this.ownerId,
    required this.availableFrom,
    required this.availableTo,
  });

  factory DeviceModel.fromMap(String id, Map<String, dynamic> map) {
    return DeviceModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
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
      'location': location,
      'pricePerDay': pricePerDay,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
    };
  }
}
