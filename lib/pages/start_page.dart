import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:packinglist_for_campers/pages/list_page_view.dart';
import 'package:packinglist_for_campers/providers/packing_list_provider.dart';
import 'package:packinglist_for_campers/themes/themes_provider.dart';
import 'package:packinglist_for_campers/utils/database_helper.dart';
import 'package:provider/provider.dart';

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
      drawer: newDrawer(themesProvider),
      body: ListViewConsumer(),
    );
  }

  Drawer newDrawer(ThemesProvider themesProvider) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Text(
              'Let\'s go camping!',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isSwitched,
              onChanged: (value) {
                themesProvider.toggleTheme();
                setState(() {
                  isSwitched = value;
                });
              },
              activeColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Consumer<PackingListProvider> ListViewConsumer() {
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
                  packingList.destination,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  packingList.listName,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await packingListProvider.deletePackingList(packingList.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deleted: ${packingList.listName}'),
                      ),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListPageView(packingList: packingList,),));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tapped: "${packingList.listName}" for ${packingList.destination}',
                      ),
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
            return Container(
              padding: const EdgeInsets.all(16),
              height: 600,
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
                  // Start Date Input Field
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
                        decoration:  InputDecoration(
                          //labelText: 'Start Date',
                          hintText:startDate.toLocal().toString().split(' ')[0],
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Finish Date Input Field
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedFinishDate = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: startDate, // Ensure finish date can't be before start date
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
                          labelText: 'Finish Date',
                          hintText: finishDate == null
                              ? 'Select Finish Date'
                              : finishDate.toLocal().toString().split(' ')[0],
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // Adding the destination to db
                      if (widget.destination.text.isEmpty ||
                          widget.listName.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill all the fields")),
                        );
                        return;
                      }

                      final newPackingList = PackingList(
                        0,
                        widget.destination.text,
                        widget.listName.text,
                        startDate,
                        finishDate,
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
            );
          },
        );
      },
    );
  }
}
