import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';

class CategoryItem extends StatelessWidget {
  final Category cat;

  const CategoryItem({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: "${AppConfig.baseUrl}/static/${cat.imageUrl ?? ''}",
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
        const SizedBox(height: 6),
        Text(
          cat.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
