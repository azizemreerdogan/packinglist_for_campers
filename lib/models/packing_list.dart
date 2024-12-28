import 'package:packinglist_for_campers/models/packing_item.dart';

class PackingList {
  int? _id;
  String _destination;
  String _listName;
  final DateTime? _startDate;
  final DateTime? _finishDate;
  List<PackingItem>? _packingItems;
  Map<String,dynamic>? _locationMap;
  

  // Constructor
  PackingList({int? id, required String destination,required String listName, DateTime? startDate,
  DateTime? finishDate, List<PackingItem>? packingItems, Map<String,dynamic>? locationMap})
    : _id = id,
      _destination = destination,
      _listName = listName,
      _startDate = startDate,
      _finishDate = finishDate,
      _packingItems = packingItems ?? [],
      _locationMap = locationMap ?? {};
      
  
  void addItems(PackingItem newItem){
    _packingItems!.add(newItem);
  }
  
  // Getters
  int? get id => _id;
  String get destination => _destination;
  String get listName => _listName;
  DateTime? get startDate => _startDate;
  DateTime? get finishDate => _finishDate;
  List<PackingItem>? get packingItems => _packingItems;
  Map<String,dynamic>? get locationMap => _locationMap;
  

  // Setters
  set destination(String newDestination) {
    _destination = newDestination;
  }

  set listName(String newListName) {
    _listName = newListName;
  }
  
  set id(int? newId){
    _id = newId;
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != 0) {
      map['id'] = _id;
    }
    map['destination'] = _destination;
    map['listName'] = _listName;
    map['startDate'] = _startDate?.toIso8601String();
    map['finishDate'] = _finishDate?.toIso8601String();

    return map;
  }

  // Named constructor to create an instance from a map
  PackingList.fromMapObject(Map<String, dynamic> map)
      : _id = map['id'],
        _destination = map['destination'] ?? '', // Provide a default value
        _listName = map['listName'] ?? '', // Provide a default value
        _startDate = map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
        _finishDate = map['finishDate'] != null ? DateTime.parse(map['finishDate']) : null;
}