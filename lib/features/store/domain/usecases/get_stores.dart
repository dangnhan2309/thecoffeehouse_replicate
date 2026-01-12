
import 'package:nhom2_thecoffeehouse/features/store/domain/repositories/store_repository.dart';
import 'package:nhom2_thecoffeehouse/features/store/store.dart';

class GetStoresUseCase {
  final StoreRepository repository;

  GetStoresUseCase(this.repository);

  Future<List<Store>> call() async {
    return await repository.getStores();
  }
}