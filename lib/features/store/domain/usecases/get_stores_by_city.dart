import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/entities/store.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/repositories/store_repository.dart';

class GetStoresByCityUseCase {
  final StoreRepository repository;

  GetStoresByCityUseCase(this.repository);

  Future<List<Store>> call(CityEnum city) {
    return repository.getStoresByCity(city);
  }
}
