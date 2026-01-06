import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/core/appconfig.dart';
import 'package:nhom2_thecoffeehouse/models/explore_topic.dart';

class ExploreDetailPage extends StatelessWidget {
  final ExploreTopic topic;

  const ExploreDetailPage({
    super.key,
    required this.topic,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final primaryOrange = const Color(0xFFFF6F00);
    final accentOrange = const Color(0xFFFF8C00);
    final textDark = const Color(0xFF2D1B00);
    final textLight = Colors.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Image với parallax nhẹ, overlay cam nhẹ
          SliverAppBar(
            expandedHeight: size.height * 0.45,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero Image
                  Hero(
                    tag: 'explore_${topic.id}',
                    child: Image.network(
                      "${AppConfig.baseUrl}/static/${topic.imageUrl}",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: primaryOrange.withOpacity(0.2),
                        child: const Center(
                          child: Icon(Icons.local_cafe_rounded, size: 100, color: Colors.orange),
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay cam nhẹ
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nội dung chính - giống bài báo
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF121212) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title lớn như bài báo
                  Text(
                    topic.title,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: isDarkMode ? textLight : textDark,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Meta info đơn giản (tác giả + ngày)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFFFF6F00)),
                      const SizedBox(width: 8),
                      Text(
                        'The Coffee House • ${_formatDate(topic.createdAt)} • ${_formatTime(topic.createdAt)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Nội dung chính - CĂN ĐỀU HAI BÊN
                  Text(
                    topic.description,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.7,
                      color: isDarkMode ? Colors.grey.shade300 : const Color(0xFF333333),
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.justify, // Căn đều hai bên
                  ),

                  const SizedBox(height: 48),

                  // Call to action nhẹ ở cuối (giống blog)
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Cảm ơn bạn đã đọc bài viết này!',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFFF6F00),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}