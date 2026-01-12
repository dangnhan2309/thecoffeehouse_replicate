import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';

class CategorySection extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<int>? onCategoryTap;

  const CategorySection({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Không có danh mục nào')),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];

          return InkWell(
            onTap: () => onCategoryTap?.call(cat.id),
            child: Column(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                      "${AppConfig.baseUrl}/static/${cat.imageUrl ?? ''}",
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.local_cafe, size: 40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 60,
                  child: Text(
                    cat.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
