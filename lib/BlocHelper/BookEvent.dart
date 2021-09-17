import 'package:equatable/equatable.dart';

import '../Model/Book.dart';

// Create events to add and remove products from the list of items:
abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class AddProduct extends BookEvent {
  final Book product;

  const AddProduct(this.product);

  @override
  List<Object> get props => [product];

  @override
  String toString() => 'AddProduct { title: ${product.title} }';
}

class RemoveProduct extends BookEvent {
  final Book product;

  const RemoveProduct(this.product);

  @override
  List<Object> get props => [product];

  @override
  String toString() => 'RemoveProduct { title: ${product.title} }';
}
