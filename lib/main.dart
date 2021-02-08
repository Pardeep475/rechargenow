import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:recharge_now/auth/login_screen.dart';
import 'package:recharge_now/auth/splash_screen.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLanguage.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/SizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/home_screen_new.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  debugPrint("notification_message_is    $message");
}

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  // debugPaintSizeEnabled = false;
  await runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatefulWidget {
  AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  State<StatefulWidget> createState() => _MyAppState(appLanguage: appLanguage);
}

class _MyAppState extends State<MyApp> {
  AppLanguage appLanguage;
  SharedPreferences _prefs;

  _MyAppState({this.appLanguage});

  ThemeData appTheme = new ThemeData(
    hintColor: Colors.white,
    accentColor: primaryGreenColor,
  );

  @override
  void initState() {
    super.initState();
    loadShredPref();
  }

  loadShredPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String languageCode = "";

  var routes = <String, WidgetBuilder>{
    "/Login": (BuildContext context) => LoginScreen(),
    "/HomePage": (BuildContext context) => new HomeScreenNew(),
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
          return LayoutBuilder(builder: (context, constraints) {
            return OrientationBuilder(builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                title: AllString.app_name,
                debugShowCheckedModeBanner: false,
                home: SplashScreen(languageCode: languageCode),
                theme: appTheme,
                routes: routes,
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
            });
          });
        },
      ),
    );
    return matApp;
  }

  localeResolutionCallback(Locale locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      debugPrint("*language locale is null!!!");
      return supportedLocales.first;
    }

    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode ||
          supportedLocale.countryCode == locale.countryCode) {
        debugPrint("*language ok $supportedLocale");
        return supportedLocale;
      }
    }

    debugPrint("*language to fallback ${supportedLocales.first}");
    return supportedLocales.first;
  }
}

var languagesItsms = [
  LanguageItem('English', true, "en"),
  LanguageItem('Deutsch', false, "de"),
];

class LanguageItem {
  String language_name;
  bool isSelected;
  var localeName;

  LanguageItem(this.language_name, this.isSelected, this.localeName);
}
