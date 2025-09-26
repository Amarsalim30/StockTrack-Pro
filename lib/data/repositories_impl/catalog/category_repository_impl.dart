import 'package:dartz/dartz.dart';
import '../../../domain/entities/catalog/category.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../../core/error/failures.dart';
import '../../datasources/remote/catalog/category_firebase_data_source.dart';
import '../../mappers/catalog/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryFirebaseDataSource _firebaseDataSource;

  CategoryRepositoryImpl(this._firebaseDataSource);

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    final result = await _firebaseDataSource.getAllCategories();
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (models) => Right(models.map(CategoryMapper.toEntity).toList()),
    );
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    final result = await _firebaseDataSource.getCategoryById(id);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (model) => Right(CategoryMapper.toEntity(model)),
    );
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    final model = CategoryMapper.fromEntity(category);
    final result = await _firebaseDataSource.createCategory(model);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (model) => Right(CategoryMapper.toEntity(model)),
    );
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    final model = CategoryMapper.fromEntity(category);
    final result = await _firebaseDataSource.updateCategory(model);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (model) => Right(CategoryMapper.toEntity(model)),
    );
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    final result = await _firebaseDataSource.deleteCategory(id);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (success) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, List<Category>>> searchCategories(String query) async {
    // For now, implement a basic search by filtering all categories
    final result = await _firebaseDataSource.getAllCategories();
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (models) {
        final filteredModels = models.where((model) =>
          model.name.toLowerCase().contains(query.toLowerCase())).toList();
        return Right(filteredModels.map(CategoryMapper.toEntity).toList());
      },
    );
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesByParent(String parentId) async {
    final result = await _firebaseDataSource.getSubCategories(parentId);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (models) => Right(models.map(CategoryMapper.toEntity).toList()),
    );
  }
}