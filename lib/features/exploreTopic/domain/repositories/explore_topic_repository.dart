import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';

abstract class ExploreTopicRepository {
  Future<List<ExploreTopic>> getExploreTopics();
  Future<ExploreTopic> getTopicById(int topicId);
}
