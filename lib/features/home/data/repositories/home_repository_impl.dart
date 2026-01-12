import 'package:nhom2_thecoffeehouse/features/category/domain/repositories/category_repository.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/repositories/explore_topic_repository.dart';
import 'package:nhom2_thecoffeehouse/features/home/domain/entities/home_data.dart';
import 'package:nhom2_thecoffeehouse/features/home/domain/repositories/home_repository.dart';
import 'package:nhom2_thecoffeehouse/features/product/domain/repositories/product_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final CategoryRepository categoryRepo;
  final ProductRepository productRepo;
  // final PromotionRepository promotionRepo;
  final ExploreTopicRepository exploreTopicRepo;


  HomeRepositoryImpl({
    required this.categoryRepo,
    required this.productRepo,
    // required this.promotionRepo,
    required this.exploreTopicRepo,
  });

  @override
  Future<HomeData> loadHomeData() async {
    final categories = await categoryRepo.getCategories();
    final products = await productRepo.getAllProducts();
    // final promotions = await promotionRepo.getPromotions();
    final exploreTopics = await exploreTopicRepo.getExploreTopics();

    return HomeData(
      categories: categories,
      products: products,
      // promotions: promotions,
      exploreTopics: exploreTopics,
    );
  }

}
