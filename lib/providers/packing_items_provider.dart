import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_item.dart';
import 'package:packinglist_for_campers/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class PackingItemsProvider extends ChangeNotifier{
  final dbHelper = DatabaseHelper();
  final List<PackingItem> _packingItems = [];
  List<PackingItem> get packingItems => _packingItems;
  
  Future<void> fetchPackingItems(int listId) async{
    _packingItems.clear();
    _packingItems.addAll(await dbHelper.getPackingItems(listId));
    notifyListeners();
    debugPrint("Items fetched");
  }
  
  Future<void> addToItemsList(PackingItem packingItem, int listId) async{
    _packingItems.add(packingItem);
    await dbHelper.insertPackingItem(packingItem, listId);
    fetchPackingItems(listId);
    notifyListeners();
  }
  
  Future<PackingItem?> fetchPackingItemById(int listId, PackingItem packingItem) async{
    PackingItem? packingItem1 = await dbHelper.getPackingItemById(listId);
    return packingItem1;
  }
  
  Future<void> updatePackingItem(PackingItem packingItem) async{
    dbHelper.updatePackingItem(packingItem);
  }
  
  Future<void> deletePackingItem(int listId, PackingItem packingItem) async{
    _packingItems.removeWhere((e) => e.id == packingItem.id);
    await dbHelper.deletePackingItem(packingItem,listId);
    notifyListeners();
  } 
  
  Future<void> clearPackingItems(int listId) async{
    _packingItems.clear();
    await dbHelper.clearAllPackingItemsForList(listId);
    notifyListeners();
  }
  
}