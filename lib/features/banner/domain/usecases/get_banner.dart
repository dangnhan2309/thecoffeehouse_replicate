import 'package:nhom2_thecoffeehouse/features/banner/domain/entities/banner.dart';
import 'package:nhom2_thecoffeehouse/features/banner/domain/repositories/banner_repository.dart';

class GetBannersUseCase {
  final BannerRepository repository;

  GetBannersUseCase(this.repository);

  Future<List<BannerItem>> call() async {
    return await repository.getBanners();
  }
}
