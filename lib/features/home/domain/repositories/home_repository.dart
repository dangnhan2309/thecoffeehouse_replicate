import 'package:nhom2_thecoffeehouse/features/home/domain/entities/home_data.dart';

abstract class HomeRepository {
  Future<HomeData> loadHomeData();
}