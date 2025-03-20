// db_helper.dart
import 'package:flutter_project_iti/models/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(Recipe recipe) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'id': recipe.id,
        'name': recipe.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<List<Recipe>> getAllFavorites() async {
    final db = await database;
    final result = await db.query('favorites');
    return result.map((row) {
      return Recipe(
        id: row['id'] as int,
        name: row['name'] as String,
        ingredients: [],
        instructions: [],
        prepTimeMinutes: 0,
        cookTimeMinutes: 0,
        servings: 0,
        difficulty: '',
        cuisine: '',
        caloriesPerServing: 0,
        tags: [],
        userId: 0,
        image: '',
        rating: 0,
        reviewCount: 0,
        mealType: [],
      );
    }).toList();
  }
}
