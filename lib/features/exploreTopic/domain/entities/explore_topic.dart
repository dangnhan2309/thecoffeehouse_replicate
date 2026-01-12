class ExploreTopic {
  final int id;
  final String title;
  final String imageUrl;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  const ExploreTopic({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.isActive,
    required this.createdAt,
  });

}