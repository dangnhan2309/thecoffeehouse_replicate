import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhom2_thecoffeehouse/appconfig.dart';
import 'package:nhom2_thecoffeehouse/features/banner/data/datasources/remote/banner_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/banner/data/repositories/banner_repository_impl.dart';
import 'package:nhom2_thecoffeehouse/features/banner/domain/usecases/get_banner.dart';
import 'package:nhom2_thecoffeehouse/features/banner/presentation/state/banner_provider.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/domain/usecases/get_explore_detail.dart';
import 'package:nhom2_thecoffeehouse/features/exploreTopic/presentation/state/explore_detail_provider.dart';
import 'package:nhom2_thecoffeehouse/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/order/data/repositories/order_repository_impl.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/add_to_cart.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/checkout_cash.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/get_cart.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/remove_from_cart.dart';
import 'package:nhom2_thecoffeehouse/features/order/domain/usecases/update_cart_item.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/state/favorite_provider.dart';
import 'package:nhom2_thecoffeehouse/features/store/data/datasources/remote/store_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/store/data/repositories/store_repository_impl.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/usecases/get_nearest_stores.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/usecases/get_stores.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/usecases/get_stores_by_city.dart';
import 'package:nhom2_thecoffeehouse/features/store/presentation/state/store_provider.dart';
import 'package:nhom2_thecoffeehouse/features/vourcher/data/datasources/remote/voucher_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/vourcher/data/repositories/voucher_repository_impl.dart';
import 'package:nhom2_thecoffeehouse/features/vourcher/domain/usecases/get_vouchers.dart';
import 'package:nhom2_thecoffeehouse/features/vourcher/presentation/state/vourcher_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// DATA SOURCES & REPOSITORIES
import 'features/category/data/datasources/remote/category_remote_datasource.dart';
import 'features/category/data/repositories/category_repository_impl.dart';
import 'features/category/presentation/state/category_provider.dart';
import 'features/product/data/datasources/remote/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/exploreTopic/data/datasources/remote/explore_topic_remote_datasource.dart';
import 'features/exploreTopic/data/repositories/explore_topic_repository_impl.dart';
import 'features/promotion/data/datasources/remote/promotion_remote_datasource.dart';
import 'features/promotion/data/repositories/promotion_repository_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

// DOMAIN - USECASES
import 'features/category/domain/usecases/get_categories.dart';
import 'features/product/domain/usecases/get_products_by_category.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/exploreTopic/domain/usecases/get_explore_topics.dart';
import 'features/promotion/domain/usecases/get_promotions.dart';
import 'features/promotion/domain/usecases/get_products_by_promotion.dart';

// PRESENTATION - PROVIDERS & SCREENS
import 'features/home/presentation/state/home_provider.dart';
import 'features/home/presentation/state/home_appbar_provider.dart';
import 'features/order/presentation/state/order_provider.dart';
import 'features/order/presentation/screens/cart_screen.dart';
import 'features/auth/presentation/state/auth_provider.dart';
import 'features/main_sreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  final client = http.Client();
  final baseUrl = AppConfig.baseUrl;

  // =========================
  // DATA LAYER
  // =========================
  final authRepo = AuthRepositoryImpl(client: client, sharedPreferences: prefs);
  
  final categoryRemote = CategoryRemoteDatasourceImpl();
  final productRemote = ProductRemoteDatasourceImpl();
  final exploreTopicRemote = ExploreTopicRemoteDatasourceImpl();
  final bannerRemote = BannerRemoteDatasourceImpl();
  final orderRemote = OrderRemoteDatasourceImpl(client: client, baseUrl: baseUrl, prefs: prefs);
  final promotionRemote = PromotionRemoteDatasourceImpl();
  final voucherRemote = VoucherRemoteDataSourceImpl(client: client);
  final storeRemote = StoreRemoteDataSourceImpl();

  final categoryRepo = CategoryRepositoryImpl(categoryRemote);
  final productRepo = ProductRepositoryImpl(productRemote);
  final exploreTopicRepo = ExploreTopicRepositoryImpl(exploreTopicRemote);
  final bannerRepo = BannerRepositoryImpl(bannerRemote);
  final orderRepo = OrderRepositoryImpl(orderRemote);
  final promotionRepo = PromotionRepositoryImpl(
    promoRemote: promotionRemote,
    productRemote: productRemote,
  );
  final storeRepo = StoreRepositoryImpl(storeRemote);
  final voucherRepo = VoucherRepositoryImpl(remoteDataSource: voucherRemote);

  // =========================
  // DOMAIN LAYER
  // =========================
  final getCategoriesUseCase = GetCategoriesUseCase(categoryRepo);
  final getProductsByCategoryUseCase = GetProductsByCategoryUseCase(productRepo);
  final getAllProductsUseCase = GetAllProductsUseCase(productRepo);
  final getBannersUseCase = GetBannersUseCase(bannerRepo);
  final getExploreTopicsUseCase = GetExploreTopicsUseCase(exploreTopicRepo);
  final getPromotionsUseCase = GetPromotionsUseCase(promotionRepo);
  final getProductsByPromotionUseCase = GetProductsByPromotionUseCase(promotionRepo);
  final getVouchersUseCase = GetVouchersUseCase(voucherRepo);
  
  final addToCartUseCase = AddToCartUseCase(orderRepo);
  final getCartUseCase = GetCartUseCase(orderRepo);
  final checkoutCashUseCase = CheckoutCashUseCase(orderRepo);
  final removeFromCartUseCase = RemoveFromCartUseCase(repository: orderRepo);
  final updateCartItemUseCase = UpdateCartItemUseCase(repository: orderRepo);
  final getStoresUseCase = GetStoresUseCase(storeRepo);
  final getStoresByCityUseCase = GetStoresByCityUseCase(storeRepo);
  final getNearestStoresUseCase = GetNearestStoresUseCase(storeRepo);

  runApp(
    MultiProvider(
      providers: [
        // Cung cấp UseCase để HomeScreen có thể truy cập được
        Provider.value(value: getProductsByCategoryUseCase),
        
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository: authRepo)..checkLoginStatus(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(sharedPreferences: prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            getCategoriesUseCase: getCategoriesUseCase,
            getProductsUseCase: getAllProductsUseCase,
          )..loadCategories(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            getProducts: getProductsByCategoryUseCase,
            getCategories: getCategoriesUseCase,
            getExploreTopics: getExploreTopicsUseCase,
            getPromotions: getPromotionsUseCase,
            getPromoProducts: getProductsByPromotionUseCase,
          )..loadHomeData(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            addToCartUseCase: addToCartUseCase,
            getCartUseCase: getCartUseCase,
            checkoutCashUseCase: checkoutCashUseCase,
            removeFromCartUseCase: removeFromCartUseCase,
            updateCartItemUseCase: updateCartItemUseCase,
            productRepository: productRepo,
          )..loadCart(),
        ),
        ChangeNotifierProvider(
          create: (_) => VoucherProvider(
            getVouchersUseCase: getVouchersUseCase,
          )..loadVouchers(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeAppBarProvider(getCategoriesUseCase: getCategoriesUseCase)..loadCategories(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExploreDetailProvider(
            getTopicDetailUseCase: GetExploreTopicDetailUseCase(exploreTopicRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BannerProvider(getBannersUseCase: getBannersUseCase)..loadBanners(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(
            getStoresUseCase: getStoresUseCase,
            getStoresByCityUseCase: getStoresByCityUseCase,
            getNearestStoresUseCase: getNearestStoresUseCase,
          )..loadStores(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Coffee House',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6F00),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'SFPro',
      ),
      home: const MainScreen(),
      routes: {
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
