import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_item.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:packinglist_for_campers/providers/packing_items_provider.dart';
import 'package:packinglist_for_campers/utils/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class ListPageView extends StatefulWidget {
  final PackingList packingList;
  final Map<String,dynamic> destinationMap;

  const ListPageView({super.key, required this.packingList, required this.destinationMap});

  @override
  State<ListPageView> createState() => _ListPageViewState();
}

class _ListPageViewState extends State<ListPageView> {
  
  
  Future<void> _initializeData() async{
    final packingItemProvider = Provider.of<PackingItemsProvider>(context,listen: false);
    await packingItemProvider.fetchPackingItems(widget.packingList.id);
    
  }
  
  int completedCounter(List<PackingItem?> packingItems) {
  return packingItems.where((item) => item?.isPacked ?? false).length;
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
               Text(widget.destinationMap['name'])
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
                print('Add item button clicked');
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
