import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/repositories/explore_topic_repository.dart';

class GetExploreTopicDetailUseCase {
  final ExploreTopicRepository repository;

  GetExploreTopicDetailUseCase(this.repository);

  Future<ExploreTopic> call(int topicId) async {
    return await repository.getTopicById(topicId);
  }
}