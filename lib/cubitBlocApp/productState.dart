// import 'package:bloc_ing/cubitBlocApp/productModel.dart';
// import 'package:equatable/equatable.dart';

// enum ProductStatus { initial, loading, success, failure }

// class ProductState extends Equatable {
//   final ProductStatus status;
//   final List<Product> products;
//   final String? errorMessage;

//   const ProductState({this.status = ProductStatus.initial, this.products = const [], this.errorMessage});

//   ProductState copyWith({ProductStatus? status, List<Product>? products, String? errorMessage}) {
//     return ProductState(
//       status: status ?? this.status,
//       products: products ?? this.products,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [status, products, errorMessage];
// }

import 'package:bloc_ing/cubitBlocApp/productModel.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);
  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object?> get props => [message];
}
