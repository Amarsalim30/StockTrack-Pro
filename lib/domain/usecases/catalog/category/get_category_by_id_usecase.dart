import 'package:dartz/dartz.dart';
import '../../../entities/catalog/category.dart';
import '../../../repositories/category_repository.dart';
import '../../../../core/error/failures.dart';

class GetCategoryByIdUseCase {
  final CategoryRepository repository;

  GetCategoryByIdUseCase(this.repository);

  Future<Either<Failure, Category>> call(String id) async {
    return await repository.getCategoryById(id);
  }
}