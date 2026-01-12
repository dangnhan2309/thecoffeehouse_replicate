import 'package:flutter/cupertino.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/usecases/get_explore_detail.dart';

class ExploreDetailProvider extends ChangeNotifier {
  final GetExploreTopicDetailUseCase getTopicDetailUseCase;

  ExploreDetailProvider({required this.getTopicDetailUseCase});

  ExploreTopic? topic;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadTopic(int topicId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      topic = await getTopicDetailUseCase(topicId);
    } catch (e) {
      errorMessage = e.toString();
      topic = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
