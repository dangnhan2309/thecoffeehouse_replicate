class Promotion {
  final int id;
  final String name;
  final String? description;
  final int? discountPercent;
  final double? discountAmount;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> productIds;
  const Promotion({
    required this.id,
    required this.name,
    this.description,
    this.discountPercent,
    this.discountAmount,
    required this.startDate,
    required this.endDate,
    required this.productIds,
  });
}