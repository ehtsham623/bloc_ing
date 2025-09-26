import 'package:bloc_ing/cubitBlocApp/productModel.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchAll();
  Future<Product> create(Product product);
  Future<Product> update(Product product);
  Future<void> delete(String id);
}
