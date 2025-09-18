import 'dart:async';
import 'dart:typed_data';

/// Firebase Storage test data source for testing purposes
class FirebaseStorageTestDataSource {
  final Map<String, Map<String, dynamic>> _files = {};
  final Map<String, StreamController<double>> _uploadProgressControllers = {};

  /// Upload a file
  Future<String> uploadFile(
    String path,
    Uint8List data, {
    String? contentType,
    Map<String, String>? metadata,
  }) async {
    final uploadId = 'upload_${DateTime.now().millisecondsSinceEpoch}';
    
    // Simulate upload progress
    final progressController = StreamController<double>();
    _uploadProgressControllers[uploadId] = progressController;

    // Simulate progressive upload
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 50));
      progressController.add(i / 100.0);
    }

    final downloadUrl = 'https://test-storage.firebase.com/$path';
    
    _files[path] = {
      'data': data,
      'contentType': contentType ?? 'application/octet-stream',
      'metadata': metadata ?? {},
      'downloadUrl': downloadUrl,
      'uploadedAt': DateTime.now().toIso8601String(),
      'size': data.length,
    };

    progressController.close();
    _uploadProgressControllers.remove(uploadId);

    return downloadUrl;
  }

  /// Upload file with progress stream
  Stream<double> uploadFileWithProgress(
    String path,
    Uint8List data, {
    String? contentType,
    Map<String, String>? metadata,
  }) {
    final controller = StreamController<double>();
    
    uploadFile(path, data, contentType: contentType, metadata: metadata).then((_) {
      controller.close();
    }).catchError((error) {
      controller.addError(error);
    });

    return controller.stream;
  }

  /// Download a file
  Future<Uint8List> downloadFile(String path) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final file = _files[path];
    if (file == null) {
      throw Exception('File not found: $path');
    }

    return file['data'] as Uint8List;
  }

  /// Get download URL
  Future<String> getDownloadUrl(String path) async {
    await Future.delayed(const Duration(milliseconds: 50));

    final file = _files[path];
    if (file == null) {
      throw Exception('File not found: $path');
    }

    return file['downloadUrl'] as String;
  }

  /// Delete a file
  Future<void> deleteFile(String path) async {
    await Future.delayed(const Duration(milliseconds: 60));

    if (!_files.containsKey(path)) {
      throw Exception('File not found: $path');
    }

    _files.remove(path);
  }

  /// Get file metadata
  Future<Map<String, dynamic>> getFileMetadata(String path) async {
    await Future.delayed(const Duration(milliseconds: 40));

    final file = _files[path];
    if (file == null) {
      throw Exception('File not found: $path');
    }

    return {
      'contentType': file['contentType'],
      'customMetadata': file['metadata'],
      'size': file['size'],
      'timeCreated': file['uploadedAt'],
      'updated': file['uploadedAt'],
      'downloadTokens': ['mock-token-123'],
    };
  }

  /// Update file metadata
  Future<void> updateFileMetadata(
    String path,
    Map<String, String> metadata,
  ) async {
    await Future.delayed(const Duration(milliseconds: 50));

    final file = _files[path];
    if (file == null) {
      throw Exception('File not found: $path');
    }

    file['metadata'] = {
      ...file['metadata'] as Map<String, String>,
      ...metadata,
    };
  }

  /// List files in a directory
  Future<List<String>> listFiles(String directory, {int? maxResults}) async {
    await Future.delayed(const Duration(milliseconds: 80));

    final files = _files.keys
        .where((path) => path.startsWith(directory))
        .toList();

    if (maxResults != null && maxResults > 0) {
      return files.take(maxResults).toList();
    }

    return files;
  }

  /// Check if file exists
  Future<bool> fileExists(String path) async {
    await Future.delayed(const Duration(milliseconds: 30));
    return _files.containsKey(path);
  }

  /// Get file size
  Future<int> getFileSize(String path) async {
    await Future.delayed(const Duration(milliseconds: 30));

    final file = _files[path];
    if (file == null) {
      throw Exception('File not found: $path');
    }

    return file['size'] as int;
  }

  /// Copy file
  Future<String> copyFile(String sourcePath, String destinationPath) async {
    await Future.delayed(const Duration(milliseconds: 70));

    final sourceFile = _files[sourcePath];
    if (sourceFile == null) {
      throw Exception('Source file not found: $sourcePath');
    }

    final newDownloadUrl = 'https://test-storage.firebase.com/$destinationPath';
    
    _files[destinationPath] = {
      ...sourceFile,
      'downloadUrl': newDownloadUrl,
      'uploadedAt': DateTime.now().toIso8601String(),
    };

    return newDownloadUrl;
  }

  /// Move file
  Future<String> moveFile(String sourcePath, String destinationPath) async {
    final newUrl = await copyFile(sourcePath, destinationPath);
    await deleteFile(sourcePath);
    return newUrl;
  }

  // Test helper methods
  void addMockFile(
    String path,
    Uint8List data, {
    String? contentType,
    Map<String, String>? metadata,
  }) {
    _files[path] = {
      'data': data,
      'contentType': contentType ?? 'application/octet-stream',
      'metadata': metadata ?? {},
      'downloadUrl': 'https://test-storage.firebase.com/$path',
      'uploadedAt': DateTime.now().toIso8601String(),
      'size': data.length,
    };
  }

  void clearAllFiles() {
    _files.clear();
  }

  void simulateNetworkError() {
    throw Exception('Network error - Firebase Storage test simulation');
  }

  void simulateInsufficientStorage() {
    throw Exception('Insufficient storage quota');
  }

  void simulateUnauthorizedAccess() {
    throw Exception('User does not have permission to access this resource');
  }

  // Getters for testing
  int get totalFiles => _files.length;
  
  int get totalStorage => _files.values
      .map((file) => file['size'] as int)
      .fold(0, (sum, size) => sum + size);

  List<String> get allFilePaths => _files.keys.toList();

  Map<String, dynamic>? getFileInfo(String path) => _files[path];
}