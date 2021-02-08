import 'dart:ui' as ui;

import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AppLanguage extends ChangeNotifier {
  Locale setappLocale = Locale('en');

  void setAppLocal(String name) {
    setappLocale = Locale(name);
  }

  Locale get appLocal => setappLocale;

  // fetchLocale() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   var localValue = prefs.getString('language_code');
  //   if (localValue == null) {
  //     setappLocale = Locale('en');
  //   } else if (localValue == 'de') {
  //     setappLocale = Locale('de');
  //   } else {
  //     setappLocale = Locale('en');
  //   }
  // }

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    var localValue = prefs.getString('language_code');
    var localeName = '';
    if (localValue == null || localValue == '') {
      try {
        List languages = await Devicelocale.preferredLanguages;
        if (languages.length > 0) {
          if (languages[0].contains("de")) {
            // _appLanguage.changeLanguage(Locale('de'));
            await prefs.setString('language_code', 'de');
          } else {
            // _appLanguage.changeLanguage(Locale('en'));
            await prefs.setString('language_code', 'en');
          }
        } else {
          // _appLanguage.changeLanguage(Locale('en'));
          await prefs.setString('language_code', 'en');
        }
        debugPrint("language_code_is 1    ${prefs.getString('language_code')}");

      } on PlatformException {
        print("Error obtaining current locale");
        await prefs.setString('language_code', 'en');
      }
    }
    setappLocale = Locale(prefs.getString('language_code'));
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
    this.notifyListeners();
  }

  void changeLanguageFirstTime(context, Locale type) async {
    print("typetype${type.languageCode}");
    var prefs = await SharedPreferences.getInstance();
    if (setappLocale == type || type == null) {
      return;
    }
    setappLocale = type;
    prefs.setString('language_code', type.languageCode);
    this.notifyListeners();
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
