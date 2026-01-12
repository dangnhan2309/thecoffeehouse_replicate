import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}