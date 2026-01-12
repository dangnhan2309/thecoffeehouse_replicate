import '../entities/explore_topic.dart';
import '../repositories/explore_topic_repository.dart';

class GetExploreTopicsUseCase {
  final ExploreTopicRepository repository;

  GetExploreTopicsUseCase(this.repository);

  Future<List<ExploreTopic>> call() async {
    return await repository.getExploreTopics();
  }
}
