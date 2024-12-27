import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/models/packing_item.dart';
import 'package:packinglist_for_campers/models/packing_list.dart';
import 'package:packinglist_for_campers/providers/packing_items_provider.dart';
import 'package:packinglist_for_campers/utils/database_helper.dart';
import 'package:provider/provider.dart';

class Additemsmodal extends StatefulWidget {
  const Additemsmodal({super.key,required this.packingList});
  
  final PackingList packingList;

  @override
  State<Additemsmodal> createState() => _AdditemsmodalState();
}

class _AdditemsmodalState extends State<Additemsmodal> {
  
  
  final TextEditingController itemNameController = TextEditingController();
  final dbHelper = DatabaseHelper();

  
  @override
  Widget build(BuildContext context) {
      PackingItemsProvider packingItemsProvider = Provider.of<PackingItemsProvider>(context,listen: false);
    
    return  ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
            
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Items',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: itemNameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async{
                        PackingItem packingItem = PackingItem(id: null, name: itemNameController.text, isPacked: false);
                        await packingItemsProvider.addToItemsList(packingItem, widget.packingList.id!);
                        //await packingItemsProvider.fetchPackingItems(widget.packingList.id);
                        
                        debugPrint("addToItems called");
                        for (var element in packingItemsProvider.packingItems) {
                          debugPrint(element.name);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Item added: ${packingItem.name}')),
                        );
                        Navigator.pop(context); // Close the modal
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text('Add Items'),
    );
  }
}
