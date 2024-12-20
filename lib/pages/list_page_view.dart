import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';

class ListPageView extends StatefulWidget {
  final PackingList packingList;

  const ListPageView({super.key, required this.packingList});

  @override
  State<ListPageView> createState() => _ListPageViewState();
}

class _ListPageViewState extends State<ListPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          IconButton(
            onPressed: null, 
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                widget.packingList.listName,
                style: const TextStyle(
                  fontSize: 30, // Adjust the font size as needed
                  fontWeight: FontWeight.bold, // Makes the text bold
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface, // Border color based on theme
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, // Focused border color based on theme
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                LittleContainer(widget: widget),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LittleContainer extends StatelessWidget {
  const LittleContainer({
    super.key,
    required this.widget,
  });

  final ListPageView widget;

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
        (widget.packingList.finishDate != null && widget.packingList.startDate != null)
            ? "${widget.packingList.finishDate!.difference(widget.packingList.startDate!).inDays} days"
            : "Invalid dates",
        style: TextStyle(
          fontSize: 16, // Text size
          fontWeight: FontWeight.bold, // Text bold
          color: Theme.of(context).colorScheme.onSurface, // Text color based on theme
        ),
      ),
    );
  }
}
