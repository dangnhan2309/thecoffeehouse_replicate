class Category{
  final int id;
  final String name;
  final String? icon;
  final String? imageUrl;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    this.imageUrl,
  });
}
