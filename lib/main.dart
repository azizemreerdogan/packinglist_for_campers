import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/pages/start_page.dart';
import 'package:packinglist_for_campers/providers/packing_items_provider.dart';
import 'package:packinglist_for_campers/providers/packing_list_provider.dart';
import 'package:packinglist_for_campers/providers/themes_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  
  
  
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemesProvider()),
    ChangeNotifierProvider(create: (context) => PackingListProvider(),),
    ChangeNotifierProvider(create: (context) => PackingItemsProvider())
  ],
    
    child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemesProvider>(context).themeData,
      home: const StartPage(),
    );
  }
}
