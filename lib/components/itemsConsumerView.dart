import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/providers/packing_items_provider.dart';
import 'package:provider/provider.dart';


class Itemsconsumerview {
  
  final int packingListId;
  Itemsconsumerview({required this.packingListId });
  
  Consumer<PackingItemsProvider> itemsConsumerView() {
    return Consumer<PackingItemsProvider>(
              builder: (context, packingItemProvider, child) {
                final packingItems = packingItemProvider.packingItems;
                
                return ListView.builder(
                shrinkWrap: true, // Ensures the ListView doesn't take infinite height
                //physics: const NeverScrollableScrollPhysics(), // Prevents scrolling when nested
                itemCount: packingItems.length, // Total number of items in the checklist
                itemBuilder: (context, index) {
                  final item = packingItems[index]; // Access the current item
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0), // Adds space between cards
                    elevation: 2, // Subtle shadow for better appearance
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      leading: Checkbox(
                        value: item.isPacked, // Current state of the checkbox
                        onChanged: (value) async{
                          item.isPacked = value ?? false;
                          await packingItemProvider.updatePackingItem(item);
                          await packingItemProvider.fetchPackingItems(packingListId);
                        },
                      ),
                      title: Text(
                        item.name, // Name of the packing item
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: item.isPacked ? TextDecoration.lineThrough : TextDecoration.none,
                          color: item.isPacked ? Colors.grey : Colors.red,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async{
                          await packingItemProvider.deletePackingItem(packingListId, item);

                          
                        },
                      ),
                    ),
                  );
                },
              );
              },
              
            );
  }
}
