import '../../domain/entities/store.dart';

class StoreModel extends Store {
  StoreModel({
    required super.id,
    required super.name,
    required super.address,
    super.city,
    super.district,
    super.latitude,
    super.longitude,
    super.imageUrl,
    super.openTime,
    super.closeTime,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      district: json['district'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      imageUrl: json['image_url'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
    );
  }
}
