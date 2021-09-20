import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final bookTable = 'book';

class DatabaseProvider {
  DatabaseProvider._(); // constructeur privé

  static final DatabaseProvider dbProvider = DatabaseProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "bookMemo.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $bookTable ("
        "bookType INTEGER, "
        "title TEXT PRIMARY KEY, "
        "author TEXT, "
        "year INTEGER, "
        "isBought INTEGER, "
        "isFinished INTEGER, "
        "isFavorite INTEGER, "
        "volume INTEGER, "
        "chapter INTEGER, "
        "episode INTEGER, "
        "description TEXT "
        ")");
  }
}
