import 'package:nhom2_thecoffeehouse/features/store/domain/entities/store.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/repositories/store_repository.dart';

class GetNearestStoresUseCase {
  final StoreRepository repository;

  GetNearestStoresUseCase(this.repository);

  Future<List<Store>> call(double lat, double lng) {
    return repository.getNearestStores(lat, lng);
  }
}
