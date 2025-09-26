import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../models/catalog/category_model.dart';

abstract class CategoryFirebaseDataSource {
  Future<Either<Exception, List<CategoryModel>>> getAllCategories();
  Future<Either<Exception, CategoryModel>> getCategoryById(String id);
  Future<Either<Exception, CategoryModel>> createCategory(CategoryModel category);
  Future<Either<Exception, CategoryModel>> updateCategory(CategoryModel category);
  Future<Either<Exception, void>> deleteCategory(String id);
  Future<Either<Exception, List<CategoryModel>>> getSubCategories(String parentCategoryId);
}

class CategoryFirebaseDataSourceImpl implements CategoryFirebaseDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'categories';

  CategoryFirebaseDataSourceImpl(this._firestore);

  @override
  Future<Either<Exception, List<CategoryModel>>> getAllCategories() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return Right(categories);
    } catch (e) {
      return Left(Exception('Failed to fetch categories: $e'));
    }
  }

  @override
  Future<Either<Exception, CategoryModel>> getCategoryById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        return Left(Exception('Category not found'));
      }
      final category = CategoryModel.fromJson({...doc.data()!, 'id': doc.id});
      return Right(category);
    } catch (e) {
      return Left(Exception('Failed to fetch category: $e'));
    }
  }

  @override
  Future<Either<Exception, CategoryModel>> createCategory(CategoryModel category) async {
    try {
      final docRef = await _firestore.collection(_collection).add(category.toJson()..remove('id'));
      final createdCategory = category.copyWith(id: docRef.id);
      return Right(createdCategory);
    } catch (e) {
      return Left(Exception('Failed to create category: $e'));
    }
  }

  @override
  Future<Either<Exception, CategoryModel>> updateCategory(CategoryModel category) async {
    try {
      await _firestore.collection(_collection).doc(category.id).update(category.toJson()..remove('id'));
      return Right(category);
    } catch (e) {
      return Left(Exception('Failed to update category: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteCategory(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to delete category: $e'));
    }
  }

  @override
  Future<Either<Exception, List<CategoryModel>>> getSubCategories(String parentCategoryId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('parentCategoryId', isEqualTo: parentCategoryId)
          .get();

      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return Right(categories);
    } catch (e) {
      return Left(Exception('Failed to fetch subcategories: $e'));
    }
  }
}