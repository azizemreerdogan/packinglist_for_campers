import 'package:flutter/material.dart';

class PackingItem{
  int? id;
  String name;
  bool isPacked;
  
  PackingItem({required this.id, required this.name, required this.isPacked});
  
  //Convert to map
  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'isPacked' : isPacked ? 1 : 0
    };
  }
  
  //Map to a an intance using a named constructor
  PackingItem.fromMapObject(Map<String,dynamic> map)
    : id = map['id'],
      name = map['name'],
      isPacked = map['isPacked'] == 1;
      
  
    
}