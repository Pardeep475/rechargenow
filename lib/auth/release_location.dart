import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:recharge_now/app/home_screen.dart';
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
                      navigateToDashBoardScreen(isLocation: true);
                    }),
                Expanded(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/images/slider1.png',
                          fit: BoxFit.cover)),
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
                          _permissionCheckForAndroid();
                        } else if (Platform.isIOS) {
                          _permissionCheckForIOS();
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
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

  void _permissionCheckForAndroid() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    bool isShown =
        await LocationPermissions().shouldShowRequestPermissionRationale();
    debugPrint("Permission  Rotational :---     $isShown");
    if (PermissionStatus.denied == permission && isShown) {
      debugPrint("Permission:---    Normal Permission   $permission");
      // Normal Permission
      navigateToDashBoardScreen(isLocation: true);
    } else if (PermissionStatus.denied == permission && !isShown) {
      debugPrint("Permission:---   open app settings  $permission");
      // bool isOpened = await LocationPermissions().openAppSettings();
      // debugPrint("Permission:---   isOpen  $isOpened");
      // open app settings
      navigateToDashBoardScreen(isLocation: true);
    } else if (PermissionStatus.granted == permission) {
      debugPrint("Permission:---     $permission");
      navigateToDashBoardScreen(isLocation: false);
    } else if (PermissionStatus.restricted == permission) {
      debugPrint("Permission:---     $permission");
      navigateToDashBoardScreen(isLocation: true);
    } else if (PermissionStatus.unknown == permission) {
      debugPrint("Permission:---     $permission");
      navigateToDashBoardScreen(isLocation: true);
    }
  }

  void _permissionCheckForIOS() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();

    if (PermissionStatus.denied == permission) {
      debugPrint("Permission:---    Normal Permission   $permission");
      navigateToDashBoardScreen(isLocation: true);
      // bool isOpened = await LocationPermissions().openAppSettings();
      // Normal Permission
      /*else if (PermissionStatus.denied == permission ) {
      debugPrint("Permission:---   open app settings  $permission");
      bool isOpened = await LocationPermissions().openAppSettings();
      debugPrint("Permission:---   isOpen  $isOpened");
      // open app settings
    }*/
    } else if (PermissionStatus.granted == permission) {
      debugPrint("Permission:---     $permission");
      navigateToDashBoardScreen(isLocation: false);
    } else if (PermissionStatus.restricted == permission) {
      debugPrint("Permission:---     $permission");
      navigateToDashBoardScreen(isLocation: true);
    } else if (PermissionStatus.unknown == permission) {
      debugPrint("Permission:---     $permission");
      navigateToDashBoardScreen(isLocation: true);
    }
  }
}
