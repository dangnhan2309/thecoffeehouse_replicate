import 'package:nhom2_thecoffeehouse/features/home/domain/entities/home_data.dart';
import 'package:nhom2_thecoffeehouse/features/home/domain/repositories/home_repository.dart';

class LoadHomeData {
  final HomeRepository repository;

  LoadHomeData(this.repository);

  Future<HomeData> execute() => repository.loadHomeData();
}
