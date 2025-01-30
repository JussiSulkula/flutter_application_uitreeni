//Database functions

import 'package:flutter_application_uitreeni/data/todo_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static const _databaseName = "todo_database.db";
  static const _databaseVersion = 1;

  static const table = "todos";

  static const columnId = "id";
  static const columnTitle = "title";
  static const columnDescription = "description";
  static const columnDeadline = "deadline";
  static const columnDone = "done";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static DatabaseHelper get instance => _instance;
  late Database _db;

  Future<void> init() async{
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    //deleteDatabase(path);
    _db = await openDatabase(path,
     version: _databaseVersion, onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT,
        $columnDeadline INTEGER NOT NULL,
        $columnDone INTEGER NOT NULL)''');
  }

  Future<int> insert(TodoItem item) async {
    return await _db.insert(table, item.toMap());
  }
  Future<int> delete(TodoItem item) async {
    return await _db.delete(table, where: '$columnId = ?', whereArgs: [item.id]);
  }
  Future<int> update(TodoItem item) async {
    return await _db.update(
      table,
      item.toMap(),
      where: '$columnId = ?',whereArgs: [item.id]
    );
  }
  Future<List<TodoItem>> queryAllRows() async{
    final List<Map<String, dynamic>> maps = await _db.query(table);
    return List.generate(maps.length, (index){
      return TodoItem(
        id: maps[index]['id'],
        title: maps[index]['title'],
        description: maps[index]['description'],
        deadline: DateTime.fromMillisecondsSinceEpoch(maps[index]['deadline']),
        done: maps[index]['done'] == 1,
      );
    });
  }

}