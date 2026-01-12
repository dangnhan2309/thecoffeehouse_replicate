import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/entities/explore_topic.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/entities/product.dart';

class HomeData {
  final List<Category> categories;
  final List<Product> products;
  // final List<Promotion> promotions;
  final List<ExploreTopic> exploreTopics;


  HomeData({
    required this.categories,
    required this.products,
    // required this.promotions,
    required this.exploreTopics,
  });
}
