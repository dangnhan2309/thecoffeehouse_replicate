import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order_item.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/core/utils/currency_formatter.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/screens/order_history_screen.dart';
import 'package:nhom2_thecoffeehouse/features/vourcher/presentation/screens/voucher_screen.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/widgets/product_detail_item.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/usecases/get_products_by_category.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String selectedPaymentMethod = 'Tiền mặt';

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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Xác nhận đơn hàng',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
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

    if (cart == null || cart.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://minio.thecoffeehouse.com/static/tea-break/images/empty-cart.png',
              width: 150,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text('Giỏ hàng trống', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionHeader('Sản phẩm đã chọn', trailing: _buildAddButton()),
          _buildProductList(orderProvider),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildSummarySection(orderProvider),
          const SizedBox(height: 8),
          _buildPaymentMethodSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7E6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.add, size: 14, color: Color(0xFFF26522)),
            SizedBox(width: 4),
            Text('Thêm', style: TextStyle(color: Color(0xFFF26522), fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(OrderProvider orderProvider) {
    final items = orderProvider.cart?.items ?? [];
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1),
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          final imageUrl = "${AppConfig.baseUrl}/static/${item.productImage}";
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final productsRepo = orderProvider.productRepository;
                        final products = await productsRepo.getProductsByIds([item.productId]);
                        if (products.isNotEmpty && mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: products.first,
                                getProductsByCategory: context.read<GetProductsByCategoryUseCase>(),
                              ),
                            ),
                          ).then((_) => orderProvider.loadCart());
                        }
                      },
                      child: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFFF26522)),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        _showDeleteConfirmation(orderProvider, item);
                      },
                      child: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'x${item.quantity} ${item.productName}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _buildItemOptions(item),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      if (item.note != null && item.note!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Ghi chú: ${item.note}',
                            style: const TextStyle(fontSize: 12, color: Colors.orange, fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  CurrencyFormatter.formatVND(item.price * item.quantity),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(OrderProvider orderProvider, OrderItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${item.productName}" khỏi giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              orderProvider.removeFromCart(item.productId);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _buildItemOptions(OrderItem item) {
    List<String> options = [];
    if (item.size != null) options.add('Size: ${item.size}');
    if (item.ice != null) options.add('Đá: ${item.ice}');
    if (item.sugar != null) options.add('Đường: ${item.sugar}');
    if (item.toppings != null && item.toppings!.isNotEmpty) {
      options.add('Topping: ${item.toppings!.join(", ")}');
    }
    return options.isEmpty ? 'Vừa' : options.join(' • ');
  }

  Widget _buildSummarySection(OrderProvider orderProvider) {
    final subTotal = orderProvider.selectedTotal;
    final discount = orderProvider.discountAmount;
    final finalTotal = orderProvider.finalTotal;
    final voucher = orderProvider.selectedVoucher;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tổng cộng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSummaryRow('Thành tiền', CurrencyFormatter.formatVND(subTotal)),
          if (discount > 0)
            _buildSummaryRow('Giảm giá', '-${CurrencyFormatter.formatVND(discount)}', valueColor: Colors.green),
          const Divider(height: 24),
          _buildSummaryRow('Phí giao hàng', '0đ'),
          const Divider(height: 24),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoucherScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    voucher != null ? 'Voucher: ${voucher.title}' : 'Chọn khuyến mãi/đổi bean',
                    style: TextStyle(color: voucher != null ? const Color(0xFFF26522) : Colors.blue, fontSize: 15, fontWeight: voucher != null ? FontWeight.bold : FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Số tiền thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                CurrencyFormatter.formatVND(finalTotal),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF26522)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value, style: TextStyle(fontSize: 15, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          InkWell(
            onTap: _showPaymentPicker,
            child: Row(
              children: [
                _getPaymentIcon(selectedPaymentMethod),
                const SizedBox(width: 12),
                Text(selectedPaymentMethod, style: const TextStyle(fontSize: 15)),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPaymentIcon(String method) {
    if (method == 'Tiền mặt') {
      return const Icon(Icons.money, color: Colors.green);
    } else if (method == 'VNPAY') {
      return const Icon(Icons.payment, color: Colors.blue);
    }
    return const Icon(Icons.payment);
  }

  void _showPaymentPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Chọn phương thức thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.money, color: Colors.green),
              title: const Text('Tiền mặt'),
              onTap: () {
                setState(() => selectedPaymentMethod = 'Tiền mặt');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.blue),
              title: const Text('VNPAY'),
              onTap: () {
                setState(() => selectedPaymentMethod = 'VNPAY');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(OrderProvider orderProvider) {
    final finalTotal = orderProvider.finalTotal;
    final itemCount = orderProvider.cart?.items.length ?? 0;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF26522),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mang đi • $itemCount sản phẩm',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                CurrencyFormatter.formatVND(finalTotal),
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: orderProvider.isLoading ? null : () => _handleCheckout(orderProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFF26522),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: orderProvider.isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('ĐẶT HÀNG', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckout(OrderProvider orderProvider) async {
    final messenger = ScaffoldMessenger.of(context);
    await orderProvider.checkoutCash();

    if (!mounted) return;

    if (orderProvider.error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Đặt hàng thành công!'), backgroundColor: Colors.green),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text('Lỗi: ${orderProvider.error}'), backgroundColor: Colors.red),
      );
    }
  }
}
