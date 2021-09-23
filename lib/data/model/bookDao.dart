import 'package:sqflite/sqflite.dart';

import '../databaseProvider.dart';
import 'book.dart';

class BookDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> insertBook(Book book) async {
    final db = await dbProvider.database;
    var result = await db.insert(
      bookTable,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> updateBook(Book book) async {
    final db = await dbProvider.database;
    var result = await db.update(bookTable, book.toMap(),
        where: "title = ?", whereArgs: [book.title]);
    return result;
  }

  Future<int> deleteBook(String title) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(bookTable, where: "title = ?", whereArgs: [title]);
    return result;
  }

  Future<List<Book>> getBooks(
      String? whereQuery, List<String>? whereArg) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> result;

    if (whereQuery == null) {
      result = await db.query(bookTable, orderBy: 'title ASC');
    } else if (whereArg == null) {
      result =
          await db.query(bookTable, orderBy: 'title ASC', where: whereQuery);
    } else {
      result = await db.query(bookTable,
          orderBy: 'title ASC', where: whereQuery, whereArgs: whereArg);
    }

    List<Book> books = List.generate(result.length, (i) {
      return Book.fromMap(result[i]);
    });

    return books;
  }
}
