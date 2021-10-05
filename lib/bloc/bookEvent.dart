import 'package:bookmemo/data/model/book.dart';
import 'package:equatable/equatable.dart';

// Create events to add and remove products from the list of items:
abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class LoadBook extends BookEvent {}

class FilterBook extends BookEvent {
  final String? query;

  const FilterBook(this.query);

  @override
  List<Object?> get props => [query];
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

class IncreaseBook extends BookEvent {
  final Book book;
  final String column;
  final int value;

  const IncreaseBook(this.book, this.column, this.value);

  @override
  List<Object> get props => [book];
}
