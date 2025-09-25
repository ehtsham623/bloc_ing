import 'package:bloc_ing/blocApp/productEvent.dart';
import 'package:bloc_ing/blocApp/productRepository.dart';
import 'package:bloc_ing/blocApp/productRepositoryImp.dart';
import 'package:bloc_ing/blocApp/productState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  final ProductRepository repository = InMemoryProductRepository();

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final items = await repository.fetchAll();
      emit(ProductLoaded(items));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = (state as ProductLoaded).products;
      emit(ProductLoading());
      try {
        final created = await repository.create(event.product);
        final updated = [created, ...current];
        emit(ProductLoaded(updated));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = (state as ProductLoaded).products;
      emit(ProductLoading());
      try {
        final updatedProduct = await repository.update(event.product);
        final updated = current.map((p) => p.id == updatedProduct.id ? updatedProduct : p).toList();
        emit(ProductLoaded(updated));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = (state as ProductLoaded).products;
      emit(ProductLoading());
      try {
        await repository.delete(event.id);
        final updated = current.where((p) => p.id != event.id).toList();
        emit(ProductLoaded(updated));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }
}
