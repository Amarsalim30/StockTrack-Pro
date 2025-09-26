import 'package:dartz/dartz.dart';
import '../../../entities/catalog/category.dart';
import '../../../repositories/category_repository.dart';
import '../../../../core/error/failures.dart';

class GetAllCategoriesUseCase {
  final CategoryRepository repository;

  GetAllCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getAllCategories();
  }
}