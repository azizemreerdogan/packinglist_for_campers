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
      height: 90, // Reduced height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        itemBuilder: (context, index) {
          final weather = items[index];
          final date = DateFormat('EEE').format(weather.weatherDate); // Short day of the week
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
                width: 100, // Reduced card width
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Pale gray background
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300, // Subtle border
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weather.mainWeather, // Main weather (e.g., "Cloudy")
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      (temperatures), // Temperature
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date, // Short day of the week (e.g., "Mon")
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
}
