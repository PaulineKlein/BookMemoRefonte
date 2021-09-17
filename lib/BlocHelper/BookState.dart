import '../Model/Book.dart';

//create states to represent a product being added and removed:
abstract class BookState {
  final List<Book> bookItem;

  const BookState({required this.bookItem});

  @override
  List<Object> get props => [];
}

class ProductAdded extends BookState {
  final List<Book> bookItem;

  const ProductAdded({required this.bookItem}) : super(bookItem: bookItem);

  @override
  List<Object> get props => [bookItem];

  @override
  String toString() => 'ProductAdded { todos: $bookItem }';
}

class ProductRemoved extends BookState {
  final List<Book> bookItem;

  const ProductRemoved({required this.bookItem}) : super(bookItem: bookItem);

  @override
  List<Object> get props => [bookItem];

  @override
  String toString() => 'ProductRemoved { todos: $bookItem }';
}
