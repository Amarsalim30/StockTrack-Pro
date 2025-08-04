import 'package:equatable/equatable.dart';

enum ActivityType {
  login,
  logout,
  productCreated,
  productUpdated,
  productDeleted,
  stockAdjusted,
  stockTakeStarted,
  stockTakeCompleted,
  supplierCreated,
  supplierUpdated,
  supplierDeleted,
  userCreated,
  userUpdated,
  userDeleted,
  reportGenerated,
  settingsChanged,
}

class Activity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final ActivityType type;
  final String action;
  final String? description;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;
  final String? ipAddress;
  final String? deviceInfo;

  const Activity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.action,
    this.description,
    this.metadata,
    required this.timestamp,
    this.ipAddress,
    this.deviceInfo,
  });

  String get typeLabel {
    switch (type) {
      case ActivityType.login:
        return 'Login';
      case ActivityType.logout:
        return 'Logout';
      case ActivityType.productCreated:
        return 'Product Created';
      case ActivityType.productUpdated:
        return 'Product Updated';
      case ActivityType.productDeleted:
        return 'Product Deleted';
      case ActivityType.stockAdjusted:
        return 'Stock Adjusted';
      case ActivityType.stockTakeStarted:
        return 'Stock Take Started';
      case ActivityType.stockTakeCompleted:
        return 'Stock Take Completed';
      case ActivityType.supplierCreated:
        return 'Supplier Created';
      case ActivityType.supplierUpdated:
        return 'Supplier Updated';
      case ActivityType.supplierDeleted:
        return 'Supplier Deleted';
      case ActivityType.userCreated:
        return 'User Created';
      case ActivityType.userUpdated:
        return 'User Updated';
      case ActivityType.userDeleted:
        return 'User Deleted';
      case ActivityType.reportGenerated:
        return 'Report Generated';
      case ActivityType.settingsChanged:
        return 'Settings Changed';
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    type,
    action,
    description,
    metadata,
    timestamp,
    ipAddress,
    deviceInfo,
  ];
}
