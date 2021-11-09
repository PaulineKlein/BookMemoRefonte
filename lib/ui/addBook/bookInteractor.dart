import 'package:bookmemo/data/model/book.dart';
import 'package:bookmemo/data/model/bookRepository.dart';
import 'package:bookmemo/helper/widgetHelper.dart';

class BookInteractor {
  final WidgetHelper widgetHelper;
  final BookRepository repository;

  BookInteractor({required this.widgetHelper, required this.repository});

  Future<int> insertBook(Book book) {
    var response = repository.insertBook(book);
    widgetHelper.sendAndUpdate();
    return response;
  }

  Future<int> updateBook(Book book) {
    var response = repository.updateBook(book);
    widgetHelper.sendAndUpdate();
    return response;
  }

  Future<int> deleteBook(int id) {
    var response = repository.deleteBook(id);
    widgetHelper.sendAndUpdate();
    return response;
  }

  Future<int> increaseBook(Book book, String column, int value) {
    var response = repository.increaseBook(book, column, value);
    widgetHelper.sendAndUpdate();
    return response;
  }

  Future<List<Book>> getBooks(String? whereQuery, List<String>? whereArg) {
    return repository.getBooks(whereQuery, whereArg);
  }
}
