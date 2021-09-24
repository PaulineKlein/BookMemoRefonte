import 'book.dart';
import 'bookDao.dart';

class BookRepository {
  final bookDao = BookDao();

  Future insertBook(Book book) => bookDao.insertBook(book);

  Future updateBook(Book book) => bookDao.updateBook(book);

  Future deleteBook(int id) => bookDao.deleteBook(id);

  Future increaseBook(Book book, String column, int value) =>
      bookDao.increaseBook(book, column, value);

  Future getBooks(String? whereQuery, List<String>? whereArg) =>
      bookDao.getBooks(whereQuery, whereArg);
}
