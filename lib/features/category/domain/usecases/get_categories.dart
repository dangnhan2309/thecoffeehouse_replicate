import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call() async {
    return await repository.getCategories();
  }
}