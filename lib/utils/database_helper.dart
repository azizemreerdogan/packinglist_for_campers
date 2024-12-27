import 'dart:async';
import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_item.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // Table and column names for PackingList
  final String tablePackingList = 'packing_list';
  final String colListId = 'id';
  final String colDestination = 'destination';
  final String colListName = 'listName';
  final String colStartDate = 'startDate';
  final String colFinishDate = 'finishDate';


  //Table and column names for PackingItem
  final String tablePackingItem = 'packing_item';
  final String colItemId = 'id';
  final String colItemName = 'name';
  final String colIsPacked = 'isPacked';
  final String colListForeignKey = 'listId';
  
  //final String 
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
        $colListId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colDestination TEXT, 
        $colListName TEXT, 
        $colStartDate TEXT, 
        $colFinishDate TEXT
      )
      ''',
    );
    
    await db.execute(
      '''
      CREATE TABLE $tablePackingItem(
        $colItemId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colItemName TEXT,
        $colIsPacked INTEGER,
        $colListForeignKey INTEGER,
        FOREIGN KEY($colListForeignKey) REFERENCES $tablePackingList($colListId) 
      )

      '''
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
      where: '$colListId = ?',
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
      where: '$colListId = ?',
      whereArgs: [packingList.id],
    );
  }

  // Delete a PackingList
  Future<int> deletePackingList(int id) async {
    final db = await database;
    return await db.delete(
      tablePackingList,
      where: '$colListId = ?',
      whereArgs: [id],
    );
  }
  
    // Clear all packing lists
  Future<int> clearAllPackingLists() async {
    final db = await database;
    return await db.delete(tablePackingList);
  }
  
  //CRUD Operations for packingItem
  
  //insertion
  Future<int> insertPackingItem(PackingItem packingItem, int listId) async {
    try {
      final db = await database;
      return await db.insert(
        tablePackingItem,
        {
          ...packingItem.toMap(),
          colListForeignKey: listId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e, stacktrace) {
      debugPrint('Error inserting packing item: $e');
      debugPrint('Stacktrace: $stacktrace');
      return -1; // Return a failure indicator (could be any appropriate value)
    }
  }


  
  //Get List that includes packing items 
  Future<List<PackingItem>> getPackingItems(int listId) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query(
      tablePackingItem,
      where: '$colListForeignKey = ?',
      whereArgs: [listId],
    );
    // Check if the query result is empty
  if (maps.isEmpty) {
    return []; // Return an empty list if no items are found
  }
    
    return List.generate(maps.length, (i) {
      return PackingItem.fromMapObject(maps[i]);
    });
  }
  
  Future<PackingItem?> getPackingItemById(int listId) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query(
      tablePackingItem,
      where: '$colListForeignKey = ?',
      whereArgs: [listId]
      );
    if(maps.isNotEmpty){
      return PackingItem.fromMapObject(maps.first);
    }else{
      return null;
    }
    
  }
  
  //
  Future<int> updatePackingItem(PackingItem packingItem) async {
    final db = await database;
    return await db.update(
      tablePackingItem,
      packingItem.toMap(),
      where: '$colItemId = ?',
      whereArgs: [packingItem.id],
    );
  }
  
  Future<int> deletePackingItem(PackingItem packingItem,int listId) async{
    final db = await database;
    return await db.delete(
      tablePackingItem,
      where: '$colListForeignKey = ? AND $colItemId = ?',
      whereArgs:  [listId,packingItem.id]
    );
  }
  
  Future<int> clearAllPackingItemsForList(int listId) async{
    final db = await database;
    return await db.delete(
      tablePackingItem,
      where: '$colListForeignKey = ?',
      whereArgs: [listId]
    );
  }
  
  Future<void> deletePackingListAndItems(int listId) async {
  final db = await database;
  await db.transaction((txn) async {
    // Delete all packing items for this list
    await txn.delete(
      tablePackingItem,
      where: '$colListForeignKey = ?',
      whereArgs: [listId],
    );

    // Delete the packing list itself
    await txn.delete(
      tablePackingList,
      where: '$colListId = ?',
      whereArgs: [listId],
    );
  });
}
  

}
