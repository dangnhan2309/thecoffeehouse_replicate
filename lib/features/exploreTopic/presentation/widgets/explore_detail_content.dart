import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';

class ExploreDetailContent extends StatelessWidget {
  final ExploreTopic topic;

  const ExploreDetailContent({super.key, required this.topic});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return '${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // SliverAppBar tương tự trước
          SliverAppBar(
            expandedHeight: size.height * 0.45,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: CircleAvatar(
                backgroundColor: Colors.black.withAlpha(40),
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
                  Hero(
                    tag: 'explore_${topic.id}',
                    child: Image.network(
                      "${AppConfig.baseUrl}/static/${topic.imageUrl}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => Container(
                        color: Colors.orange.withAlpha(20),
                        child: const Center(child: Icon(Icons.local_cafe_rounded, size: 100, color: Colors.orange)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(30),
                          Colors.black.withAlpha(10),
                          Colors.black.withAlpha(60),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

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
                  Text(topic.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFFFF6F00)),
                      const SizedBox(width: 8),
                      Text(
                        'The Coffee House • ${_formatDate(topic.createdAt)} • ${_formatTime(topic.createdAt)}',
                        style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    topic.description,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.7,
                      color: isDarkMode ? Colors.grey.shade300 : const Color(0xFF333333),
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: const Text(
                      'Cảm ơn bạn đã đọc bài viết này!',
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Color(0xFFFF6F00)),
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
