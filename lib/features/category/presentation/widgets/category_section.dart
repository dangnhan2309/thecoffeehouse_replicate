import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/category/presentation/widgets/category_item.dart';

class CategorySection extends StatefulWidget {
  final List<Category> categories;

  const CategorySection({
    super.key,
    required this.categories,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  double _scrollProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                setState(() {
                  _scrollProgress = notification.metrics.pixels / notification.metrics.maxScrollExtent;
                  _scrollProgress = _scrollProgress.clamp(0.0, 1.0);
                });
              }
              return true;
            },
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16), 
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                mainAxisSpacing: 12, 
                crossAxisSpacing: 16, 
                childAspectRatio: 1.1, 
              ),
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                final category = widget.categories[index];
                return InkWell(
                  child: CategoryItem(cat: category),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 40, 
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 50),
                left: _scrollProgress * 20, 
                child: Container(
                  width: 20, 
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF26522),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
