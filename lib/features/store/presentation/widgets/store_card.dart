import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import '../../domain/entities/store.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (store.imageUrl != null && store.imageUrl!.isNotEmpty)
              Image.network(
                "${AppConfig.baseUrl}/static/${store.imageUrl}",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              )
            else
              Container(
                height: 180,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.storefront, size: 50, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    store.address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${store.openTime ?? "07:00"} - ${store.closeTime ?? "22:00"}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // TODO: Open Map
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Bản đồ',
                          style: TextStyle(color: Color(0xFFF26522), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
