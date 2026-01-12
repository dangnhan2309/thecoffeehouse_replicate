import 'package:nhom2_thecoffeehouse/features/store/store.dart';

abstract class StoreRepository {
  Future<List<Store>> getStores();
}