import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/components/littleContainer.dart';
import 'package:packinglist_for_campers/models/packing_item.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:packinglist_for_campers/providers/packing_items_provider.dart';
import 'package:packinglist_for_campers/services/locations_api.dart';
import 'package:packinglist_for_campers/services/weather_api.dart';
import 'package:packinglist_for_campers/utils/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class ListPageView extends StatefulWidget {
  final PackingList packingList;
  final Map<String,dynamic> destinationMap;
  final String destinationName;

  const ListPageView({super.key, required this.packingList, required this.destinationMap,
  required this.destinationName});

  @override
  State<ListPageView> createState() => _ListPageViewState();
}

class _ListPageViewState extends State<ListPageView> {
  

  List<dynamic> fetchedWeatherList = [];
  Map<String,dynamic> destinationMap = {};
  
  
  Future<void> _initializeData() async{
    final packingItemProvider = Provider.of<PackingItemsProvider>(context,listen: false);
    await packingItemProvider.fetchPackingItems(widget.packingList.id);
    List<Map<String, dynamic>> fetchedLocations = await fetchLocations(widget.packingList.destination);
    Map<String,dynamic> destinationMap = fetchedLocations.first;
    String lat = destinationMap['lat'].toString();
    String lon = destinationMap['lon'].toString();
    List<dynamic> fetchedWeather = await fetchWeather(lat, lon);
    fetchedWeatherList = fetchedWeather;
  }
  
  int completedCounter(List<PackingItem?> packingItems) {
  return packingItems.where((item) => item?.isPacked ?? false).length;
  }
  
  @override
  void initState() {
    _initializeData();
    super.initState();
  }
  
  

  
  @override
  Widget build(BuildContext context) {
    
    _initializeData();
    final packingItemProvider = Provider.of<PackingItemsProvider>(context,listen: false);
    List<PackingItem?> packingItems = packingItemProvider.packingItems;
    
    
    return Scaffold(
      appBar: AppBar(
        actions: const [
          IconButton(
            onPressed: null, 
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Stack(
        children: [Padding(
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LittleContainer(widget: widget, textData: (widget.packingList.finishDate != null && widget.packingList.startDate != null)
              ? "${widget.packingList.finishDate!.difference(widget.packingList.startDate!).inDays} days"
              : "Invalid dates", ),
                  const SizedBox(width: 10),
                  LittleContainer(widget: widget,
                   textData: '${completedCounter(packingItems)} / ${packingItems.length} Packed'),
                  const SizedBox(width: 10),
                  Container(
                    height: 52,
                    width: 52,
                    padding: const EdgeInsets.all(0.3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface, // Border color based on theme
                        width: 2.0, // Border width
                      ),
                    ),
                    child: const IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: null,
                      icon: Icon(Icons.notifications_sharp,
                    ))
                  )
                ],
              ),
               //Text(destinationMap['name'])
            ],
          ),
        ),
      Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              onPressed: () {
                // Add logic to navigate or show a dialog for adding items
                debugPrint('Add item button clicked');
              },
              child:  const Icon(Icons.add, color: Colors.redAccent),
            ),
          ),
        ),
      ],
      
      ),
      
    );
  }
}


class HorizontalCardListView extends StatelessWidget {
  final List<String> items;

  const HorizontalCardListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Set height for the ListView
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Scroll horizontally
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16), // Spacing between cards
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 150, // Set width for each card
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade300,
                      Colors.blue.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    items[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
