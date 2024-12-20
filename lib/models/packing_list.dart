class PackingList {
  final int _id;
  String _destination;
  String _listName;
  final DateTime? _startDate;
  final DateTime? _finishDate;

  // Constructor
  PackingList(this._id, this._destination, this._listName,this._startDate,this._finishDate);

  // Getters
  int get id => _id;
  String get destination => _destination;
  String get listName => _listName;
  DateTime? get startDate => _startDate;
  DateTime? get finishDate => _finishDate;
  

  // Setters
  set destination(String newDestination) {
    _destination = newDestination;
  }

  set listName(String newListName) {
    _listName = newListName;
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