import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/catalog/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/category_api.dart';
import '../mappers/catalog/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApi api;

  CategoryRepositoryImpl(this.api);

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final models = await api.getAllCategories();
      final entities = models.map((model) => CategoryMapper.toEntity(model)).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    try {
      final model = await api.getCategoryById(id);
      return Right(CategoryMapper.toEntity(model));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> searchCategories(String query) async {
    try {
      final models = await api.searchCategories(query);
      final entities = models.map((model) => CategoryMapper.toEntity(model)).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesByParent(String parentId) async {
    try {
      final models = await api.getCategoriesByParent(parentId);
      final entities = models.map((model) => CategoryMapper.toEntity(model)).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      final model = CategoryMapper.fromEntity(category);
      final result = await api.createCategory(model);
      return Right(CategoryMapper.toEntity(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      final model = CategoryMapper.fromEntity(category);
      final result = await api.updateCategory(category.id, model);
      return Right(CategoryMapper.toEntity(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await api.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}