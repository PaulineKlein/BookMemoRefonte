import 'package:book_memo/Data/Model/Book.dart';
import 'package:equatable/equatable.dart';

// Create events to add and remove products from the list of items:
abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class LoadBook extends BookEvent {}

class AddBook extends BookEvent {
  final Book book;

  const AddBook(this.book);

  @override
  List<Object> get props => [book];
}

class RemoveBook extends BookEvent {
  final Book book;

  const RemoveBook(this.book);

  @override
  List<Object> get props => [book];
}
