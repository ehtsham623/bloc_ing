import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;

  const Product({required this.id, required this.title, required this.description, required this.price});

  Product copyWith({String? id, String? title, String? description, double? price}) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [id, title, description, price];
}
