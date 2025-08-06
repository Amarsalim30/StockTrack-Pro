import 'package:dartz/dartz.dart';
import '../entities/catalog/product.dart';
import '../repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<Either<Exception, Product>> call(Product product) async {
    return await repository.createProduct(product);
  }
}
