import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';

class DynamicHomeAppBar extends SliverPersistentHeaderDelegate {
  final String userName;
  final BuildContext context;
  final VoidCallback onCategoryModalToggle;

  DynamicHomeAppBar({
    required this.userName,
    required this.context,
    required this.onCategoryModalToggle,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Chào bạn, $userName',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Text(
                  'Bắt đầu ngày mới với Coffee nào!',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: Stack(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
                Consumer<OrderProvider>(
                  builder: (context, order, _) {
                    final count = order.cartItemCount;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Text(
                          '$count',
                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
