import 'package:nhom2_thecoffeehouse/features/banner/domain/entities/banner.dart';

abstract class BannerRepository {
  Future<List<BannerItem>> getBanners();
}
