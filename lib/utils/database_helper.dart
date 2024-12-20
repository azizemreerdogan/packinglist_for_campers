import 'dart:async';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // Table and column names
  final String tablePackingList = 'packing_list';
  final String colId = 'id';
  final String colDestination = 'destination';
  final String colListName = 'listName';
  final String colStartDate = 'startDate';
  final String colFinishDate = 'finishDate';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final String path = join(await getDatabasesPath(), 'packing_list.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  
  void _createDb(Database db, int newVersion) async {
    await db.execute(
      '''
      CREATE TABLE $tablePackingList(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colDestination TEXT, 
        $colListName TEXT, 
        $colStartDate TEXT, 
        $colFinishDate TEXT
      )
      ''',
    );
  }

  // CRUD Operations

  // Insert a PackingList
  Future<int> insertPackingList(PackingList packingList) async {
    final db = await database;
    return await db.insert(
      tablePackingList,
      packingList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get a PackingList by ID
  Future<PackingList?> getPackingList(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePackingList,
      where: '$colId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PackingList.fromMapObject(maps.first);
    }
    return null;
  }

  // Get all PackingLists
  Future<List<PackingList>> getPackingLists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tablePackingList);

    return List.generate(maps.length, (i) {
      return PackingList.fromMapObject(maps[i]);
    });
  }

  // Update a PackingList
  Future<int> updatePackingList(PackingList packingList) async {
    final db = await database;
    return await db.update(
      tablePackingList,
      packingList.toMap(),
      where: '$colId = ?',
      whereArgs: [packingList.id],
    );
  }

  // Delete a PackingList
  Future<int> deletePackingList(int id) async {
    final db = await database;
    return await db.delete(
      tablePackingList,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
  
    // Clear all packing lists
  Future<int> clearAllPackingLists() async {
    final db = await database;
    return await db.delete(tablePackingList);
  }

}
