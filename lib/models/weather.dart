class Weather {
  final String _mainWeather;
  final String _weatherDescription;
  final String _tempratureMax;
  final String _temperatureMin;
  final DateTime _weatherDate;
  
  Weather({required mainWeather,required weatherDescription, required weatherDate,
   required temperatureMin, required temperatureMax})
    : _mainWeather = mainWeather,
      _weatherDescription = weatherDescription,
      _temperatureMin = temperatureMin,
      _tempratureMax = temperatureMax,
      _weatherDate = weatherDate;
      
      
  String get mainWeather => _mainWeather;
  String get weatherDescription => _weatherDescription;
  String get temperatureMin => _temperatureMin;
  String get temperatureMax => _tempratureMax;
  DateTime get weatherDate => _weatherDate;
  
  
  Weather.fromMapToObject(Map<String,dynamic> map)
  : _mainWeather = map['main'],
    _weatherDescription = map['description'],
    _temperatureMin = map['temp_min'].toString(),
    _tempratureMax = map['temp_max'].toString(),
    _weatherDate = DateTime.parse(map['dt_txt']);
    
  
}