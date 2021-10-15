import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../strings.dart';

class DatabaseProvider {
  DatabaseProvider._(); // constructeur privé

  static final DatabaseProvider dbProvider = DatabaseProvider._();
  static Database? _database;
  static final _databaseName = "bookMemo.db";
  static final _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    var database = await openDatabase(path,
        version: _databaseVersion, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE ${Strings.bookTable} ("
        "${Strings.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, "
        "${Strings.columnBookType} INTEGER, "
        "${Strings.columnTitle} TEXT UNIQUE, "
        "${Strings.columnAuthor} TEXT, "
        "${Strings.columnYear} INTEGER, "
        "${Strings.columnIsBought} INTEGER, "
        "${Strings.columnIsFinished} INTEGER, "
        "${Strings.columnIsFavorite} INTEGER, "
        "${Strings.columnVolume} INTEGER, "
        "${Strings.columnChapter} INTEGER, "
        "${Strings.columnEpisode} INTEGER, "
        "${Strings.columnDescription} TEXT, "
        "${Strings.columnImagePath} TEXT "
        ")");
  }
}
