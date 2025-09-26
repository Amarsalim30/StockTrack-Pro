import 'package:dartz/dartz.dart';
import '../../../repositories/category_repository.dart';
import '../../../../core/error/failures.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteCategory(id);
  }
}