import 'package:book_memo/ui/addBook/bookInteractor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../strings.dart';
import 'bookEvent.dart';
import 'bookState.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookInteractor interactor;

  BookBloc({required this.interactor}) : super(InitialBookState());

  @override
  Stream<BookState> mapEventToState(BookEvent event) async* {
    if (event is LoadBook) {
      yield* _mapLoadBookToState();
    } else if (event is AddBook) {
      yield* _mapAddBookToState(event);
    } else if (event is RemoveBook) {
      yield* _mapRemoveBookToState(event);
    } else if (event is FilterBook) {
      yield* _mapFilterBookToState(event);
    } else if (event is IncreaseBook) {
      yield* _mapIncreaseBookToState(event);
    }
  }

  Stream<BookState> _mapLoadBookToState() async* {
    try {
      var books = await interactor.getBooks(null, null);
      if (books.isEmpty) {
        yield BookNoData(Strings.homeEmptyList);
      } else {
        yield BookHasData(books);
      }
    } catch (e) {
      yield BookError(e.toString());
    }
  }

  Stream<BookState> _mapFilterBookToState(FilterBook event) async* {
    try {
      var books = await interactor.getBooks(event.query, null);
      if (books.isEmpty) {
        yield BookNoData(Strings.filterEmptyList);
      } else {
        yield BookHasData(books);
      }
    } catch (e) {
      yield BookError(e.toString());
    }
  }

  Stream<BookState> _mapAddBookToState(AddBook event) async* {
    try {
      await interactor.insertBook(event.book);
      yield BookSuccess(event.book.title + ' add to database');
    } catch (e) {
      yield BookError(e.toString());
    }
  }

  Stream<BookState> _mapRemoveBookToState(RemoveBook event) async* {
    try {
      if (event.book.id == null) {
        yield BookError(Strings.genericError);
      } else {
        await interactor.deleteBook(event.book.id!);
      }
    } catch (e) {
      yield BookError(e.toString());
    }
  }

  Stream<BookState> _mapIncreaseBookToState(IncreaseBook event) async* {
    try {
      await interactor.increaseBook(event.book, event.column, event.value);
    } catch (e) {
      yield BookError(e.toString());
    }
  }
}
