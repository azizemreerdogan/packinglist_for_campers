import 'package:flutter/material.dart';
import 'package:packinglist_for_campers/themes/dark_mode.dart';
import 'package:packinglist_for_campers/themes/light_mode.dart';

class ThemesProvider extends ChangeNotifier{
  ThemeData _themeData = ligthMode;
  
  
  ThemeData get themeData => _themeData;
  
  
  bool get isDarkMode => _themeData ==  darkMode;
  
  
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }
  
  void toggleTheme(){
    if(_themeData == ligthMode){
      themeData = darkMode;
    }else{
      themeData = ligthMode;
    }
    
  }
  
  
}