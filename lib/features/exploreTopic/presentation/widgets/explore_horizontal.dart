import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/presentation/widgets/explore_card.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/presentation/widgets/explore_detail_page.dart';


class ExploreHorizontal extends StatelessWidget {
  final List<ExploreTopic> topics;

  const ExploreHorizontal({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Những câu chuyện đằng sau tách cà phê',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: topics.length,
              separatorBuilder: (context, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final topic = topics[index];
                return ExploreCard(
                  topic: topic,
                  onTap: () {
                    // Chỉ truyền ID, DetailPage fetch dữ liệu qua Provider
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExploreDetailPage(topicId: topic.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8C00), Color(0xFFFF6F00)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'KHÁM PHÁ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          _buildViewAllButton(context),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to full explore list
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFFF6F00), width: 1.6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Xem tất cả',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF6F00),
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: Color(0xFFFF6F00),
            ),
          ],
        ),
      ),
    );
  }
}
