import '../entities/store.dart';
import '../repositories/store_repository.dart';

class GetStoresUseCase {
  final StoreRepository repository;

  GetStoresUseCase(this.repository);

  Future<List<Store>> call() {
    return repository.getStores();
  }
}
