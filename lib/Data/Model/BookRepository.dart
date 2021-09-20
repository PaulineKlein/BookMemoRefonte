import 'Book.dart';
import 'BookDao.dart';

class BookRepository {
  final bookDao = BookDao();

  Future insertBook(Book book) => bookDao.insertBook(book);

  Future updateBook(Book book) => bookDao.updateBook(book);

  Future deleteBook(String title) => bookDao.deleteBook(title);

  Future getBooks(List<String>? columns) => bookDao.getBooks(columns);
}
