import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:recharge_now/app/home_screen.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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
                    name: "Release Location",
                    context: context,
                    callback: () {
                      navigateToDashBoardScreen();
                    }),
                Expanded(
                  child: Container(
                    child: Image.asset('assets/images/slider1.png'),
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
                    "ACTIVATE LOCATION",
                    style: sliderTitleTextStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 13, left: screenPadding, right: screenPadding),
                  child: Text(
                    "Allow us to access your location to show you all the show rental stations in the vicinity.",
                    textAlign: TextAlign.center,
                    style: locationTitleStyle,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: buttonView(
                      text: "Release Now",
                      callback: () async {
                        checkLocationServiceEnableOrDisable();
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

  bool _serviceEnabled = false;
  var location = new Location();
  checkLocationServiceEnableOrDisable() async {

    _serviceEnabled = await location.serviceEnabled();
    print("serviceEnabled" + _serviceEnabled.toString());
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

    } else if (_serviceEnabled) {
      navigateToDashBoardScreen();
    }
    print("_serviceEnabled.toString()--- " + _serviceEnabled.toString());


  }





  void navigateToDashBoardScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }
}
