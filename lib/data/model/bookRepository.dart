import 'book.dart';
import 'bookDao.dart';

class BookRepository {
  final bookDao = BookDao();

  Future<int> insertBook(Book book) => bookDao.insertBook(book);

  Future<int> updateBook(Book book) => bookDao.updateBook(book);

  Future<int> deleteBook(int id) => bookDao.deleteBook(id);

  Future<int> increaseBook(Book book, String column, int value) =>
      bookDao.increaseBook(book, column, value);

  Future<List<Book>> getBooks(String? whereQuery, List<String>? whereArg) =>
      bookDao.getBooks(whereQuery, whereArg);
}
