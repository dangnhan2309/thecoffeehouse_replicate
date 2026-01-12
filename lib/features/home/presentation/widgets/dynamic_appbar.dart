import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/state/home_provider.dart';
import 'package:provider/provider.dart';

class DynamicHomeAppBar extends SliverPersistentHeaderDelegate {
  final String userName;
  final VoidCallback onCategoryModalToggle;

  DynamicHomeAppBar({
    required this.userName,
    required this.onCategoryModalToggle,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final homeProvider = context.watch<HomeProvider>();
    final currentCategory = homeProvider.currentCategory;

    /// Nếu chưa scroll tới category nào → greeting
    final showGreeting = currentCategory == null;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        16,
        showGreeting ? 40 : 16,
        16,
        12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT CONTENT
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: showGreeting
                  ? Column(
                key: const ValueKey('greeting'),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Chào $userName 👋",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Hôm nay bạn muốn thưởng thức gì?",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
                  : GestureDetector(
                key: const ValueKey('category'),
                onTap: onCategoryModalToggle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        currentCategory.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// RIGHT ICON
          IconButton(
            icon: Icon(
              showGreeting ? Icons.notifications_none : Icons.search,
              size: 28,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /// AppBar cao khi greeting, thấp khi category
  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 70
  ;
  /// Bắt buộc rebuild khi scroll
  @override
  bool shouldRebuild(covariant DynamicHomeAppBar oldDelegate) => true;
}
