import 'dart:convert';
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/features/exploreTopic/data/models/explore_topic_model.dart';

abstract class ExploreTopicRemoteDatasource{
  Future<List<ExploreTopicModel>> getExploreTopics();
  Future<ExploreTopicModel> getTopicById(int topicId);
}


class ExploreTopicRemoteDatasourceImpl extends ExploreTopicRemoteDatasource{
  @override
  Future<List<ExploreTopicModel>> getExploreTopics() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/explore/'),
    );
    final List data = jsonDecode(response.body);
    return data.map((e) => ExploreTopicModel.fromJson(e)).toList();
  }
  @override
  Future<ExploreTopicModel> getTopicById(int topicId) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/explore/$topicId/'),
    );
    final data = jsonDecode(response.body);
    return ExploreTopicModel.fromJson(data);
  }
}