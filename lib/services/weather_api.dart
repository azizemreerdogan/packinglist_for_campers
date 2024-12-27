import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchWeather(String lat,String lon) async {
  final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
  final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String,dynamic> data = json.decode(response.body);
      final List<dynamic> forecastList = data['list'];
      debugPrint("API request sent");
      debugPrint(response.body);

      // Transform data to a list of maps with relevant fields
      return forecastList.map((e) {
        // Accessing the first element of the 'weather' list
        final weather = e['weather'] != null && e['weather'].isNotEmpty
            ? e['weather'][0] 
            : {};
        
        return {
          'main': weather['main'] ?? '',  
          'description': weather['description'] ?? '', 
          'temp_min' : e['main']['temp_min'] ?? 0.0, 
          'temp_max' : e['main']['temp_max'] ?? 0.0,
          'dt_txt': e['dt_txt'] ?? '',  
        };
      }).toList();
    } else {
      debugPrint("weather api error");
      debugPrint('Error: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error fetching es: $e');
  }

  // Default fallback
  return [];
}
