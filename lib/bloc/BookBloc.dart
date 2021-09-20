import 'package:book_memo/Data/Model/BookRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Strings.dart';
import 'BookEvent.dart';
import 'BookState.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;

  BookBloc({required this.repository}) : super(InitialBookState());

  @override
  Stream<BookState> mapEventToState(BookEvent event) async* {
    if (event is LoadBook) {
      yield* _mapLoadBookToState();
    } else if (event is AddBook) {
      yield* _mapAddBookToState(event);
    } else if (event is RemoveBook) {
      yield* _mapRemoveBookToState(event);
    }
  }

  Stream<BookState> _mapLoadBookToState() async* {
    try {
      var books = await repository.getBooks(null);
      if (books.isEmpty) {
        yield BookNoData(Strings.homeEmptyList);
      } else {
        yield BookHasData(books);
      }
    } catch (e) {
      yield BookError(e.toString());
    }
  }

  Stream<BookState> _mapAddBookToState(AddBook event) async* {
    try {
      await repository.insertBook(event.book);
      yield BookSuccess(event.book.title + ' add to database');
    } catch (e) {
      yield BookError(e.toString());
    }
  }

  Stream<BookState> _mapRemoveBookToState(RemoveBook event) async* {
    try {
      await repository.deleteBook(event.book.title);
      yield BookSuccess(event.book.title + ' remove to database');
    } catch (e) {
      yield BookError(e.toString());
    }
  }
}
