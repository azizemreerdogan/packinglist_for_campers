import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:packinglist_for_campers/providers/packing_list_provider.dart';
import 'package:packinglist_for_campers/services/locations_api.dart';
import 'package:packinglist_for_campers/utils/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

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
                            List<Map<String, dynamic>> fetchedLocations = await LocationsApi.fetchLocations(value);
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
                            id: 0,
                            destination: widget.destination.text,
                            listName: widget.listName.text,
                            startDate: startDate,
                            finishDate: finishDate,
                          );

                          try {
                            await packingListProvider.addToList(newPackingList);
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