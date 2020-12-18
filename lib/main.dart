import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recharge_now/app/home_screen.dart';
import 'package:recharge_now/auth/login_screen.dart';
import 'package:recharge_now/auth/splash_screen.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLanguage.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  AppLanguage appLanguage = AppLanguage();
  appLanguage.fetchLocale();
  await runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  AppLanguage appLanguage;

  MyApp({this.appLanguage});

  ThemeData appTheme = new ThemeData(
    hintColor: Colors.white,
    accentColor: primaryGreenColor,
  );

  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => LoginScreen(),
    "/HomePage": (BuildContext context) => new HomeScreen(),
    //  "/SignUpScreen": (BuildContext context) => new SignUpScreen(),
    "/SplashScreen": (BuildContext context) => new SplashScreen(),
    "/LoginScreen": (BuildContext context) => new LoginScreen(),
    // "/PaymentScreen": (BuildContext context) => new PaymentScreen(),
    // "/PromotionScreen": (BuildContext context) => new PromotionScreen(),
    //"/Credit": (BuildContext context) => new CreditScreen(),
    //"/PaymentMethodScreen": (BuildContext context) => new PaymentMethodScreen(),
    //"/PaymentMethodScreen": (BuildContext context) => new PaymentMethodScreen(),
  };

  @override
  Widget build(BuildContext context) {
    var matApp = new ChangeNotifierProvider<AppLanguage>(
      create: (context) => appLanguage,
      child: Consumer<AppLanguage>(
        builder: (context, model, child) {
          return MaterialApp(
            title: AllString.app_name,
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            theme: appTheme,
            routes: routes,
            //debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            locale: model.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('de', 'DE'),
            ],
          );
        },
      ),
    );
    return matApp;
  }


}



