import 'package:dartz/dartz.dart';
import '../../../entities/catalog/category.dart';
import '../../../repositories/category_repository.dart';
import '../../../../core/error/failures.dart';

class SearchCategoriesUseCase {
  final CategoryRepository repository;

  SearchCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call(String query) async {
    return await repository.searchCategories(query);
  }
}