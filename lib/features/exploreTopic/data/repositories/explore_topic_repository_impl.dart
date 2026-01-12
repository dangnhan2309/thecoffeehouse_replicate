import 'package:nhom2_thecoffeehouse/features/exploreTopic/data/datasources/remote/explore_topic_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/repositories/explore_topic_repository.dart';

class ExploreTopicRepositoryImpl implements ExploreTopicRepository{
  final ExploreTopicRemoteDatasource remote;
  ExploreTopicRepositoryImpl(this.remote);

  @override
  Future<List<ExploreTopic>> getExploreTopics() async {
    final models = await remote.getExploreTopics();
    return models;
  }
  @override
  Future<ExploreTopic> getTopicById(int topicId) async {
    final model = await remote.getTopicById(topicId);
    return model;
  }
}