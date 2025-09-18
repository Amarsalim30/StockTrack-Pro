import 'dart:async';

/// Firestore test data source for testing purposes
class FirestoreTestDataSource {
  final Map<String, Map<String, Map<String, dynamic>>> _collections = {};
  final Map<String, StreamController<List<Map<String, dynamic>>>> _streamControllers = {};

  /// Add a document to a collection
  Future<String> addDocument(String collection, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 50));

    final docId = 'doc_${DateTime.now().millisecondsSinceEpoch}_${data.hashCode}';
    
    _collections[collection] ??= {};
    _collections[collection]![docId] = {
      ...data,
      'id': docId,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    _notifyStreamListeners(collection);
    return docId;
  }

  /// Get a document by ID
  Future<Map<String, dynamic>?> getDocument(String collection, String docId) async {
    await Future.delayed(const Duration(milliseconds: 30));

    return _collections[collection]?[docId];
  }

  /// Update a document
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 40));

    if (_collections[collection]?[docId] != null) {
      _collections[collection]![docId]!.addAll({
        ...updates,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      _notifyStreamListeners(collection);
    } else {
      throw Exception('Document not found');
    }
  }

  /// Delete a document
  Future<void> deleteDocument(String collection, String docId) async {
    await Future.delayed(const Duration(milliseconds: 30));

    _collections[collection]?.remove(docId);
    _notifyStreamListeners(collection);
  }

  /// Get all documents in a collection
  Future<List<Map<String, dynamic>>> getCollection(String collection) async {
    await Future.delayed(const Duration(milliseconds: 60));

    return _collections[collection]?.values.toList() ?? [];
  }

  /// Query documents with where clause
  Future<List<Map<String, dynamic>>> queryWhere(
    String collection,
    String field,
    dynamic value, {
    String operator = '==',
  }) async {
    await Future.delayed(const Duration(milliseconds: 80));

    final docs = _collections[collection]?.values.toList() ?? [];
    
    return docs.where((doc) {
      final fieldValue = doc[field];
      switch (operator) {
        case '==':
          return fieldValue == value;
        case '!=':
          return fieldValue != value;
        case '>':
          return fieldValue is num && value is num && fieldValue > value;
        case '>=':
          return fieldValue is num && value is num && fieldValue >= value;
        case '<':
          return fieldValue is num && value is num && fieldValue < value;
        case '<=':
          return fieldValue is num && value is num && fieldValue <= value;
        case 'array-contains':
          return fieldValue is List && fieldValue.contains(value);
        default:
          return false;
      }
    }).toList();
  }

  /// Query documents with multiple conditions
  Future<List<Map<String, dynamic>>> queryMultiple(
    String collection,
    List<Map<String, dynamic>> conditions, {
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    var docs = _collections[collection]?.values.toList() ?? [];

    // Apply conditions
    for (final condition in conditions) {
      final field = condition['field'];
      final operator = condition['operator'] ?? '==';
      final value = condition['value'];

      docs = docs.where((doc) {
        final fieldValue = doc[field];
        switch (operator) {
          case '==':
            return fieldValue == value;
          case '!=':
            return fieldValue != value;
          case '>':
            return fieldValue is num && value is num && fieldValue > value;
          case '>=':
            return fieldValue is num && value is num && fieldValue >= value;
          case '<':
            return fieldValue is num && value is num && fieldValue < value;
          case '<=':
            return fieldValue is num && value is num && fieldValue <= value;
          case 'array-contains':
            return fieldValue is List && fieldValue.contains(value);
          default:
            return false;
        }
      }).toList();
    }

    // Apply ordering
    if (orderBy != null) {
      docs.sort((a, b) {
        final aValue = a[orderBy];
        final bValue = b[orderBy];
        
        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return descending ? 1 : -1;
        if (bValue == null) return descending ? -1 : 1;

        final comparison = Comparable.compare(aValue, bValue);
        return descending ? -comparison : comparison;
      });
    }

    // Apply limit
    if (limit != null && limit > 0) {
      docs = docs.take(limit).toList();
    }

    return docs;
  }

  /// Listen to collection changes
  Stream<List<Map<String, dynamic>>> streamCollection(String collection) {
    _streamControllers[collection] ??= StreamController<List<Map<String, dynamic>>>.broadcast();
    
    // Emit current data immediately
    Future.delayed(const Duration(milliseconds: 10), () {
      _notifyStreamListeners(collection);
    });
    
    return _streamControllers[collection]!.stream;
  }

  /// Listen to document changes
  Stream<Map<String, dynamic>?> streamDocument(String collection, String docId) {
    final controller = StreamController<Map<String, dynamic>?>.broadcast();
    
    // Emit current data immediately
    Future.delayed(const Duration(milliseconds: 10), () async {
      final doc = await getDocument(collection, docId);
      controller.add(doc);
    });
    
    // Listen to collection changes and filter for this document
    streamCollection(collection).listen((docs) {
      final doc = docs.firstWhere(
        (d) => d['id'] == docId,
        orElse: () => <String, dynamic>{},
      );
      controller.add(doc.isEmpty ? null : doc);
    });
    
    return controller.stream;
  }

  void _notifyStreamListeners(String collection) {
    if (_streamControllers[collection] != null) {
      final docs = _collections[collection]?.values.toList() ?? [];
      _streamControllers[collection]!.add(docs);
    }
  }

  // Test helper methods
  void addMockData(String collection, List<Map<String, dynamic>> documents) {
    _collections[collection] ??= {};
    for (final doc in documents) {
      final docId = doc['id'] ?? 'doc_${DateTime.now().millisecondsSinceEpoch}_${doc.hashCode}';
      _collections[collection]![docId] = {
        ...doc,
        'id': docId,
        'createdAt': doc['createdAt'] ?? DateTime.now().toIso8601String(),
        'updatedAt': doc['updatedAt'] ?? DateTime.now().toIso8601String(),
      };
    }
    _notifyStreamListeners(collection);
  }

  void clearCollection(String collection) {
    _collections[collection]?.clear();
    _notifyStreamListeners(collection);
  }

  void clearAllCollections() {
    _collections.clear();
    for (final controller in _streamControllers.values) {
      controller.add([]);
    }
  }

  void dispose() {
    for (final controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
  }

  // Simulate network errors
  void simulateNetworkError() {
    throw Exception('Network error - Firestore test simulation');
  }

  Map<String, int> get collectionCounts {
    return _collections.map((key, value) => MapEntry(key, value.length));
  }
}