import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';

class ExploreCard extends StatelessWidget {
  final ExploreTopic topic;
  final VoidCallback onTap;

  const ExploreCard({super.key, required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 240,
        child: Hero(
          tag: 'explore_${topic.id}',
          child: Material(
            elevation: 5,
            shadowColor: Colors.black.withAlpha(12),
            borderRadius: BorderRadius.circular(18),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: "${AppConfig.baseUrl}/static/${topic.imageUrl}",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.local_cafe_rounded, size: 60),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 0.75, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(50),
                          Colors.black.withAlpha(92),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          if (topic.description.isNotEmpty)
                            Text(
                              topic.description,
                              style: TextStyle(
                                color: Colors.white.withAlpha(95),
                                fontSize: 12,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
