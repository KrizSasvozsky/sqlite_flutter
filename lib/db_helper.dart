import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'sinhvien.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'SinhVien';
  static const String DB_NAME = 'sinhvien.db';

  Future<Database> get db async {
    if (_db != null) return _db;
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
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT)");
  }

  Future<List<SinhVien>> getSinhVien() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    List<SinhVien> sinhviens = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        sinhviens.add(SinhVien.fromMap(maps[i]));
      }
    }
    return sinhviens;
  }

  Future<SinhVien> save(SinhVien sinhVien) async {
    var dbClient = await db;
    sinhVien.id = await dbClient.insert(TABLE, sinhVien.toMap());
    return sinhVien;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(SinhVien sinhVien) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, sinhVien.toMap(),
        where: '$ID = ?', whereArgs: [sinhVien.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
