import 'package:local_database/model/Post_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('posts.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY,
        title TEXT,
        body TEXT
      )
    ''');
  }

  /// Insert Post into Database
  Future<int> insertPost(PostModel post) async {
    final db = await database;
    return await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetch Posts from Database
  Future<List<PostModel>> getPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posts');
    return maps.map((map) => PostModel.fromMap(map)).toList();
  }

  /// Clear Posts from Database
  Future<void> clearPosts() async {
    final db = await database;
    await db.delete('posts');
  }
}
