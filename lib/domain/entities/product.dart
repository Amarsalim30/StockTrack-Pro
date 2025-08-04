import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String code;
  final String? description;
  final double price;
  final int quantity;
  final int reorderLevel;
  final int reorderQuantity;
  final String category;
  final String? supplierId;
  final String? supplierName;
  final String? locationId;
  final String? locationName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.price,
    required this.quantity,
    required this.reorderLevel,
    required this.reorderQuantity,
    required this.category,
    this.supplierId,
    this.supplierName,
    this.locationId,
    this.locationName,
    this.createdAt,
    this.updatedAt,
  });

  bool get isLowStock => quantity <= reorderLevel;

  bool get isOutOfStock => quantity == 0;

  bool get isCriticalStock => quantity > 0 && quantity <= (reorderLevel / 2);

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    description,
    price,
    quantity,
    reorderLevel,
    reorderQuantity,
    category,
    supplierId,
    supplierName,
    locationId,
    locationName,
    createdAt,
    updatedAt,
  ];
}
