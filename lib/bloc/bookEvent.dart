import 'package:book_memo/data/model/book.dart';
import 'package:equatable/equatable.dart';

// Create events to add and remove products from the list of items:
abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class LoadBook extends BookEvent {}

class SearchBook extends BookEvent {
  final String searchInput;

  const SearchBook(this.searchInput);

  @override
  List<Object> get props => [searchInput];
}

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
