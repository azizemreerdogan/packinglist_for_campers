import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/pages/list_page_view.dart';

class LittleContainer extends StatelessWidget {
  const LittleContainer({
    super.key,
    required this.widget,
    required this.textData,
  });

  final ListPageView widget;
  final String textData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0), // Add padding inside the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface, // Border color based on theme
          width: 2.0, // Border width
        ),
      ),
      child: Text(
        textData,
        style: TextStyle(
          fontSize: 16, // Text size
          fontWeight: FontWeight.bold, // Text bold
          color: Theme.of(context).colorScheme.onSurface, // Text color based on theme
        ),
      ),
    );
  }
}
