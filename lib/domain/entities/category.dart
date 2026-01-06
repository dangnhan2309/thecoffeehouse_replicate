class Category {
  final int id;
  final String name;
  final String? icon;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      imageUrl: json['image_url'],
    );
  }
}
