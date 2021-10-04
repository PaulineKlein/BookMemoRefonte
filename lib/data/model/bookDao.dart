import 'package:book_memo/strings.dart';
import 'package:sqflite/sqflite.dart';

import '../databaseProvider.dart';
import 'book.dart';

class BookDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> insertBook(Book book) async {
    final db = await dbProvider.database;
    var result = await db.insert(
      Strings.bookTable,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> updateBook(Book book) async {
    final db = await dbProvider.database;
    var result = await db.update(Strings.bookTable, book.toMap(),
        where: "${Strings.columnId} = ?", whereArgs: [book.id]);
    return result;
  }

  Future<int> deleteBook(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(Strings.bookTable,
        where: "${Strings.columnId} = ?", whereArgs: [id]);
    return result;
  }

  Future<int> increaseBook(Book book, String column, int value) async {
    // row to update
    Map<String, dynamic> row = {column: value};

    final db = await dbProvider.database;
    var result = await db.update(Strings.bookTable, row,
        where: "${Strings.columnId} = ?", whereArgs: [book.id]);
    return result;
  }

  Future<List<Book>> getBooks(
      String? whereQuery, List<String>? whereArg) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> result;

    if (whereQuery == null) {
      result = await db.query(Strings.bookTable,
          orderBy: 'lower(${Strings.columnTitle}) ASC');
    } else if (whereArg == null) {
      result = await db.query(Strings.bookTable,
          orderBy: 'lower(${Strings.columnTitle}) ASC', where: whereQuery);
    } else {
      result = await db.query(Strings.bookTable,
          orderBy: 'lower(${Strings.columnTitle}) ASC',
          where: whereQuery,
          whereArgs: whereArg);
    }

    List<Book> books = List.generate(result.length, (i) {
      return Book.fromMap(result[i]);
    });

    return books;
  }
}
