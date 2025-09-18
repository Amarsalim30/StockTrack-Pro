import '../../models/stock/discrepancy_report_model.dart';
import '../../../domain/entities/stock/discrepancy_report.dart';

class DiscrepancyReportMapper {
  static DiscrepancyReport toEntity(DiscrepancyReportModel model) {
    return DiscrepancyReport(
      reportId: model.reportId,
      stockTakeId: model.stockTakeId,
      generatedAt: model.generatedAt,
      totalItems: model.totalItems,
      discrepancyCount: model.discrepancyCount,
      totalDiscrepancyValue: model.totalDiscrepancyValue,
      discrepancies: model.discrepancies
          .map((item) => DiscrepancyItemMapper.toEntity(item))
          .toList(),
    );
  }

  static DiscrepancyReportModel toModel(DiscrepancyReport entity) {
    return DiscrepancyReportModel(
      reportId: entity.reportId,
      stockTakeId: entity.stockTakeId,
      generatedAt: entity.generatedAt,
      totalItems: entity.totalItems,
      discrepancyCount: entity.discrepancyCount,
      totalDiscrepancyValue: entity.totalDiscrepancyValue,
      discrepancies: entity.discrepancies
          .map((item) => DiscrepancyItemMapper.toModel(item))
          .toList(),
    );
  }
}

class DiscrepancyItemMapper {
  static DiscrepancyItem toEntity(DiscrepancyItemModel model) {
    return DiscrepancyItem(
      itemId: model.itemId,
      productName: model.productName,
      sku: model.sku,
      expectedQuantity: model.expectedQuantity,
      actualQuantity: model.actualQuantity,
      discrepancy: model.discrepancy,
      unitPrice: model.unitPrice,
      discrepancyValue: model.discrepancyValue,
    );
  }

  static DiscrepancyItemModel toModel(DiscrepancyItem entity) {
    return DiscrepancyItemModel(
      itemId: entity.itemId,
      productName: entity.productName,
      sku: entity.sku,
      expectedQuantity: entity.expectedQuantity,
      actualQuantity: entity.actualQuantity,
      discrepancy: entity.discrepancy,
      unitPrice: entity.unitPrice,
      discrepancyValue: entity.discrepancyValue,
    );
  }
}