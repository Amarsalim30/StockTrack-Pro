import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../models/general/unit_model.dart';

abstract class UnitFirebaseDataSource {
  Future<Either<Exception, List<UnitModel>>> getAllUnits();
  Future<Either<Exception, UnitModel>> getUnitById(String id);
  Future<Either<Exception, UnitModel>> createUnit(UnitModel unit);
  Future<Either<Exception, UnitModel>> updateUnit(UnitModel unit);
  Future<Either<Exception, void>> deleteUnit(String id);
  Future<Either<Exception, List<UnitModel>>> searchUnits(String query);
}

class UnitFirebaseDataSourceImpl implements UnitFirebaseDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'units';

  UnitFirebaseDataSourceImpl(this._firestore);

  @override
  Future<Either<Exception, List<UnitModel>>> getAllUnits() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final units = snapshot.docs
          .map((doc) => UnitModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return Right(units);
    } catch (e) {
      return Left(Exception('Failed to fetch units: $e'));
    }
  }

  @override
  Future<Either<Exception, UnitModel>> getUnitById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        return Left(Exception('Unit not found'));
      }
      final unit = UnitModel.fromJson({...doc.data()!, 'id': doc.id});
      return Right(unit);
    } catch (e) {
      return Left(Exception('Failed to fetch unit: $e'));
    }
  }

  @override
  Future<Either<Exception, UnitModel>> createUnit(UnitModel unit) async {
    try {
      final docRef = await _firestore.collection(_collection).add(unit.toJson()..remove('id'));
      final createdUnit = unit.copyWith(id: docRef.id);
      return Right(createdUnit);
    } catch (e) {
      return Left(Exception('Failed to create unit: $e'));
    }
  }

  @override
  Future<Either<Exception, UnitModel>> updateUnit(UnitModel unit) async {
    try {
      await _firestore.collection(_collection).doc(unit.id).update(unit.toJson()..remove('id'));
      return Right(unit);
    } catch (e) {
      return Left(Exception('Failed to update unit: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteUnit(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to delete unit: $e'));
    }
  }

  @override
  Future<Either<Exception, List<UnitModel>>> searchUnits(String query) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      final units = snapshot.docs
          .map((doc) => UnitModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return Right(units);
    } catch (e) {
      return Left(Exception('Failed to search units: $e'));
    }
  }
}