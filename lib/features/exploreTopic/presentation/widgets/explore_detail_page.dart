import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/presentation/state/explore_detail_provider.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/presentation/widgets/explore_detail_content.dart';
import 'package:provider/provider.dart';

class ExploreDetailPage extends StatelessWidget {
  final int topicId;

  const ExploreDetailPage({super.key, required this.topicId});

  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreDetailProvider>().loadTopic(topicId);
    });

    return Consumer<ExploreDetailProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.errorMessage != null) {
          return Scaffold(
            body: Center(child: Text(provider.errorMessage!)),
          );
        }

          if (provider.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Lỗi: ${provider.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final topic = provider.topic;
          if (topic == null) {
            return const Scaffold(
              body: Center(child: Text('Không tìm thấy bài viết')),
            );
          }

          return ExploreDetailContent(topic: topic);
        },
      );
  }
}
