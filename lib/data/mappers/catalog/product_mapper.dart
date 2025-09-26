import '../../../data/models/catalog/product_model.dart';
import '../../../domain/entities/catalog/product.dart';

/// Mapper class for converting between Product domain entity and ProductModel data model
class ProductMapper {
  /// Convert ProductModel to Product domain entity
  static Product toEntity(ProductModel model) => model.toDomain();

  /// Convert Product domain entity to ProductModel
  static ProductModel fromEntity(Product entity) => ProductModel.fromDomain(entity);

  /// Convert ProductModel to Product domain entity (batch operation)
  static List<Product> toEntityList(List<ProductModel> models) =>
      models.map(toEntity).toList();

  /// Convert Product domain entities to ProductModels (batch operation)
  static List<ProductModel> fromEntityList(List<Product> entities) =>
      entities.map(fromEntity).toList();

  /// Create a ProductModel for Firebase creation (handles ID generation and timestamps)
  static ProductModel forCreation(Product entity) =>
      ProductModel.fromDomain(entity).forCreation();

  /// Create a ProductModel for Firebase update (handles timestamp updates)
  static ProductModel forUpdate(Product entity) =>
      ProductModel.fromDomain(entity).forUpdate();
}
