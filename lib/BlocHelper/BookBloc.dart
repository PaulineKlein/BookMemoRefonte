import 'package:book_memo/Data/Model/Book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BookEvent.dart';
import 'BookState.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(ProductAdded(bookItem: []));

  final List<Book> _bookItems = [];

  List<Book> get items => _bookItems;

  @override
  Stream<BookState> mapEventToState(BookEvent event) async* {
    if (event is AddProduct) {
      _bookItems.add(event.product);
      yield ProductAdded(bookItem: _bookItems);
    } else if (event is RemoveProduct) {
      _bookItems.remove(event.product);
      yield ProductRemoved(bookItem: _bookItems);
    }
  }
}
