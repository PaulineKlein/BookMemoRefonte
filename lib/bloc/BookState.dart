//create states to represent a product being added and removed:
import 'package:book_memo/Data/Model/Book.dart';
import 'package:equatable/equatable.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class InitialBookState extends BookState {}

class BookHasData extends BookState {
  final List<Book> booksList;

  const BookHasData(this.booksList);

  @override
  List<Object> get props => [booksList];
}

class BookNoData extends BookState {
  final String message;

  const BookNoData(this.message);

  List<Object> get props => [message];

  @override
  String toString() => 'Book List No Data (message : $message)';
}

class BookSuccess extends BookState {
  final String message;

  const BookSuccess(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Book Success (message: $message)';
}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Book Failure (message: $message)';
}
