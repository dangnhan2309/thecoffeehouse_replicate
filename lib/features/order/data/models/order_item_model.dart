import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required int id,
    required int productId,
    required String productName,
    required int quantity,
    required double price,
    String? size,
    String? ice,
    String? sugar,
    List<String>? toppings,
    String? note,
    String? productImage,
  }) : super(
    id: id,
    productId: productId,
    productName: productName,
    quantity: quantity,
    price: price,
    size: size,
    ice: ice,
    sugar: sugar,
    toppings: toppings,
    note: note,
    productImage: productImage,
  );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    // Ưu tiên lấy từ các key phổ biến của Backend
    String? rawName = json['product_name'] ?? json['name'] ?? json['product']?['name'];
    String? rawImage = json['product_image'] ?? json['image_url'] ?? json['product']?['image_url'];
    
    String? imageUrl;
    if (rawImage != null && rawImage.isNotEmpty) {
      if (rawImage.startsWith('http')) {
        imageUrl = rawImage;
      } else {
        // Xử lý nếu chỉ là tên file
        imageUrl = "${AppConfig.baseUrl}/static/$rawImage";
      }
    }

    return OrderItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? json['productId'] ?? 0,
      productName: rawName ?? 'Sản phẩm',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      size: json['size'],
      ice: json['ice'],
      sugar: json['sugar'],
      toppings: json['toppings'] != null
          ? List<String>.from(json['toppings'])
          : null,
      note: json['note'],
      productImage: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    // Trích xuất chỉ lấy tên file ảnh để gửi lên server nếu cần
    String? fileName;
    if (productImage != null) {
      fileName = productImage!.split('/').last;
    }

    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': fileName,
      'quantity': quantity,
      'price': price,
      'size': size,
      'ice': ice,
      'sugar': sugar,
      'toppings': toppings,
      'note': note,
    };
  }
}
