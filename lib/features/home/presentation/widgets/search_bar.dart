import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/screens/favorite_products_screen.dart';

class SearchAppBar extends SliverPersistentHeaderDelegate {
  final String location;
  final ValueChanged<String>? onSearchChanged;

  SearchAppBar({
    this.location = "123 Đường ABC",
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool isScrolled = shrinkOffset > 40;

    final progress = (shrinkOffset / maxExtent).clamp(0.0, 1.0);

    return Container(
      color: Color.lerp(Colors.white, const Color(0xFFF26522), progress),
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: "Tìm kiếm",
                      filled: true,
                      fillColor: Colors.white.withAlpha(90),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoriteProductsScreen()),
                    );
                  },
                  child: Icon(
                    Icons.favorite_border,
                    color: isScrolled ? Colors.white : const Color(0xFFF26522),
                    size: 26,
                  ),
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
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
