import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:packinglist_for_campers/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class PackingListProvider extends ChangeNotifier{

  final dbHelper = DatabaseHelper();
  final List<PackingList> _packingList = [];
  List<PackingList> get packingLists => _packingList;
  Map<String,dynamic> _locationMap = {};
  Map<String,dynamic> get locationMap => _locationMap;
  
  
  
  Future<void> fetchPackingLists() async{
    _packingList.clear();
    _packingList.addAll(await dbHelper.getPackingLists());
    notifyListeners();
    debugPrint("packing lists added");
  }
  
  Future<void> addToList(PackingList packingList) async{
      int changedId = await dbHelper.insertPackingList(packingList);
      packingList.id = changedId;
      _packingList.add(packingList);
      notifyListeners();
    }
  Future<PackingList?> fetchPackingListById(int id) async{
    PackingList? packingList1 = await dbHelper.getPackingList(id);
    return packingList1;
    
  }
  
  Future<void> updatePackingList(PackingList packingList) async{
    await dbHelper.updatePackingList(packingList);
    notifyListeners();
  }
  
  Future<void> deletePackingList(int id) async{
    await dbHelper.deletePackingList(id);
    _packingList.removeWhere((e) => e.id == id);
    notifyListeners();
  }
  
  Future<void> clearAllPackingLists() async{
    await dbHelper.clearAllPackingLists();
    _packingList.clear();
    notifyListeners();
  }
  
  Future<void> insertLocationMap(Map<String,dynamic> locationMap) async{
    _locationMap = locationMap;
    notifyListeners();
  }
  
  
  
}