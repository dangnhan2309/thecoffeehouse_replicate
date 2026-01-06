// Model
class ExploreTopic {
  final int id;
  final String title;
  final String imageUrl;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  ExploreTopic({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.isActive,
    required this.createdAt,
  });

  factory ExploreTopic.fromJson(Map<String, dynamic> json) {
    return ExploreTopic(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      description: json['description'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}