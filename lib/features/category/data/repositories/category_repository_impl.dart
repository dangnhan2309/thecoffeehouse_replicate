import 'package:nhom2_thecoffeehouse/features/category/data/datasources/remote/category_remote_datasource.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/entities/category.dart';
import 'package:nhom2_thecoffeehouse/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository{
  final CategoryRemoteDatasource remote;
  CategoryRepositoryImpl(this.remote);

  @override
  Future<List<Category>> getCategories() async {
    final models = await remote.getCategories();
    return models;
  }
}