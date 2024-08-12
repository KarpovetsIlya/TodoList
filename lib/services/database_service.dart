import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/task.dart';

const String fileName = 'todolist.db';

class DatabaseService {
  DatabaseService._init();

  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $titleColumn TEXT NOT NULL,
        $importanceColumn TEXT NOT NULL,
        $deadlineColumn TEXT NOT NULL,
        $isDoneColumn INTEGER NOT NULL
      )
    ''');
  }

  Future<Database> _initializeDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;

    final id = await db.insert(
      tableName,
      {
        'title': task.title,
        'importance': task.importance,
        'deadline': task.deadline.toIso8601String(),
        'isDone': task.isDone ? 1 : 0
      },
    );

    return task.copyWith(id: id);
  }

  Future<List<Task>> readTasks() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
