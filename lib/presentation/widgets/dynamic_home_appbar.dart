import 'package:flutter/material.dart';
import '../models/category.dart';

class DynamicHomeAppBar extends SliverPersistentHeaderDelegate {
  final Category? currentCategory;
  final bool isAtTop;
  final String userName;
  final List<Category> categories;
  final Function(int) onCategoryTap;
  final VoidCallback onCategoryModalToggle;

  DynamicHomeAppBar({
    required this.currentCategory,
    required this.isAtTop,
    required this.userName,
    required this.categories,
    required this.onCategoryTap,
    required this.onCategoryModalToggle,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final showGreeting = isAtTop;

    return Container(
      color: Colors.white,
      // Padding cố định, chỉ thay đổi top tùy theo trạng thái
      padding: EdgeInsets.fromLTRB(16, showGreeting ? 40 : 16, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Phần title / greeting
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showGreeting) ...[
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
                ] else ...[
                  GestureDetector(
                    onTap: onCategoryModalToggle,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            currentCategory?.name ?? "Tất cả",
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
                ],
              ],
            ),
          ),

          // Các nút bên phải
          Row(
            children: [
              IconButton(
                icon: Icon(
                  showGreeting ? Icons.notifications_none : Icons.search,
                  size: 28,
                  color: Colors.black87,
                ),
                onPressed: () {
                  // TODO: Thêm logic cho notification hoặc search
                },
              ),
              // Có thể thêm nút giỏ hàng nếu cần
              // IconButton(icon: Icon(Icons.shopping_cart_outlined), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  // === PHẦN QUAN TRỌNG ĐÃ SỬA: minExtent == maxExtent ===
  @override
  double get maxExtent => 100.0; // Chọn giá trị vừa đủ chứa nội dung + padding

  @override
  double get minExtent => 100.0; // Bắt buộc bằng maxExtent để tránh lỗi

  @override
  bool shouldRebuild(covariant DynamicHomeAppBar oldDelegate) {
    return oldDelegate.currentCategory?.id != currentCategory?.id ||
        oldDelegate.isAtTop != isAtTop ||
        oldDelegate.userName != userName;
  }
}