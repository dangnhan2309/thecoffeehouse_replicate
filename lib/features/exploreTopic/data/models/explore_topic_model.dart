import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';

class ExploreTopicModel extends ExploreTopic {
  const ExploreTopicModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.description,
    required super.isActive,
    required super.createdAt,
  });

  factory ExploreTopicModel.fromJson(Map<String, dynamic> json) {
    return ExploreTopicModel(
      id: json['id'] ?? 0, // Đảm bảo không bị null
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
