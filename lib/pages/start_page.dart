import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:packinglist_for_campers/pages/list_page_view.dart';
import 'package:packinglist_for_campers/providers/packing_items_provider.dart';
import 'package:packinglist_for_campers/providers/packing_list_provider.dart';
import 'package:packinglist_for_campers/providers/themes_provider.dart';
import 'package:packinglist_for_campers/services/locations_api.dart';
import 'package:packinglist_for_campers/utils/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:packinglist_for_campers/components/newDrawer.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<PackingList> packingLists = [];
  bool isSwitched = false;
  final TextEditingController destination = TextEditingController();
  final TextEditingController listName = TextEditingController();
  DateTime? startDate;
  DateTime? finishDate;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    destination.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      final packingListProvider =
          Provider.of<PackingListProvider>(context, listen: false);
      await packingListProvider.fetchPackingLists();
    } catch (e) {
      debugPrint('Error initializing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();
    final themesProvider = Provider.of<ThemesProvider>(context, listen: false);
    final packingListProvider =
        Provider.of<PackingListProvider>(context, listen: false);

    packingLists = packingListProvider.packingLists;
    Map<String, dynamic> destinationMap = {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('PackingList'),
        centerTitle: true,
        actions: [
          AddDestinationButton(destination: destination, listName: listName),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              icon: const Icon(Icons.settings),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      drawer: newDrawer(
      themesProvider: themesProvider,
      isSwitched: isSwitched,
      onThemeToggle: (value) {
        themesProvider.toggleTheme();
        setState(() {
          isSwitched  = true;
        });
      },
      ),
      body:
        
       ListViewConsumer(destinationMap),
    );
  }

  
  Consumer<PackingListProvider> ListViewConsumer(Map<String, dynamic> destinationMap) {
    return Consumer<PackingListProvider>(
      builder: (context, packingListProvider, child) {
        final packingLists = packingListProvider.packingLists;

        if (packingLists.isEmpty) {
          return const Center(
            child: Text(
              'No packing lists found.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: packingLists.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final PackingList packingList = packingLists[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                title: Text(
                  packingList.listName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  packingList.destination,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    PackingItemsProvider packingItemsProvider = Provider.of<PackingItemsProvider>(context, listen: false);
                    await packingListProvider.deletePackingListAndItems(packingList.id!);
                    
                    
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deleted: ${packingList.listName}'),
                      ),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ListPageView(packingList: packingList, destinationMap: packingListProvider.locationMap,)
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped: "${packingList.listName}" for ${packingList.destination}'),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AddDestinationButton extends StatefulWidget {
  const AddDestinationButton({
    super.key,
    required this.destination,
    required this.listName,
    
  });

  final TextEditingController destination;
  final TextEditingController listName;
  

  @override
  State<AddDestinationButton> createState() => _AddDestinationButtonState();
}

class _AddDestinationButtonState extends State<AddDestinationButton> {
  final dbHelper = DatabaseHelper();
  DateTime startDate = DateTime.now();
  DateTime finishDate = DateTime.now();
  Map<String, dynamic>? destinationMap;
  List<Map<String, dynamic>> locations = [];
  
 

  @override
  Widget build(BuildContext context) {
    final packingListProvider =
        Provider.of<PackingListProvider>(context, listen: false);

   return IconButton(
  icon: const Icon(Icons.add),
  onPressed: () {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust padding for keyboard
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Destination',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: widget.destination,
                        decoration: const InputDecoration(
                          labelText: 'Enter your destination',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            List<Map<String, dynamic>> fetchedLocations = await fetchLocations(value);
                            if (mounted) {
                              setState(() {
                                locations = fetchedLocations;
                              });
                            }
                          } else {
                            if (mounted) {
                              setState(() {
                                locations = [];
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      if (locations.isNotEmpty)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: locations.length,
                            itemBuilder: (context, index) {
                              final location = locations[index];
                              final name = location['name'] ?? 'Unknown Location';
                              final country = location['country'] ?? 'Unknown Country';
                              final state = location['state'] ?? 'Unknown State';
                              debugPrint("My state is $state");

                              return ListTile(
                                title: Text(state != '' ? '$name, $state, $country' : '$name,$country'),
                                onTap: () {
                                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                                  packingListProvider.insertLocationMap(location);

                                  setState(() {
                                    widget.destination.text = state != '' ? '$name, $state, $country' : '$name,$country';
                                    destinationMap = location;
                                    locations = [];
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Tapped: $name')),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 10),
                      const Text(
                        'List Name',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: widget.listName,
                        decoration: const InputDecoration(
                          labelText: 'Enter your list name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedStartDate = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedStartDate != null) {
                            setState(() {
                              startDate = pickedStartDate;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: startDate.toLocal().toString().split(' ')[0],
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedFinishDate = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: startDate,
                            lastDate: DateTime(2101),
                          );
                          if (pickedFinishDate != null) {
                            setState(() {
                              finishDate = pickedFinishDate;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: finishDate.toLocal().toString().split(' ')[0],
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.destination.text.isEmpty || widget.listName.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all the fields")),
                            );
                            return;
                          }

                          final newPackingList = PackingList(
                            id: null,
                            destination: widget.destination.text,
                            listName: widget.listName.text,
                            startDate: startDate,
                            finishDate: finishDate,
                          );

                          try {
                            await packingListProvider.addToList(newPackingList);
                            for (var element in packingListProvider.packingLists) {
                              debugPrint(element.id.toString());
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Added: ${widget.destination.text}")),
                            );
                            widget.destination.clear();
                            widget.listName.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error $e")),
                            );
                          }
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Color.fromARGB(255, 135, 22, 14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  },
);

  }
}
