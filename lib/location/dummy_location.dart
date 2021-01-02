import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class DummyLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DummyLocationState();
}

class _DummyLocationState extends State<DummyLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            _checkLocationPermission();
          },
          child: Text("Location Testing"),
        ),
      ),
    );
  }

  _checkLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    // debugPrint("Permission:---     $permission");
    // if (PermissionStatus.denied == permission) {
    //   _enableLocationPermission();
    // }

    _permissionCheckForIOS();
  }

  _enableLocationPermission() async {
    // PermissionStatus permission = await LocationPermissions().requestPermissions();

    if (Platform.isAndroid) {
      _permissionCheckForAndroid();
    } else if (Platform.isIOS) {
      _permissionCheckForIOS();
    }

    // ServiceStatus serviceStatus =
    //     await LocationPermissions().checkServiceStatus();
    // debugPrint("serviceStatus  Rotational :---     $serviceStatus");
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
    } else if (PermissionStatus.denied == permission && !isShown) {
      debugPrint("Permission:---   open app settings  $permission");
      bool isOpened = await LocationPermissions().openAppSettings();
      debugPrint("Permission:---   isOpen  $isOpened");
      // open app settings
    } else if (PermissionStatus.granted == permission) {
      debugPrint("Permission:---     $permission");
    } else if (PermissionStatus.restricted == permission) {
      debugPrint("Permission:---     $permission");
    } else if (PermissionStatus.unknown == permission) {
      debugPrint("Permission:---     $permission");
    }
  }

  void _permissionCheckForIOS() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();

    if (PermissionStatus.denied == permission) {
      debugPrint("Permission:---    Normal Permission   $permission");
      bool isOpened = await LocationPermissions().openAppSettings();
      // Normal Permission
      /*else if (PermissionStatus.denied == permission ) {
      debugPrint("Permission:---   open app settings  $permission");
      bool isOpened = await LocationPermissions().openAppSettings();
      debugPrint("Permission:---   isOpen  $isOpened");
      // open app settings
    }*/
    }
    else if (PermissionStatus.granted == permission) {
      debugPrint("Permission:---     $permission");
    } else if (PermissionStatus.restricted == permission) {
      debugPrint("Permission:---     $permission");
    } else if (PermissionStatus.unknown == permission) {
      debugPrint("Permission:---     $permission");
    }
  }
}
