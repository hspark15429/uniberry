

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'note_model.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDb();
    return _database!;
  }

  Future<Database> openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notesapp.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          creationDate TEXT,
          pinned INTEGER,
          color TEXT
        )
      ''');
    });
  }

  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return NoteModel.fromMap(maps[i]);
    });
  }
}
