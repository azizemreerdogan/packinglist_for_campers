import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchWeather(String lat,String lon) async {
  const apiKey = '*';
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
          'main_weather': weather['main'] ?? '',  
          'weather_desc': weather['description'] ?? '',  
          'date': e['dt_txt'] ?? '',  
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
