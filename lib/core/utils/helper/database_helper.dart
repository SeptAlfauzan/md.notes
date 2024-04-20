import 'package:file_io_simple/core/domain/entities/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }
  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();
  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'notes';
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'note_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
                id TEXT PRIMARY KEY,
                data TEXT,
                description TEXT,
                created TEXT,
                lastEdited TEXT
             )''',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(_tableName, note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Note.fromMap(res)).toList();
  }

  Future<Note?> getNoteById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((res) => Note.fromMap(res)).firstOrNull;
  }

  Future<void> updateNote(Note note) async {
    final db = await database;

    await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
