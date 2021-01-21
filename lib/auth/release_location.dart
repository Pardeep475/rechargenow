import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:recharge_now/app/home_screen.dart';
import 'package:recharge_now/app/home_screen_new.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReleaseLocationScreen extends StatefulWidget {
  @override
  _ReleaseLocationScreenState createState() => _ReleaseLocationScreenState();
}

class _ReleaseLocationScreenState extends State<ReleaseLocationScreen> {
  var otp = "";

  SharedPreferences prefs;
  var digitComplete = false;
  bool _saving = false;

  String _currentAddress;

  //final PermissionHandler permissionHandler = PermissionHandler();
  //Map<PermissionGroup, PermissionStatus> permissions;

  initSession() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // requestLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: color_white,
          child: ModalProgressHUD(
            child: Column(
              children: <Widget>[
                appBarViewEndBtn(
                    name: AppLocalizations.of(context)
                        .translate('Release Location'),
                    context: context,
                    callback: () {
                      navigateToDashBoardScreen(isLocation: false);
                    }),
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset('assets/images/slider1.png',
                            fit: BoxFit.cover),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                          height: 51,
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: Image.asset('assets/images/logo.png')),),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: screenPadding, right: screenPadding),
                  child: Text(
                    AppLocalizations.of(context).translate('ACTIVATE LOCATION'),
                    style: sliderTitleTextStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 13, left: screenPadding, right: screenPadding),
                  child: Text(
                    AppLocalizations.of(context).translate('Allow Access'),
                    textAlign: TextAlign.center,
                    style: locationTitleStyle,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: buttonView(
                      text:
                          AppLocalizations.of(context).translate('Release Now'),
                      callback: () async {
                        if (Platform.isAndroid) {
                          _locationUpdatedInAndroid();
                        } else if (Platform.isIOS) {
                          _locationUpdatedInIOS();
                        }
                      }),
                  margin: EdgeInsets.only(
                      left: screenPadding, right: screenPadding),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
            inAsyncCall: _saving,
          )),
    );
  }

  // bool _serviceEnabled = false;
  // var location = new Location();
  //
  // checkLocationServiceEnableOrDisable() async {
  //   _serviceEnabled = await location.serviceEnabled();
  //   print("serviceEnabled" + _serviceEnabled.toString());
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //   } else if (_serviceEnabled) {
  //     navigateToDashBoardScreen();
  //   }
  //   print("_serviceEnabled.toString()--- " + _serviceEnabled.toString());
  // }

  void navigateToDashBoardScreen({bool isLocation = false}) {
    Navigator.pushNamedAndRemoveUntil(
        context, "/HomePage", ModalRoute.withName('/'),
        arguments: isLocation);
    /*Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreenNew()),
        (Route<dynamic> route) => false);*/
  }

  // void _permissionCheckForAndroid() async {
  //   PermissionStatus permission =
  //       await LocationPermissions().requestPermissions();
  //   bool isShown =
  //       await LocationPermissions().shouldShowRequestPermissionRationale();
  //   debugPrint("Permission  Rotational :---     $isShown");
  //   if (PermissionStatus.denied == permission && isShown) {
  //     debugPrint("Permission:---    Normal Permission   $permission");
  //     navigateToDashBoardScreen(isLocation: false);
  //   } else if (PermissionStatus.denied == permission && !isShown) {
  //     debugPrint("Permission:---   open app settings  $permission");
  //     navigateToDashBoardScreen(isLocation: false);
  //   } else if (PermissionStatus.granted == permission) {
  //     debugPrint("Permission:---     $permission");
  //     navigateToDashBoardScreen(isLocation: true);
  //   } else if (PermissionStatus.restricted == permission) {
  //     debugPrint("Permission:---     $permission");
  //     navigateToDashBoardScreen(isLocation: false);
  //   } else if (PermissionStatus.unknown == permission) {
  //     debugPrint("Permission:---     $permission");
  //     navigateToDashBoardScreen(isLocation: false);
  //   }
  // }

  // void _permissionCheckForIOS() async {
  //   PermissionStatus permission =
  //       await LocationPermissions().requestPermissions();
  //
  //   if (PermissionStatus.denied == permission) {
  //     debugPrint("Permission:---    Normal Permission   $permission");
  //     navigateToDashBoardScreen(isLocation: false);
  //   } else if (PermissionStatus.granted == permission) {
  //     debugPrint("Permission:---     $permission");
  //     navigateToDashBoardScreen(isLocation: true);
  //   } else if (PermissionStatus.restricted == permission) {
  //     debugPrint("Permission:---     $permission");
  //     navigateToDashBoardScreen(isLocation: false);
  //   } else if (PermissionStatus.unknown == permission) {
  //     debugPrint("Permission:---     $permission");
  //     navigateToDashBoardScreen(isLocation: false);
  //   }
  // }

  _locationUpdatedInAndroid() async {
    try{
      Location location = new Location();
      LocationData currentLocation = await location.getLocation();
      debugPrint(
          "map_controller      ${currentLocation.latitude}   ${currentLocation.longitude}");
      location.onLocationChanged.listen((LocationData cLoc) async{
        SharedPreferences _prefs =  await SharedPreferences.getInstance();
        _prefs.setDouble("lat", cLoc.latitude);
        _prefs.setDouble("long", cLoc.longitude);
        navigateToDashBoardScreen(isLocation: true);
      }).onError((error){
        navigateToDashBoardScreen(isLocation: false);
      });
    }catch(e){
      navigateToDashBoardScreen(isLocation: false);
    }

  }

  _locationUpdatedInIOS() async {
    Location location = new Location();
    bool _serviceEnabled = await location.serviceEnabled();
    debugPrint("serviceEnabledLocation   ${_serviceEnabled.toString()}");
    if (!_serviceEnabled) {
      debugPrint("serviceEnabledLocation   ${_serviceEnabled.toString()}");
      _serviceEnabled = await location.requestService();
      _getCurrentLocation();
    } else if (_serviceEnabled) {
      debugPrint("serviceEnabledLocation   ${_serviceEnabled.toString()}");
      _getCurrentLocation();
    }
  }

  _getCurrentLocation() async {
    try{
      debugPrint("serviceEnabledLocation   _getCurrentLocation 1");
      await Geolocator.getCurrentPosition().then((Position position) async{
        debugPrint("serviceEnabledLocation   _getCurrentLocation 2");
        Position _currentPosition = position;
        SharedPreferences _prefs =  await SharedPreferences.getInstance();
        _prefs.setDouble("lat", _currentPosition.latitude);
        _prefs.setDouble("long", _currentPosition.longitude);
        navigateToDashBoardScreen(isLocation: true);
      }).catchError((e) {
        debugPrint(e);
        debugPrint("serviceEnabledLocation   _getCurrentLocation 4");
        navigateToDashBoardScreen(isLocation: false);
      });
    }catch(e){
      navigateToDashBoardScreen(isLocation: false);
    }

  }

}
