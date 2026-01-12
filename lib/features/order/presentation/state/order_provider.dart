import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/remove_from_cart.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/update_cart_item.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/add_to_cart.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/checkout_cash.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/get_cart.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/repositories/product_repository.dart';
import 'package:nhom2_thecoffeehouse/features/vourcher/domain/entities/voucher.dart';

class OrderProvider extends ChangeNotifier {
  final AddToCartUseCase addToCartUseCase;
  final GetCartUseCase getCartUseCase;
  final CheckoutCashUseCase checkoutCashUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final ProductRepository productRepository;

  OrderProvider({
    required this.addToCartUseCase,
    required this.getCartUseCase,
    required this.checkoutCashUseCase,
    required this.removeFromCartUseCase,
    required this.updateCartItemUseCase,
    required this.productRepository,
  });

  Order? _cart;
  bool isLoading = false;
  String? error;
  Voucher? _selectedVoucher;

  Order? get cart => _cart;
  Voucher? get selectedVoucher => _selectedVoucher;

  int get cartItemCount {
    if (_cart == null) return 0;
    return _cart!.items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  double get subTotal {
    if (_cart == null) return 0;
    return _cart!.items.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get selectedTotal {
    if (_cart == null) return 0;
    return _cart!.items
        .where((item) => item.isSelected)
        .fold<double>(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get discountAmount {
    if (_selectedVoucher == null) return 0;
    if (selectedTotal < _selectedVoucher!.minOrderValue) return 0;
    return _selectedVoucher!.discountAmount;
  }

  double get finalTotal {
    double total = selectedTotal - discountAmount;
    return total > 0 ? total : 0;
  }

  void applyVoucher(Voucher? voucher) {
    _selectedVoucher = voucher;
    notifyListeners();
  }

  Future<void> loadCart() async {
    isLoading = true;
    notifyListeners();
    try {
      final cartData = await getCartUseCase();
      
      if (cartData.items.isNotEmpty) {
        final productIds = cartData.items.map((item) => item.productId).toSet().toList();
        
        final products = await productRepository.getProductsByIds(productIds);
        final productMap = {for (var p in products) p.id: p};

        final updatedItems = cartData.items.map((item) {
          final productInfo = productMap[item.productId];
          if (productInfo != null) {
            return item.copyWith(
              productName: productInfo.name,
              productImage: productInfo.imageUrl,
            );
          }
          return item;
        }).toList();

        _cart = Order(
          id: cartData.id,
          userId: cartData.userId,
          items: updatedItems,
          status: cartData.status,
          createdAt: cartData.createdAt,
        );
      } else {
        _cart = cartData;
      }
      
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleItemSelection(int productId) {
    if (_cart == null) return;
    final index = _cart!.items.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      _cart!.items[index].isSelected = !_cart!.items[index].isSelected;
      notifyListeners();
    }
  }

  Future<void> addProduct(
      Product product, {
        int quantity = 1,
        SizeOption? size,
        IceOption? ice,
        SugarOption? sugar,
        List<String>? toppings,
        double toppingPrice = 0,
        String? note,
      }) async {
    try {
      double basePrice = product.priceBySize(size) ?? product.price ?? 0.0;
      double itemPrice = basePrice + toppingPrice;

      final orderItem = OrderItem(
        id: 0, 
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        price: itemPrice,
        size: _enumToString(size),
        ice: _enumToString(ice),
        sugar: _enumToString(sugar),
        toppings: toppings,
        note: note,
        productImage: product.imageUrl,
      );

      await addToCartUseCase(orderItem);
      await loadCart();
      error = null;
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateCartItem(
      int productId, {
        int? quantity,
        SizeOption? size,
        IceOption? ice,
        SugarOption? sugar,
        List<String>? toppings,
        String? note,
      }) async {
    try {
      await updateCartItemUseCase(
        productId,
        quantity: quantity,
        size: size,
        ice: ice,
        sugar: sugar,
        toppings: toppings,
        note: note,
      );
      await loadCart();
      error = null;
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      await removeFromCartUseCase(productId);
      await loadCart();
      error = null;
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }


  Future<void> checkoutCash() async {
    if (_cart == null) return;

    isLoading = true;
    notifyListeners();

    try {
      await checkoutCashUseCase();
      _cart = null; 
      _selectedVoucher = null; // Clear voucher after checkout
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  String? _enumToString(dynamic enumValue) {
    if (enumValue == null) return null;
    return enumValue.toString().split('.').last;
  }
}
