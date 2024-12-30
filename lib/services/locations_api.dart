import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationsApi {
  static Future<List<Map<String, dynamic>>> fetchLocations(String cityName) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    const apiLimit = 5;
    final url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=$apiLimit&appid=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        debugPrint("API request sent");
        debugPrint(response.body);

        // Transform data to a list of maps with relevant fields
        return data.map((location) {
          return {
            'name': location['name'] ?? '',
            'lat': location['lat'] ?? 0.0,
            'lon': location['lon'] ?? 0.0,
            'country': location['country'] ?? '',
            'state': location['state'] ?? '',
          };
        }).toList();
      } else {
        debugPrint("locations api error");
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching locations: $e');
    }

    // Default fallback
    return [];
  }
}