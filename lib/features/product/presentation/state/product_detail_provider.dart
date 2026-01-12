import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';
import 'package:nhom2_thecoffeehouse/core/utils/currency_formatter.dart';

class ProductDetailProvider extends ChangeNotifier {
  final GetProductsByCategoryUseCase getProductsByCategory;

  ProductDetailProvider({required this.getProductsByCategory});

  Product? baseProduct;
  bool isLoading = true;

  int quantity = 1;

  SizeOption selectedSize = SizeOption.medium;
  IceOption selectedIce = IceOption.normal;
  SugarOption selectedSugar = SugarOption.normal;

  /// 🔥 TOPPING = PRODUCT (CATEGORY ID = 12)
  List<Product> toppings = [];
  Set<int> selectedToppingIds = {};

  /// ================= INIT =================
  Future<void> init(Product product) async {
    baseProduct = product;

    /// Load topping products
    toppings = await getProductsByCategory(categoryId: 12);

    isLoading = false;
    notifyListeners();
  }

  /// ================= FORMAT =================
  String formatPrice(double price) => CurrencyFormatter.formatVND(price);

  String formatDescription(String? desc) {
    if (desc == null || desc.isEmpty) return "Không có mô tả.";
    return desc.replaceAll(r'\n', '\n');
  }

  /// ================= SIZE =================
  void setSize(SizeOption size) {
    selectedSize = size;
    notifyListeners();
  }

  /// ================= ICE / SUGAR =================
  void setIce(IceOption ice) {
    selectedIce = ice;
    notifyListeners();
  }

  void setSugar(SugarOption sugar) {
    selectedSugar = sugar;
    notifyListeners();
  }

  /// ================= TOPPING =================
  void toggleTopping(Product topping) {
    if (selectedToppingIds.contains(topping.id)) {
      selectedToppingIds.remove(topping.id);
    } else {
      selectedToppingIds.add(topping.id);
    }
    notifyListeners();
  }

  double get selectedToppingPrice {
    return toppings
        .where((p) => selectedToppingIds.contains(p.id))
        .fold<double>(
      0,
          (sum, p) => sum + (p.price ?? 0),
    );
  }

  /// ================= PRICE =================
  double get basePrice {
    if (baseProduct == null) return 0;

    switch (selectedSize) {
      case SizeOption.small:
        return baseProduct!.priceSmall ?? baseProduct!.price ?? 0;
      case SizeOption.medium:
        return baseProduct!.priceMedium ?? baseProduct!.price ?? 0;
      case SizeOption.large:
        return baseProduct!.priceLarge ?? baseProduct!.price ?? 0;
    }
  }

  double get totalPrice =>
      (basePrice + selectedToppingPrice) * quantity;

  /// ================= QUANTITY =================
  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    if (quantity > 1) quantity--;
    notifyListeners();
  }

  /// ================= MODAL TOPPING =================
  void showToppingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Chọn topping",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  /// LIST TOPPING
                  ...toppings.map((p) {
                    final checked = selectedToppingIds.contains(p.id);
                    return CheckboxListTile(
                      value: checked,
                      activeColor: const Color(0xFFF26522),
                      onChanged: (_) {
                        toggleTopping(p);
                        setModalState(() {});
                      },
                      title: Text(
                        p.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      secondary: Text(
                        "+${formatPrice(p.price ?? 0)}",
                        style: const TextStyle(
                          color: Color(0xFFF26522),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    );
                  }),

                  const SizedBox(height: 12),

                  /// CONFIRM
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF26522),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Xong • +${formatPrice(selectedToppingPrice)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
