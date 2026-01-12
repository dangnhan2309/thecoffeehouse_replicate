import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/widgets/order_item_widget.dart';
import 'package:nhom2_thecoffeehouse/core/utils/currency_formatter.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/screens/order_history_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final cart = orderProvider.cart;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _buildBody(orderProvider),
      bottomNavigationBar: cart != null && cart.items.isNotEmpty
          ? _buildBottomBar(orderProvider)
          : null,
    );
  }

  Widget _buildBody(OrderProvider orderProvider) {
    final cart = orderProvider.cart;

    if (orderProvider.isLoading && cart == null) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFF26522)));
    }

    if (orderProvider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'Lỗi: ${orderProvider.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => orderProvider.loadCart(),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF26522)),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (cart == null || cart.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://minio.thecoffeehouse.com/static/tea-break/images/empty-cart.png',
              width: 200,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text('Giỏ hàng trống', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),
            const Text('Hãy thêm sản phẩm vào giỏ hàng', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final OrderItem item = cart.items[index];
        return OrderItemWidget(
          item: item,
          onIncrease: () {
            orderProvider.updateCartItem(item.productId, quantity: item.quantity + 1);
          },
          onDecrease: () {
            if (item.quantity > 1) {
              orderProvider.updateCartItem(item.productId, quantity: item.quantity - 1);
            } else {
              orderProvider.removeFromCart(item.productId);
            }
          },
          onRemove: () {
            orderProvider.removeFromCart(item.productId);
          },
          onToggleSelection: (selected) {
            orderProvider.toggleItemSelection(item.productId);
          },
        );
      },
    );
  }

  Widget _buildBottomBar(OrderProvider orderProvider) {
    final double total = orderProvider.selectedTotal;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                CurrencyFormatter.formatVND(total),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF26522),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF26522),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: orderProvider.isLoading || total == 0
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await orderProvider.checkoutCash();

                      if (!mounted) return;

                      if (orderProvider.error == null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>  const OrderHistoryScreen()),
                        );
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Thanh toán thành công!'), backgroundColor: Colors.green),
                        );
                      } else {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Lỗi: ${orderProvider.error}'), backgroundColor: Colors.red),
                        );
                      }
                    },
              child: orderProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                    )
                  : const Text(
                      'THANH TOÁN TIỀN MẶT',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
