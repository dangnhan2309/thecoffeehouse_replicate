class Store {
  final int id;
  final String name;
  final String address;
  final String? city;
  final String? district;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final String? openTime;
  final String? closeTime;

  Store({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.district,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.openTime,
    this.closeTime,
  });
}
