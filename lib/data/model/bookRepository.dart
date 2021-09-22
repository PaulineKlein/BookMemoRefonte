import 'book.dart';
import 'bookDao.dart';

class BookRepository {
  final bookDao = BookDao();

  Future insertBook(Book book) => bookDao.insertBook(book);

  Future updateBook(Book book) => bookDao.updateBook(book);

  Future deleteBook(String title) => bookDao.deleteBook(title);

  Future getBooks(String? whereQuery, List<String>? whereArg) =>
      bookDao.getBooks(whereQuery, whereArg);
}
