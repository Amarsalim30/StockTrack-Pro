import 'package:dartz/dartz.dart';
import '../../../entities/catalog/category.dart';
import '../../../repositories/category_repository.dart';
import '../../../../core/error/failures.dart';

class GetCategoriesByParentUseCase {
  final CategoryRepository repository;

  GetCategoriesByParentUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call(String parentId) async {
    return await repository.getCategoriesByParent(parentId);
  }
}