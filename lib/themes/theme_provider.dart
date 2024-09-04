

import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData=lightmode;
  ThemeData get themeData=>_themeData;
  bool get isDarkmode=>_themeData==darkmode;
  void set themeData(ThemeData themeData){
    _themeData=themeData;
    notifyListeners();
  }
  void toggleTheme(){
    if(_themeData==lightmode){
      themeData=darkmode;
    }
    else{
      themeData=lightmode;
    }
  }

}