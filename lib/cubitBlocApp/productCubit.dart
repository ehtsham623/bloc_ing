import 'package:bloc_ing/cubitBlocApp/productModel.dart';
import 'package:bloc_ing/cubitBlocApp/productRepository.dart';
import 'package:bloc_ing/cubitBlocApp/productRepositoryImp.dart';
import 'package:bloc_ing/cubitBlocApp/productState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState());
  final ProductRepository repository = InMemoryProductRepository();
  
  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final items = await repository.fetchAll();
      emit(state.copyWith(status: ProductStatus.success, products: items));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> addProduct(Product product) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final created = await repository.create(product);
      final updated = [created, ...state.products];
      emit(state.copyWith(status: ProductStatus.success, products: updated));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> updateProduct(Product product) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final updatedProduct = await repository.update(product);
      final updated = state.products.map((p) => p.id == updatedProduct.id ? updatedProduct : p).toList();
      emit(state.copyWith(status: ProductStatus.success, products: updated));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> deleteProduct(String id) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await repository.delete(id);
      final updated = state.products.where((p) => p.id != id).toList();
      emit(state.copyWith(status: ProductStatus.success, products: updated));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.failure, errorMessage: e.toString()));
    }
  }
}
