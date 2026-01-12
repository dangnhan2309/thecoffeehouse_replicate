class OrderItem {
  final int id; // OrderDetail ID from backend
  final int productId;
  final String productName;
  int quantity;
  final double price;
  final String? size;
  final String? ice;
  final String? sugar;
  final List<String>? toppings;
  final String? note;
  final String? productImage;
  bool isSelected;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.size,
    this.ice,
    this.sugar,
    this.toppings,
    this.note,
    this.productImage,
    this.isSelected = true,
  });

  double get totalPrice => price * quantity;

  OrderItem copyWith({
    int? id,
    int? productId,
    String? productName,
    int? quantity,
    double? price,
    String? size,
    String? ice,
    String? sugar,
    List<String>? toppings,
    String? note,
    String? productImage,
    bool? isSelected,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      size: size ?? this.size,
      ice: ice ?? this.ice,
      sugar: sugar ?? this.sugar,
      toppings: toppings ?? this.toppings,
      note: note ?? this.note,
      productImage: productImage ?? this.productImage,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
