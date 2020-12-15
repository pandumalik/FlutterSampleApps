import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/Grocery.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String PRICE = 'price';
  static const String QUANTITY = 'quantity';
  static const String TABLE = 'Grocery';
  static const String DB_NAME = 'grocery1.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $PRICE INTEGER, $QUANTITY INTEGER)");
  }

  Future<Grocery> save(Grocery groceries) async {
    var dbClient = await db;
    groceries.id = await dbClient.insert(TABLE, groceries.toMap());
    return groceries;
  }

  Future<List<Grocery>> getGroceries() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, PRICE, QUANTITY]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Grocery> groceries = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        groceries.add(Grocery.fromMap(maps[i]));
      }
    }
    return groceries;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Grocery groceries) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, groceries.toMap(),
        where: '$ID = ?', whereArgs: [groceries.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
