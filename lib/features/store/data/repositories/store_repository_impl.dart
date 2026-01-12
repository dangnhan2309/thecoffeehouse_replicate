import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';

import '../../domain/entities/store.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/remote/store_remote_datasource.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remote;

  StoreRepositoryImpl(this.remote);

  @override
  Future<List<Store>> getStores() => remote.getStores();

  @override
  Future<List<Store>> getStoresByCity(CityEnum city) =>
      remote.getStoresByCity(city);

  @override
  Future<List<Store>> getNearestStores(double lat, double lng) =>
      remote.getNearestStores(lat, lng);
}
