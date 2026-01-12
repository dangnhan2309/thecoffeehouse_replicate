import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/core/utils/currency_formatter.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _historyFuture;
  int? _selectedOrderId;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final orderProvider = context.read<OrderProvider>();
    // Lấy lịch sử và làm giàu dữ liệu với thông tin sản phẩm (name, image)
    _historyFuture = orderProvider.getCartUseCase.repository.getOrderHistory().then((orders) => _enrichOrders(orders));
  }

  Future<List<Order>> _enrichOrders(List<Order> orders) async {
    if (orders.isEmpty) return orders;
    
    final orderProvider = context.read<OrderProvider>();
    final productRepository = orderProvider.productRepository;
    
    // Thu thập tất cả productId duy nhất từ tất cả đơn hàng
    final productIds = orders
        .expand((order) => order.items)
        .map((item) => item.productId)
        .toSet()
        .toList();
    
    if (productIds.isEmpty) return orders;

    try {
      final products = await productRepository.getProductsByIds(productIds);
      final productMap = {for (var p in products) p.id: p};

      return orders.map((order) {
        final updatedItems = order.items.map((item) {
          final productInfo = productMap[item.productId];
          if (productInfo != null) {
            return item.copyWith(
              productName: productInfo.name,
              productImage: productInfo.imageUrl,
            );
          }
          return item;
        }).toList();

        return Order(
          id: order.id,
          userId: order.userId,
          status: order.status,
          createdAt: order.createdAt,
          items: updatedItems,
        );
      }).toList();
    } catch (e) {
      debugPrint("Error enriching orders: $e");
      return orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Lịch sử đơn hàng", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: const Color(0xFFF26522),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Order>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF26522)));
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Lỗi: ${snapshot.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _loadHistory()),
                    child: const Text("Thử lại"),
                  )
                ],
              ),
            );
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text("Chưa có đơn hàng nào"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final isSelected = _selectedOrderId == order.id;
              double total = order.items.fold(0, (sum, item) => sum + (item.price * item.quantity));
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFF26522) : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _selectedOrderId = expanded ? order.id : null;
                      });
                    },
                    initiallyExpanded: isSelected,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đơn hàng ${order.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          CurrencyFormatter.formatVND(total),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF26522)),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "Ngày đặt: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}",
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(order.status),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item.productImage != null && item.productImage!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: "${AppConfig.baseUrl}/static/${item.productImage}",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                                    errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.grey),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.coffee, color: Colors.grey),
                                  ),
                          ),
                          title: Text(
                            "${item.quantity}x ${item.productName}",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: item.size != null || item.ice != null || item.sugar != null || (item.toppings?.isNotEmpty ?? false)
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _buildItemOptions(item),
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                )
                              : null,
                          trailing: Text(
                            CurrencyFormatter.formatVND(item.price * item.quantity),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      )),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'đã hoàn thành':
        return Colors.green;
      case 'pending':
      case 'đang xử lý':
        return Colors.orange;
      case 'cancelled':
      case 'đã hủy':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _buildItemOptions(dynamic item) {
    List<String> options = [];
    if (item.size != null) options.add('Size: ${item.size}');
    if (item.ice != null) options.add('Đá: ${item.ice}');
    if (item.sugar != null) options.add('Đường: ${item.sugar}');
    if (item.toppings != null && item.toppings!.isNotEmpty) {
      options.add('Topping: ${item.toppings!.join(", ")}');
    }
    return options.join(' • ');
  }
}
