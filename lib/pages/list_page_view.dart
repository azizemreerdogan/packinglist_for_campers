

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:packinglist_for_campers/components/horizontalCardListView.dart';
import 'package:packinglist_for_campers/components/littleContainer.dart';
import 'package:packinglist_for_campers/models/packing_item.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:packinglist_for_campers/models/weather.dart';
import 'package:packinglist_for_campers/providers/packing_items_provider.dart';
import 'package:packinglist_for_campers/services/locations_api.dart';
import 'package:packinglist_for_campers/services/weather_api.dart';

import 'package:provider/provider.dart';


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
  List<Weather> weatherObjectList = [];
  Map<String,dynamic> destinationMap = {};
  
  
  Future<void> _initializeData() async{
    final packingItemProvider = Provider.of<PackingItemsProvider>(context,listen: false);
    await packingItemProvider.fetchPackingItems(widget.packingList.id);
    List<Map<String, dynamic>> fetchedLocations = await fetchLocations(widget.packingList.destination);
    Map<String,dynamic> destinationMap = fetchedLocations.first;
    String lat = destinationMap['lat'].toString();
    String lon = destinationMap['lon'].toString();
    List<Map<String,dynamic>> fetchedWeather = await fetchWeather(lat, lon);
    fetchedWeatherList = fetchedWeather;
    List<Weather> weatherObjectList1 = [];
    for (var element in fetchedWeatherList) {
      weatherObjectList1.add(Weather.fromMapToObject(element)); 
    }
    setState(() {
      weatherObjectList = filterDailyWeather(weatherObjectList1);
    });
    

  }
  
  List<Weather> filterDailyWeather(List<Weather> weatherList) {
  final Map<String, Weather> uniqueDays = {};

  for (var weather in weatherList) {
    final dateKey = DateFormat('yyyy-MM-dd').format(weather.weatherDate);
    if (!uniqueDays.containsKey(dateKey)) {
      uniqueDays[dateKey] = weather;
    }
  }

   return uniqueDays.values.toList();
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
                      color: Colors.black54,
                      padding: EdgeInsets.zero,
                      onPressed: null,
                      icon: Icon(Icons.notifications_sharp,
                    ))
                  )
                ],
              ),
              const SizedBox(height: 15,),
              HorizontalCardListView(items: weatherObjectList)
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


