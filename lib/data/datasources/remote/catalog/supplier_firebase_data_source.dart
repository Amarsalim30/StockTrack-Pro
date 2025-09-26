import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../models/catalog/supplier_model.dart';

abstract class SupplierFirebaseDataSource {
  Future<Either<Exception, List<SupplierModel>>> getAllSuppliers();
  Future<Either<Exception, SupplierModel>> getSupplierById(String id);
  Future<Either<Exception, SupplierModel>> createSupplier(SupplierModel supplier);
  Future<Either<Exception, SupplierModel>> updateSupplier(SupplierModel supplier);
  Future<Either<Exception, void>> deleteSupplier(String id);
  Future<Either<Exception, List<SupplierModel>>> getActiveSuppliers();
  Future<Either<Exception, List<SupplierModel>>> searchSuppliers(String query);
}

class SupplierFirebaseDataSourceImpl implements SupplierFirebaseDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'suppliers';

  SupplierFirebaseDataSourceImpl(this._firestore);

  @override
  Future<Either<Exception, List<SupplierModel>>> getAllSuppliers() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final suppliers = snapshot.docs
          .map((doc) => SupplierModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return Right(suppliers);
    } catch (e) {
      return Left(Exception('Failed to fetch suppliers: $e'));
    }
  }

  @override
  Future<Either<Exception, SupplierModel>> getSupplierById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        return Left(Exception('Supplier not found'));
      }
      final supplier = SupplierModel.fromJson({...doc.data()!, 'id': doc.id});
      return Right(supplier);
    } catch (e) {
      return Left(Exception('Failed to fetch supplier: $e'));
    }
  }

  @override
  Future<Either<Exception, SupplierModel>> createSupplier(SupplierModel supplier) async {
    try {
      final docRef = await _firestore.collection(_collection).add(supplier.toJson()..remove('id'));
      final createdSupplier = supplier.copyWith(id: docRef.id);
      return Right(createdSupplier);
    } catch (e) {
      return Left(Exception('Failed to create supplier: $e'));
    }
  }

  @override
  Future<Either<Exception, SupplierModel>> updateSupplier(SupplierModel supplier) async {
    try {
      await _firestore.collection(_collection).doc(supplier.id).update(supplier.toJson()..remove('id'));
      return Right(supplier);
    } catch (e) {
      return Left(Exception('Failed to update supplier: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteSupplier(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to delete supplier: $e'));
    }
  }

  @override
  Future<Either<Exception, List<SupplierModel>>> getActiveSuppliers() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      final suppliers = snapshot.docs
          .map((doc) => SupplierModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return Right(suppliers);
    } catch (e) {
      return Left(Exception('Failed to fetch active suppliers: $e'));
    }
  }

  @override
  Future<Either<Exception, List<SupplierModel>>> searchSuppliers(String query) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      final suppliers = snapshot.docs
          .map((doc) => SupplierModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return Right(suppliers);
    } catch (e) {
      return Left(Exception('Failed to search suppliers: $e'));
    }
  }
}