import 'package:dartz/dartz.dart';
import '../entities/catalog/category.dart';
import '../../core/error/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getAllCategories();
  Future<Either<Failure, Category>> getCategoryById(String id);
  Future<Either<Failure, List<Category>>> searchCategories(String query);
  Future<Either<Failure, List<Category>>> getCategoriesByParent(String parentId);
  Future<Either<Failure, Category>> createCategory(Category category);
  Future<Either<Failure, Category>> updateCategory(Category category);
  Future<Either<Failure, void>> deleteCategory(String id);
}