class Promotion {
  final int id;
  final String name;
  final String? description;
  final int? discountPercent;
  final double? discountAmount;
  final DateTime startDate;
  final DateTime endDate;

  final List<int> productIds; // ← Thêm field này

  Promotion({
    required this.id,
    required this.name,
    this.description,
    this.discountPercent,
    this.discountAmount,
    required this.startDate,
    required this.endDate,
    required this.productIds, // ← Bắt buộc hoặc optional tùy bạn
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    // Parse promotion_products để lấy danh sách ID sản phẩm
    final productsList = json['promotion_products'] as List<dynamic>? ?? [];
    final productIds = productsList.map<int>((item) {
      final productMap = item['product'] as Map<String, dynamic>?;
      return productMap != null ? productMap['id'] as int : 0;
    }).where((id) => id != 0).toList();

    return Promotion(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      discountPercent: json['discount_percent'] as int?,
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      productIds: productIds,
    );
  }
}