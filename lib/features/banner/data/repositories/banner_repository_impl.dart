import 'package:nhom2_thecoffeehouse/features/banner/data/datasources/remote/banner_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/banner/domain/entities/banner.dart';
import 'package:nhom2_thecoffeehouse/features/banner/domain/repositories/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDatasource remote;
  BannerRepositoryImpl(this.remote);
  @override
  Future<List<BannerItem>> getBanners() async {
    final models = await remote.getBanners();
    return models;
  }
}
