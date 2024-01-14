import 'package:bookmemo/ui/addBook/bookInteractor.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bookEvent.dart';
import 'bookState.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookInteractor interactor;

  BookBloc({required this.interactor}) : super(InitialBookState()) {
    on<BookEvent>((event, emit) async {
      if (event is LoadBook) {
        await _mapLoadBookToState(emit);
      } else if (event is AddBook) {
        await _mapAddBookToState(event, emit);
      } else if (event is RemoveBook) {
        await _mapRemoveBookToState(event, emit);
      } else if (event is FilterBook) {
        await _mapFilterBookToState(event, emit);
      } else if (event is IncreaseBook) {
        await _mapIncreaseBookToState(event, emit);
      }
    });
  }

  Future<void> _mapLoadBookToState(Emitter<BookState> emit) async {
    try {
      await interactor.getBooks(null, null).then((books) async {
        if (books.isEmpty) {
          emit(BookNoData('homeEmptyList'.tr()));
        } else {
          emit(BookHasData(books));
        }
      });
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _mapFilterBookToState(
      FilterBook event, Emitter<BookState> emit) async {
    try {
      await interactor.getBooks(event.query, null).then((books) async {
        if (books.isEmpty) {
          emit(BookNoData('filterEmptyList'.tr()));
        } else {
          emit(BookHasData(books));
        }
      });
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _mapAddBookToState(
      AddBook event, Emitter<BookState> emit) async {
    try {
      await interactor.insertBook(event.book).then((books) async {
        emit(BookSuccess(event.book.title + ' add to database'));
      });
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _mapRemoveBookToState(
      RemoveBook event, Emitter<BookState> emit) async {
    try {
      if (event.book.id == null) {
        emit(BookError('genericError'.tr()));
      } else {
        await interactor.deleteBook(event.book.id!);
      }
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _mapIncreaseBookToState(
      IncreaseBook event, Emitter<BookState> emit) async {
    try {
      await interactor.increaseBook(event.book, event.column, event.value);
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}
