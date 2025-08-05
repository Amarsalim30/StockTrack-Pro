import 'package:equatable/equatable.dart';

enum CountMethod { manual, barcode, photo, rfid }

class StockTakeItem extends Equatable {
  final String id;
  final String stockTakeId;
  final String productId;
  final String productName;
  final String productCode;
  final int systemQuantity;
  final int? countedQuantity;
  final int? discrepancy;
  final CountMethod? countMethod;
  final String? countedBy;
  final DateTime? countedAt;
  final String? notes;
  final List<String>? photoUrls;
  final bool isCounted;
  final bool hasDiscrepancy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StockTakeItem({
    required this.id,
    required this.stockTakeId,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.systemQuantity,
    this.countedQuantity,
    this.discrepancy,
    this.countMethod,
    this.countedBy,
    this.countedAt,
    this.notes,
    this.photoUrls,
    required this.isCounted,
    required this.hasDiscrepancy,
    required this.createdAt,
    required this.updatedAt,
  });

  StockTakeItem copyWith({
    String? id,
    String? stockTakeId,
    String? productId,
    String? productName,
    String? productCode,
    int? systemQuantity,
    int? countedQuantity,
    int? discrepancy,
    CountMethod? countMethod,
    String? countedBy,
    DateTime? countedAt,
    String? notes,
    List<String>? photoUrls,
    bool? isCounted,
    bool? hasDiscrepancy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockTakeItem(
      id: id ?? this.id,
      stockTakeId: stockTakeId ?? this.stockTakeId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productCode: productCode ?? this.productCode,
      systemQuantity: systemQuantity ?? this.systemQuantity,
      countedQuantity: countedQuantity ?? this.countedQuantity,
      discrepancy: discrepancy ?? this.discrepancy,
      countMethod: countMethod ?? this.countMethod,
      countedBy: countedBy ?? this.countedBy,
      countedAt: countedAt ?? this.countedAt,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
      isCounted: isCounted ?? this.isCounted,
      hasDiscrepancy: hasDiscrepancy ?? this.hasDiscrepancy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    stockTakeId,
    productId,
    productName,
    productCode,
    systemQuantity,
    countedQuantity,
    discrepancy,
    countMethod,
    countedBy,
    countedAt,
    notes,
    photoUrls,
    isCounted,
    hasDiscrepancy,
    createdAt,
    updatedAt,
  ];
}
