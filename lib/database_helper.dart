import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "CounterDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'usage_table';
  static final columnId = 'id';
  static final columnCount = 'count';
  static final columnDateTime = 'dateTime';
  static final columnPlace = 'place';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        ''' CREATE TABLE $table ( $columnId INTEGER PRIMARY KEY, $columnCount INTEGER NOT NULL, $columnDateTime TEXT NOT NULL, $columnPlace TEXT NOT NULL ) ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryLatestCount() async {
    Database? db = await instance.database;
    return await db!.query(table, orderBy: '$columnId DESC', limit: 1);
  }
}
