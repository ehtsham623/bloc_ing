import 'package:bloc_ing/cubitBlocApp/productModel.dart';
import 'package:bloc_ing/cubitBlocApp/productRepository.dart';
import 'package:bloc_ing/cubitBlocApp/productRepositoryImp.dart';
import 'package:bloc_ing/cubitBlocApp/productState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial()) {
    loadProducts();
  }
  final ProductRepository repository = InMemoryProductRepository();

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final items = await repository.fetchAll();
      emit(ProductLoaded(items));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> addProduct(Product product) async {
    emit(ProductLoading());
    try {
      final created = await repository.create(product);
      final current = (state as ProductLoaded).products;
      final updated = [created, ...current];

      emit(ProductLoaded(updated));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> updateProduct(Product product) async {
    emit(ProductLoading());
    try {
      final updatedProduct = await repository.update(product);
      final current = (state as ProductLoaded).products;
      final updated = current.map((p) => p.id == updatedProduct.id ? updatedProduct : p).toList();
      emit(ProductLoaded(updated));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> deleteProduct(String id) async {
    emit(ProductLoading());
    try {
      await repository.delete(id);
      final current = (state as ProductLoaded).products;
      final updated = current.where((p) => p.id != id).toList();
      emit(ProductLoaded(updated));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
