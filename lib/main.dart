import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/banner/data/datasources/remote/banner_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/banner/data/repositories/banner_repository_impl.dart';
import 'package:nhom2_thecoffeehouse/features/banner/domain/usecases/get_banner.dart';
import 'package:nhom2_thecoffeehouse/features/banner/presentation/state/banner_provider.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/usecases/get_explore_detail.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/presentation/state/explore_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// DATA SOURCES & REPOSITORIES
import 'features/category/data/datasources/remote/category_remote_datasource.dart';
import 'features/category/data/repositories/category_repository_impl.dart';
import 'features/product/data/datasources/remote/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/promotion/data/datasources/remote/promotion_remote_datasource.dart';
import 'features/promotion/data/repositories/promotion_repository_impl.dart';
import 'features/exploreTopic/data/datasources/remote/explore_topic_remote_datasource.dart';
import 'features/exploreTopic/data/repositories/explore_topic_repository_impl.dart';

// DOMAIN - USECASES
import 'features/category/domain/usecases/get_categories.dart';
import 'features/product/domain/usecases/get_products_by_category.dart';
import 'features/exploreTopic/domain/usecases/get_explore_topics.dart';
import 'features/promotion/domain/usecases/get_promotions.dart'; // nếu cần dùng sau này
import 'features/home/domain/usecases/load_data.dart';

// PRESENTATION - PROVIDERS & SCREENS
import 'features/home/presentation/state/home_provider.dart';
import 'features/home/presentation/state/home_appBar_provider.dart';
import 'features/order/presentation/state/order_provider.dart';
import 'features/product/presentation/state/product_detail_provider.dart'; // nếu dùng global
import 'features/main_sreen.dart'; // tên file có thể là MainScreen.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo SharedPreferences để check login
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // =========================
  // DATA LAYER - Khởi tạo các Data Sources & Repositories
  // =========================
  final categoryRemote = CategoryRemoteDatasourceImpl();
  final productRemote = ProductRemoteDatasourceImpl();
  // final promotionRemote = PromotionRemoteDatasourceImpl();
  final exploreTopicRemote = ExploreTopicRemoteDatasourceImpl();
  final bannerRemote = BannerRemoteDatasourceImpl();

  final categoryRepo = CategoryRepositoryImpl(categoryRemote);
  final productRepo = ProductRepositoryImpl(productRemote);
  // final promotionRepo = PromotionRepositoryImpl(promotionRemote);
  final exploreTopicRepo = ExploreTopicRepositoryImpl(exploreTopicRemote);
  final bannerRepo = BannerRepositoryImpl(bannerRemote);

  // =========================
  // DOMAIN LAYER - Khởi tạo các UseCase (singleton)
  // =========================
  final getCategoriesUseCase = GetCategoriesUseCase(categoryRepo);
  final getProductsByCategoryUseCase = GetProductsByCategoryUseCase(
    productRepo,
  );
  final getBannersUseCase = GetBannersUseCase(bannerRepo);
  final getExploreTopicsUseCase = GetExploreTopicsUseCase(exploreTopicRepo);
  // final getPromotionsUseCase = GetPromotionsUseCase(promotionRepo); // Uncomment nếu cần

  runApp(
    MultiProvider(
      providers: [
        // Cung cấp các UseCase dưới dạng immutable value (khuyến nghị)
        Provider<GetCategoriesUseCase>.value(value: getCategoriesUseCase),
        Provider<GetProductsByCategoryUseCase>.value(
          value: getProductsByCategoryUseCase,
        ),
        Provider<GetExploreTopicsUseCase>.value(value: getExploreTopicsUseCase),
        // Provider<GetPromotionsUseCase>.value(value: getPromotionsUseCase), // nếu cần

        // =========================
        // CHANGE NOTIFIER PROVIDERS
        // =========================
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            getProducts: getProductsByCategoryUseCase,
            getCategories: getCategoriesUseCase,
            getExploreTopics: getExploreTopicsUseCase,
          )..loadHomeData(), // gọi ngay khi khởi tạo
        ),

        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            categoryRepo: categoryRepo,
            productRepo: productRepo,
          )..loadData(),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              HomeAppBarProvider(getCategoriesUseCase: getCategoriesUseCase)
                ..loadCategories(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExploreDetailProvider(
            getTopicDetailUseCase: GetExploreTopicDetailUseCase(
              exploreTopicRepo,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              BannerProvider(getBannersUseCase: getBannersUseCase)
                ..loadBanners(),
        ),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Coffee House',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'SFPro', // nếu bạn dùng font custom
      ),
      home: const MainScreen(),
      // Nếu muốn route dựa theo login status:
      // home: isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}
