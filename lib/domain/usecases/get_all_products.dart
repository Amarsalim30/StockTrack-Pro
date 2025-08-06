import 'package:dartz/dartz.dart';
import '../entities/catalog/product.dart';
import '../repositories/product_repository.dart';

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  Future<Either<Exception, List<Product>>> call() async {
    return await repository.getAllProducts();
  }
}
