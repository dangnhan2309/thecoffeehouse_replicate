import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';

import '../entities/store.dart';

abstract class StoreRepository {
  Future<List<Store>> getStores();
  Future<List<Store>> getStoresByCity(CityEnum city);
  Future<List<Store>> getNearestStores(double lat, double lng);
}
