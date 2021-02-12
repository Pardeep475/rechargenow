import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recharge_now/auth/intro_screen.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  final String languageCode;

  SplashScreen({this.languageCode});

  @override
  _SplashScreenState createState() =>
      new _SplashScreenState(languageCode: languageCode);
}

class _SplashScreenState extends State<SplashScreen> {
  var location = Location();
  SharedPreferences prefs;

  final String languageCode;

  _SplashScreenState({this.languageCode});

  void navigationHomePage() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  @override
  void initState() {
    super.initState();
    loadShredPref();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 800)).then((value) async {
      if (prefs.get("isSkip") != null) {
        if (prefs.getBool('is_login') != null &&
            prefs.getBool('is_login') == true) {
          Navigator.of(context).pushReplacementNamed('/HomePage');
        } else {
          Navigator.of(context).pushReplacementNamed('/LoginScreen');
        }
      } else {
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
            builder: (BuildContext context) => HowToWorkScreen(
              isFromHome: false,
            ),
          ),
        );
      }
    });
  }

  // checkLocationServiceEnableOrDisable() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   print("serviceEnabled" + _serviceEnabled.toString());
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (Platform.isIOS) {
  //       // startTime();
  //     } else if (Platform.isAndroid) {
  //       if (!_serviceEnabled) {
  //         //checkLocationServiceEnableOrDisable();
  //         MyConstants.currentLat = prefs.getDouble("lat") != null
  //             ? prefs.getDouble("lat")
  //             : MyConstants.currentLat;
  //         MyConstants.currentLong = prefs.getDouble("long") != null
  //             ? prefs.getDouble("long")
  //             : MyConstants.currentLong;
  //         //   startTime();
  //       } else {
  //         getLocation();
  //       }
  //     }
  //   } else if (_serviceEnabled) {
  //     if (Platform.isIOS) {
  //       // startTime();
  //     } else if (Platform.isAndroid) {
  //       getLocation();
  //     }
  //   }
  //   print("_serviceEnabled.toString()--- " + _serviceEnabled.toString());
  // }
  //
  // getLocation() async {
  //   LocationData _locationData;
  //
  //   _locationData = await location.getLocation();
  //
  //   MyConstants.currentLat = _locationData.latitude;
  //   MyConstants.currentLong = _locationData.longitude;
  //   prefs.setDouble("lat", _locationData.latitude);
  //   prefs.setDouble("long", _locationData.longitude);
  //
  //   print("onLocationChanged Splash : " +
  //       MyConstants.currentLat.toString() +
  //       " : " +
  //       MyConstants.currentLong.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: color_white,
      body: new Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: SvgPicture.asset(
            'assets/images/app_logo.svg',
            fit: BoxFit.fill,
            /*height: double.infinity,
            width: double.infinity,*/
            /* alignment: Alignment.center,*/
          ),
        ),
      ),
    );
  }
}
