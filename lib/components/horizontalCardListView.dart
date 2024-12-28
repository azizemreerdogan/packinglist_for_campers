import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:packinglist_for_campers/models/weather.dart';

class HorizontalCardListView extends StatelessWidget {
  final List<Weather> items;

  const HorizontalCardListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      height: 100, // Increased height to accommodate content
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        itemBuilder: (context, index) {
          final weather = items[index];
          final date = DateFormat('EEE').format(weather.weatherDate);
          final minTemperature = '${(double.parse(weather.temperatureMin) - 273.15).toStringAsFixed(0)}°C';
          final maxTemperature = '${(double.parse(weather.temperatureMax) - 273.15).toStringAsFixed(0)}°C';
          final temperatures = '$minTemperature / $maxTemperature';

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6), // Reduced vertical padding
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Add this to make column wrap content
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getWeatherIcon(weather.mainWeather),
                      size: 24,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 2), // Reduced spacing
                    Text(
                      (temperatures),
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 2), // Reduced spacing
                    Text(
                      date,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;  // umbrella icon
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.cloud_queue;
      default:
        return Icons.question_mark;
    }
  }
}
