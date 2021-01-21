import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale setappLocale = Locale('en');

  void setAppLocal(String name) {
    setappLocale = Locale(name);
  }

  Locale get appLocal => setappLocale;

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    var localValue = prefs.getString('language_code');
    if (localValue != null && localValue != '') {
      setappLocale = Locale(localValue);
    } else {
      setappLocale = Locale('en');
    }
    return Null;
  }



  void changeLanguage(Locale type) async {
    print("typetype${type.languageCode}");
    var prefs = await SharedPreferences.getInstance();
    if (setappLocale == type || type == null) {
      return;
    }
    setappLocale = type;
    prefs.setString('language_code', type.languageCode);
    notifyListeners();
  }

  void changeLanguageFirstTime(context,Locale type) async {
    print("typetype${type.languageCode}");
    var prefs = await SharedPreferences.getInstance();
    if (setappLocale == type || type == null) {
      return;
    }
    setappLocale = type;
    prefs.setString('language_code', type.languageCode);
    notifyListeners();
  }

  Future<String> getLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString('language_code');
    if (lang == null) {
      return "en";
    } else {
      return prefs.getString('language_code');
    }
  }
}
