// lib/widgets/search_app_bar.dart
import 'package:flutter/material.dart';

class SearchAppBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool isScrolled = shrinkOffset > 40;

    final progress = (shrinkOffset / maxExtent).clamp(0.0, 1.0);

    return Container(
      color: Color.lerp(Colors.white, const Color(0xFFF26522), progress),
      child: SafeArea(
        bottom: false,
        child: Align(  // QUAN TRỌNG: Wrap bằng Align để fix lỗi layoutExtent > paintExtent
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (isScrolled) ...[
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  const Text(
                    "Giao đến • 123 Đường ABC",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const Spacer(),
                ],

                Icon(
                  Icons.favorite_border,
                  color: isScrolled ? Colors.white : const Color(0xFFF26522),
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => 80.0;  // Nhỏ hơn maxExtent để có shrink nhẹ, tránh lỗi

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}