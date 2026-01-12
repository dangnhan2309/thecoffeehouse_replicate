import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/core/utils/currency_formatter.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/entities/order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _historyFuture;

  @override
  void initState() {
    super.initState();
    // Giả sử bạn đã thêm GetOrderHistoryUseCase vào OrderRepository
    // Ở đây tôi demo cách dùng tạm qua Provider nếu bạn đã cập nhật nó
    final repository = context.read<OrderProvider>().getCartUseCase.repository;
    _historyFuture = repository.getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử đơn hàng", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Color(0xFFF26522),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Order>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF26522)));
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
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
              double total = order.items.fold(0, (sum, item) => sum + (item.price * item.quantity));
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text("Đơn hàng #${order.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Ngày đặt: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}"),
                      Text("Trạng thái: ${order.status}", style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                  trailing: Text(
                    CurrencyFormatter.formatVND(total),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF26522)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
