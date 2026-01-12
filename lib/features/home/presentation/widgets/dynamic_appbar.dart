import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/state/home_provider.dart';
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
    // Sử dụng watch để lắng nghe thay đổi từ HomeProvider
    final homeProvider = context.watch<HomeProvider>();
    final orderProvider = context.watch<OrderProvider>();
    
    final currentCategory = homeProvider.currentCategory;
    final showGreeting = currentCategory == null;
    final cartItemCount = orderProvider.cart?.items.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top,
        16,
        0,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          if (shrinkOffset > 5)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT - Greeting or Category
          Expanded(
            child: GestureDetector(
              onTap: onCategoryModalToggle,
              behavior: HitTestBehavior.opaque,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: showGreeting
                    ? Column(
                  key: const ValueKey('greeting'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Chào $userName 👋',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Cùng đặt món nào',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
                    : Row(
                  key: const ValueKey('category'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        currentCategory.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF26522),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: Color(0xFFF26522),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// RIGHT ICONS
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.search, size: 26),
                onPressed: () {},
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, size: 26),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF26522),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '$cartItemCount',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60 + MediaQuery.of(context).padding.top;

  @override
  double get minExtent => 60 + MediaQuery.of(context).padding.top;

  @override
  bool shouldRebuild(covariant DynamicHomeAppBar oldDelegate) {
    // Trả về true để đảm bảo cập nhật khi Provider thông báo
    return true;
  }
}
