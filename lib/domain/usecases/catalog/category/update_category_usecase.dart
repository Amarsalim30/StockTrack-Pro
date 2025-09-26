import 'package:dartz/dartz.dart';
import '../../../entities/catalog/category.dart';
import '../../../repositories/category_repository.dart';
import '../../../../core/error/failures.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Either<Failure, Category>> call(Category category) async {
    return await repository.updateCategory(category);
  }
}