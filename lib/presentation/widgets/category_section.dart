import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/core/appconfig.dart';
import '../models/category.dart';

class CategorySection extends StatefulWidget {
  final List<Category> categories;
  final Function(int)? onCategoryTap; // Thêm callback

  const CategorySection({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final ScrollController _scrollController = ScrollController();
  double _indicatorPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _indicatorPosition = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= SEARCH + HEART =================
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.favorite_border, color: Colors.orange[700]),
              ),
            ],
          ),
        ),

        // ================= CATEGORY GRID HORIZONTAL =================
        SizedBox(
          height: 210,
          child: SingleChildScrollView(
            controller: _scrollController, // ⭐ controller
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (widget.onCategoryTap != null) {
                      widget.onCategoryTap!(widget.categories[index].id);
                    }
                  },
                  child: SizedBox(
                    width: 80,
                    child: _CategoryItem(cat: widget.categories[index]),
                  ),
                );
              },
            ),
          ),
        ),

        // ================= INDICATOR DI CHUYỂN =================
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 45, // ⭐ chiều rộng thật
            height: 4,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // NỀN
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                // THANH DI CHUYỂN
                Transform.translate(
                  offset: Offset(
                    (_indicatorPosition / 10).clamp(0, 21), // 45 - 24 = 21
                    0,
                  ),
                  child: Container(
                    width: 24,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.orange[600],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ================= CATEGORY ITEM =================
class _CategoryItem extends StatelessWidget {
  final Category cat;

  const _CategoryItem({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,

          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: "${AppConfig.baseUrl}/static/${cat.imageUrl!}",
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.local_cafe, size: 56),
              ),
              fadeInDuration: const Duration(milliseconds: 300),
            ),
          ),
        ),
        Text(
          cat.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
