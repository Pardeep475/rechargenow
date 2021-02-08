import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:battery/battery.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/scan_bar_qr_code_screen.dart';
import 'package:recharge_now/auth/intro_screen.dart';
import 'package:recharge_now/auth/login_screen.dart';
import 'package:recharge_now/common/CustomDialogBox.dart';
import 'package:recharge_now/common/custom_widgets/common_error_dialog.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/location/gesture_detector_on_map.dart';
import 'package:recharge_now/models/station_list_model.dart';
import 'package:recharge_now/models/user_deatil_model.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';
import 'package:recharge_now/utils/app_colors.dart';
import 'package:recharge_now/utils/color_list.dart';
import 'package:recharge_now/utils/map_helper.dart';
import 'package:recharge_now/utils/map_marker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomsheet/how_timer_bottomsheet.dart';
import 'faq/FAQScreen.dart';
import 'history/HistoryScreen.dart';
import 'home_toolbar.dart';
import 'mietstation/mietstation_list_scren.dart';
import 'notification/notification_list_screen.dart';
import 'paymentscreens/add_payment_method_screen.dart';
import 'promo/promo_screen.dart';
import 'settings/SettingsScreen.dart';
import 'package:flutter/services.dart' show rootBundle;

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class HomeScreenNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  AnimationController _animateController;
  GoogleMapController _mapController;

  // Completer<GoogleMapController> _controller = Completer();
  LatLng _latlng1 = LatLng(MyConstants.currentLat, MyConstants.currentLong);
  SharedPreferences _prefs;
  String _walletAmount = "";
  double _zoomLevel = 16.0;
  List<MapLocation> _mapLocationList;
  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;
  final Set<Marker> _markers = {};
  double _currentZoom = 16;
  final Color _clusterColor = primaryGreenColor;
  final Color _clusterTextColor = Colors.white;
  bool animateFirstTime = true;
  bool showBottomSheet = false;
  bool isBottomSheetButtonClickable = true;
  var rentalTime;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isLocationOn = true;
  bool isNotificationSent = false;
  Timer timer;

  bool _isCameraMove = false;
  String _mapStyle;

  // for my custom marker pins
  BitmapDescriptor currentLocationIcon;
  LocationData currentLocation;

  @override
  void initState() {
    super.initState();
    _initBatteryInfo();
    _initIntercom();
    rootBundle.loadString('assets/myStyle.txt').then((string) {
      _mapStyle = string;
    });
    _animateController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    loadShredPref();
    firebaseCloudMessaging_Listeners();


  }

  void loadShredPref() async {
    _prefs = await SharedPreferences.getInstance();
    _updateLanguage();
    timer = Timer.periodic(
      Duration(seconds: 60),
      (Timer t) => _getStationsOnMapApi(),
    );
    _walletAmount = await _prefs.get('walletAmount').toString();
    isNotificationSent = await _prefs.getBool('isNotificationSent');
    if (_prefs.getDouble("lat") != null)
      MyConstants.currentLat = _prefs.getDouble("lat");
    if (_prefs.getDouble("long") != null)
      MyConstants.currentLong = _prefs.getDouble("long");
    _latlng1 = LatLng(MyConstants.currentLat, MyConstants.currentLong);
    if (_prefs.get("isRental") == true) {
      showBottomSheet = true;
      setState(() {});
    }
    _getDetailsApi();
    _getStationsOnMapApi();
    _getRentalDetailsList();
  }

  @override
  void dispose() {
    timer?.cancel();
    _animateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isLocationOn = ModalRoute.of(context).settings.arguments;
    debugPrint("isLocationOn   $isLocationOn");
    if (isLocationOn == null) {
      isLocationOn = true;
    }

    if (isLocationOn) {
      if (Platform.isAndroid) {
        // _locationUpdatedInAndroid();
        _getCurrentLocation();
      } else {
        debugPrint("map_controller      IOS   $isLocationOn");
        _locationUpdatedInIOS();
      }
    }

    debugPrint("isLocationOn   $isLocationOn");
    return Scaffold(
      key: _drawerKey,
      drawer: _drawerUI(),
      body: ModalProgressHUD(
        child: Container(
            child: Stack(
          children: <Widget>[
            _mapViewUI(),
            HomeScreenToolbar(
              callBack: (value) {
                if (value == 1) {
                  _walletAmount = _prefs.get('walletAmount').toString();
                  setState(() {});
                  _drawerKey.currentState.openDrawer();
                } else if (value == 2) {
                  //notification click
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => NotificationScreen(),
                    ),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _buildTabView(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 183),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[_buttonRefreshUI()],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 118),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buttonLocationUI(),
                    _buttonDamageUI(),
                  ],
                ),
              ),
            ),
            _scannerButtonUI(),
            bottomSheetButtonUi()
          ],
        )),
        inAsyncCall: false,
      ),
    );
  }

  // map ui
  _mapViewUI() {
    // debugPrint("isLocationOn   $isLocationOn");
    //
    CameraPosition initialCameraPosition =
        CameraPosition(zoom: CAMERA_ZOOM, tilt: CAMERA_TILT, target: _latlng1);
    // if (currentLocation != null) {
    //   initialCameraPosition = CameraPosition(
    //       target: LatLng(currentLocation.latitude,
    //           currentLocation.longitude),
    //       zoom: CAMERA_ZOOM,
    //       tilt: CAMERA_TILT,
    //   );
    // }

    return Visibility(
      visible: true,
      child: GoogleMap(
        mapToolbarEnabled: false,
        rotateGesturesEnabled: true,
        zoomControlsEnabled: false,
        compassEnabled: true,
        initialCameraPosition: initialCameraPosition,
        mapType: MapType.normal,
        markers: _markers,
        gestureRecognizers: Set()
          ..add(Factory<DragGestureRecognizer>(() => GestureDetectorOnMap(() {
                _isCameraMove = true;
                debugPrint("gesture_detector_on_map:-   $_isCameraMove");
              }))),
        onMapCreated: (controller) {
          // _onMapCreated(controller);
          // _controller.complete(controller);
          _mapController = controller;
          _mapController.setMapStyle(_mapStyle);
          // _updateMarkers(CAMERA_ZOOM);
        },
        onCameraMove: (position) {
          debugPrint("On_Camera_Move     On_Camera_Move");
          // _isCameraMove = true;
        },
        myLocationButtonEnabled: false,
        myLocationEnabled: isLocationOn,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
    debugPrint("map_controller      onMap Created   $isLocationOn");
    if (isLocationOn) {
      if (Platform.isAndroid) {
        _locationUpdatedInAndroid();
      } else {
        debugPrint("map_controller      IOS   $isLocationOn");
        _locationUpdatedInIOS();
      }
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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
    Location location = new Location();
    currentLocation = await location.getLocation();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      _prefs.setDouble("lat", currentLocation.latitude);
      _prefs.setDouble("long", currentLocation.longitude);
      MyConstants.currentLat = currentLocation.latitude;
      MyConstants.currentLong = currentLocation.longitude;
      CameraPosition _currentCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        target: LatLng(MyConstants.currentLat, MyConstants.currentLong),
      );
      if (!_isCameraMove) {
        _mapController.animateCamera(
            CameraUpdate.newCameraPosition(_currentCameraPosition));
      }

      _updateMarkers(CAMERA_ZOOM);
    });

    // debugPrint("map_controller      onMap Created   $isLocationOn");
    // // Location location = new Location();
    // currentLocation = await location.getLocation();
    // debugPrint(
    //     "map_controller      ${currentLocation.latitude}   ${currentLocation.longitude}");
    // location.onLocationChanged.listen((LocationData cLoc) {
    //   debugPrint(
    //       "map_controller  location changed  ${cLoc.latitude}   ${cLoc.longitude}");
    //   currentLocation = cLoc;
    //   CameraPosition _currentCameraPosition = CameraPosition(
    //       target: LatLng(MyConstants.currentLong, MyConstants.currentLong),
    //       zoom: _zoomLevel);
    //   _mapController.animateCamera(
    //       CameraUpdate.newCameraPosition(_currentCameraPosition));
    //
    //   //
    //   // if (_latlng1.latitude != cLoc.latitude &&
    //   //     _latlng1.longitude != cLoc.longitude &&
    //   //     (currentLocation == null ||
    //   //         currentLocation.latitude != cLoc.latitude &&
    //   //             currentLocation.longitude != cLoc.longitude)) {
    //   //   currentLocation = cLoc;
    //   //   // double _distance = calculateDistance(
    //   //   //     currentLocation.latitude,
    //   //   //     currentLocation.longitude,
    //   //   //     currentLocation.latitude,
    //   //   //     currentLocation.longitude);
    //   //   //
    //   //   /*if (!_isCameraMove) {
    //   //     if (_mapController != null) {
    //   //       debugPrint("map_controller     _isCameraMove  false");
    //   //       MyConstants.currentLat = currentLocation.latitude;
    //   //       MyConstants.currentLong = currentLocation.longitude;
    //   //       _prefs.setDouble("lat", currentLocation.latitude);
    //   //       _prefs.setDouble("long", currentLocation.longitude);
    //   //       CameraPosition _currentCameraPosition = CameraPosition(
    //   //           target:
    //   //           LatLng(MyConstants.currentLong, MyConstants.currentLong),
    //   //           zoom: _zoomLevel);
    //   //       _mapController.animateCamera(
    //   //           CameraUpdate.newCameraPosition(_currentCameraPosition));
    //   //       _isCameraMove = true;
    //   //     }
    //   //   } else if (*/ /*_distance > 1000 &&*/ /* _isCameraMove) {
    //   //     if (_mapController != null) {
    //   //       debugPrint("map_controller     _isCameraMove  true");
    //   //       _prefs.setDouble("lat", currentLocation.latitude);
    //   //       _prefs.setDouble("long", currentLocation.longitude);
    //   //       MyConstants.currentLat = currentLocation.latitude;
    //   //       MyConstants.currentLong = currentLocation.longitude;
    //   //       CameraPosition _currentCameraPosition = CameraPosition(
    //   //           target: LatLng(MyConstants.currentLat, MyConstants.currentLong),
    //   //           zoom: _zoomLevel);
    //   //       _mapController.animateCamera(
    //   //           CameraUpdate.newCameraPosition(_currentCameraPosition));
    //   //     }
    //   //   }*/
    //   //
    //   //   // if (_mapController != null /*&& !_isCameraMove*/) {
    //   //   //   // debugPrint("map_controller     _isCameraMove  false");
    //   //   //   if(MyConstants.currentLat != currentLocation.latitude && MyConstants.currentLong != currentLocation.longitude){
    //   //   //     MyConstants.currentLat = currentLocation.latitude;
    //   //   //     MyConstants.currentLong = currentLocation.longitude;
    //   //   //     _prefs.setDouble("lat", currentLocation.latitude);
    //   //   //     _prefs.setDouble("long", currentLocation.longitude);
    //   //   //     CameraPosition _currentCameraPosition = CameraPosition(
    //   //   //         target: LatLng(MyConstants.currentLong, MyConstants.currentLong),
    //   //   //         zoom: _zoomLevel);
    //   //   //     _mapController.animateCamera(
    //   //   //         CameraUpdate.newCameraPosition(_currentCameraPosition));
    //   //   //   }
    //   //   //
    //   //   //   // _isCameraMove = true;
    //   //   // }
    //   //
    //   //   currentLocation = cLoc;
    //   //
    //   // }
    // });

    // Location location = new Location();
    // location.onLocationChanged.listen((LocationData cLoc) {
    //   debugPrint("map_controller   ${cLoc.latitude}");
    //   debugPrint("serviceEnabledLocation   _getCurrentLocation 2");
    //   // Position _currentPosition = position;
    //   _prefs.setDouble("lat", cLoc.latitude);
    //   _prefs.setDouble("long", cLoc.longitude);
    //   MyConstants.currentLat = cLoc.latitude;
    //   MyConstants.currentLong = cLoc.longitude;
    //
    //   if (_mapController != null) {
    //     debugPrint(
    //         "serviceEnabledLocation   _getCurrentLocation 3   ${MyConstants.currentLat} ${MyConstants.currentLong}");
    //     // CameraPosition _currentCameraPosition = CameraPosition(
    //     //     target: LatLng(MyConstants.currentLat, MyConstants.currentLong),
    //     //     zoom: _zoomLevel);
    //     Future.delayed(Duration(milliseconds: 100), () {
    //       _mapController.animateCamera(CameraUpdate.newCameraPosition(
    //         CameraPosition(
    //           bearing: 0,
    //           target: LatLng(MyConstants.currentLat, MyConstants.currentLong),
    //           zoom: _zoomLevel,
    //         ),
    //       ));
    //
    //     });
    //   }
    // });

    // debugPrint("serviceEnabledLocation   _getCurrentLocation 1");
    // await Geolocator.getCurrentPosition().then((Position position) {
    //
    // }).catchError((e) {
    //   debugPrint(e);
    //   debugPrint("serviceEnabledLocation   _getCurrentLocation 4");
    // });
  }

  _locationUpdatedInAndroid() async {
    /* debugPrint("map_controller      onMap Created   $isLocationOn");
    Location location = new Location();
    currentLocation = await location.getLocation();
    debugPrint(
        "map_controller      ${currentLocation.latitude}   ${currentLocation.longitude}");
    location.onLocationChanged.listen((LocationData cLoc) {
      debugPrint(
          "map_controller  location changed  ${cLoc.latitude}   ${cLoc.longitude}");
      if (_latlng1.latitude != cLoc.latitude &&
          _latlng1.longitude != cLoc.longitude &&
          (currentLocation == null ||
              currentLocation.latitude != cLoc.latitude &&
                  currentLocation.longitude != cLoc.longitude)) {
        currentLocation = cLoc;
        double _distance = calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            currentLocation.latitude,
            currentLocation.longitude);
        //
        if (!_isCameraMove) {
          if (_mapController != null) {
            debugPrint("map_controller     _isCameraMove  false");
            MyConstants.currentLat = currentLocation.latitude;
            MyConstants.currentLong = currentLocation.longitude;
            _prefs.setDouble("lat", currentLocation.latitude);
            _prefs.setDouble("long", currentLocation.longitude);
            CameraPosition _currentCameraPosition = CameraPosition(
                target:
                    LatLng(MyConstants.currentLong, MyConstants.currentLong),
                zoom: _zoomLevel);
            _mapController.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));
            _isCameraMove = true;
          }
        } else if (_distance > 1000 && _isCameraMove) {
          if (_mapController != null) {
            debugPrint("map_controller     _isCameraMove  true");
            _prefs.setDouble("lat", currentLocation.latitude);
            _prefs.setDouble("long", currentLocation.longitude);
            MyConstants.currentLat = currentLocation.latitude;
            MyConstants.currentLong = currentLocation.longitude;
            CameraPosition _currentCameraPosition = CameraPosition(
                target: LatLng(MyConstants.currentLat, MyConstants.currentLong),
                zoom: _zoomLevel);
            _mapController.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));
          }
        }
      }
    });*/
  }

  // navigation drawer
  _drawerUI() {
    return Drawer(
      child: Container(
        color: color_white,
        width: double.infinity,
        height: double.infinity,
        child: _navigationDrawer(),
      ),
    );
  }

  Widget _navigationDrawer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      Dimens.twentyFive, Dimens.fifteen, Dimens.twentyFive, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(Icons.clear),
                        ),
                      ),
                      SizedBox(
                        height: Dimens.twentyFive,
                      ),
                      Center(
                        child: SizedBox(
                          height: Dimens.fifty,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0, Dimens.twentyFive, 0, Dimens.thirty),
                        height: 1,
                        color: AppColor.divider_color,
                      ),
                    ],
                  ),
                ),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(
                    left: Dimens.twentyFive, right: Dimens.fifteen),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('Payment'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset(
                  'assets/images/menu-payment.svg',
                  width: Dimens.twentyFive,
                  height: Dimens.twenty,
                ),
                trailing: Text(
                  _walletAmount ?? "0,00€",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF54DF6C),
                      fontSize: Dimens.fifteen,
                      height: 1.2),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddPaymentMethodInitialScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(
                    left: Dimens.twentyFive, right: Dimens.fifteen),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('HISTORY'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset(
                  'assets/images/meu-history.svg',
                  width: Dimens.twentyFive,
                  height: Dimens.twentyFive,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) => HistoryScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(
                    left: Dimens.twentyFive, right: Dimens.fifteen),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('HOW IT WORKS'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset(
                  'assets/images/meu-how-it-work.svg',
                  width: Dimens.twentyFive,
                  height: Dimens.twentyFive,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) => HowToWorkScreen(
                        isFromHome: true,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(
                    left: Dimens.twentyFive, right: Dimens.fifteen),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('promo code'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset(
                  'assets/images/meni-promo.svg',
                  width: Dimens.twentyFive,
                  height: Dimens.twenty,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) => PromoCodeScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(
                    left: Dimens.twentyFive, right: Dimens.fifteen),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    "FAQ",
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset(
                  'assets/images/menu-help.svg',
                  width: Dimens.twentyFive,
                  height: Dimens.twentyFive,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) => FAQScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(
                    left: Dimens.twentyFive, right: Dimens.fifteen),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('SETTINGS'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset(
                  'assets/images/menu-settings.svg',
                  width: Dimens.twentyFive,
                  height: Dimens.twentyFive,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) => SettingsScreen(),
                    ),
                  );
                },
              ),

              //bottom
            ],
          ),
        ),
        Visibility(
          visible: true,
          child: Align(
            child: Container(
                //color: Colors.black,
                height: 125,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      height: 0.3,
                      color: Colors.grey,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      MyUtils.launchURL(
                                          MyConstants.FACEBOOK_URL);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/facebook.svg',
                                      color: Colors.blue,
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      MyUtils.launchURL(MyConstants.INSTA_URL);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/instagram.svg',
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Center(
                            child: Text(
                              "Copyright © 2020 RechargeNow GmbH",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: color_grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }

// end navigation drawer

  //  tab layout
  _buildTabView() {
    return Container(
      height: 53.0,
      width: 180,
      margin: EdgeInsets.only(top: 131),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(
                0.21,
              ),
              offset: Offset(0, 4),
              blurRadius: 8)
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(150),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            child: SvgPicture.asset('assets/images/listtab.svg'),
            top: 0,
            bottom: 0,
          ),
          Positioned(
            left: 105,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => StationListScreen(),
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  SvgPicture.asset('assets/images/listIcon.svg'),
                  SizedBox(
                    width: 12,
                  ),
                  content()
                ],
              ),
            ),
            top: 0,
            bottom: 0,
          ),
          Positioned(
            left: 15,
            child: Row(
              children: <Widget>[
                SvgPicture.asset('assets/images/mapIcon.svg'),
                SizedBox(
                  width: 12,
                ),
                mapText()
              ],
            ),
            top: 0,
            bottom: 0,
          ),
        ],
      ),
    );
  }

  content() {
    return Text(
      AppLocalizations.of(context).translate('List'),
      style: TextStyle(
          fontSize: 11.0,
          height: 1.8,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: lightGray_text),
    );
  }

  mapText() {
    return Text(
      AppLocalizations.of(context).translate('Map'),
      style: TextStyle(
          fontSize: 11.0,
          height: 1.8,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: Color(0xff231F20)),
    );
  }

// end  tab layout

  // refresh ui
  _buttonRefreshUI() {
    return GestureDetector(
      onTap: () {
        _animateController.repeat();
        Timer(Duration(seconds: 2), () {
          _animateController.reset();
        });

        _getStationsOnMapApi();
        _getDetailsApi();
        // _isCameraMove = true;
      },
      child: Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 5.0).animate(_animateController),
              child: SvgPicture.asset(
                'assets/images/refresh_icon.svg',
                color: primaryGreenColor,
              ),
            ),
          ),
        ), // You can add a Icon instead of text also, like below.
      ),
    );
  }

  // button intercom
  _buttonLocationUI() {
    return IconButton(
      padding: EdgeInsets.only(left: 20),
      icon: SvgPicture.asset(
        'assets/images/musicIcon.svg',
      ),
      onPressed: () async {
        await Intercom.displayMessenger();
      },
      iconSize: 50.0,
    );
  }

  _initIntercom() async {
    await Intercom.initialize('nait0fkp',
        iosApiKey: 'ios_sdk-4a6b5dbb9308a9ce3a9f8879b85d20753d28bf1d',
        androidApiKey: 'android_sdk-105de09284d5c5ca5aa918e21f02cc744407fc32');
    Intercom.registerUnidentifiedUser(); // <<< add this
  }

  // button fetch location
  _buttonDamageUI() {
    return IconButton(
      padding: EdgeInsets.only(right: 20),
      icon: SvgPicture.asset(
        'assets/images/locator.svg',
      ),
      onPressed: () async {
        debugPrint("map_controller     ");
        // Safety check if mapController not null
        _isCameraMove = false;
        if (_mapController != null) {
          debugPrint("map_controller     not null");
          CameraPosition _currentCameraPosition = CameraPosition(
              target: LatLng(MyConstants.currentLat, MyConstants.currentLong),
              zoom: _zoomLevel);
          _mapController.animateCamera(
              CameraUpdate.newCameraPosition(_currentCameraPosition));
        }
      },
      iconSize: 50.0,
    );
  }

// scan button ui
  _scannerButtonUI() {
    return GestureDetector(
        onTap: () {
          _scanQR();
        },
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: new Container(
            height: 45,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 55),
            // padding: const EdgeInsets.all(3.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    offset: Offset(0, 4),
                    blurRadius: 4)
              ],
              borderRadius: const BorderRadius.all(
                const Radius.circular(30.0),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: SvgPicture.asset(
                      'assets/images/qr-code.svg',
                      color: primaryGreenColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                      AppLocalizations.of(context)
                          .translate("Scan to charge")
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryGreenColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      textDirection: TextDirection.ltr),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _scanQR() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanQrBarCodeScreen()),
    ).then((qrResult) {
      debugPrint("barcode_is_scanner_result   $qrResult");
      if (qrResult != null && qrResult != "" && qrResult != "-1") {
        _rentBattery_PowerbankAPI(
            _prefs.get('userId').toString(), qrResult.toString());
      }
    });
  }

  _rentBattery_PowerbankAPI(userId, deviceId) async {
    MyUtils.showLoaderDialog(context);
    var req = {"userId": userId, "deviceId": deviceId};
    var jsonReqString = json.encode(req);
    await rentBattery_PowerbankApi(
            jsonReqString, _prefs.get('accessToken').toString())
        .then((response) {
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context);

        if (jsonResponse['status'].toString() == "1") {
          setState(() {
            showBottomSheet = true;
          });
          _showDifferentTypeOfDialogs(
              message: "SUCCESS",
              context: context,
              currncy: jsonResponse['slotNumber']);
        } else if (jsonResponse['status'].toString() == "3") {
          debugPrint("rentBattery_PowerbankAPI   3");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppLocalizations.of(context)
                      .translate("Check your payment methods"),
                  descriptions: AppLocalizations.of(context).translate(
                      "Deposit a payment method to release a Powerbank"),
                  text:
                      AppLocalizations.of(context).translate("PAYMENT METHODS"),
                  img: "assets/images/wallet-euro.svg",
                  double: 50.0,
                  isCrossIconShow: true,
                  callback: () {},
                );
              });
        } else {
          _showDifferentTypeOfDialogs(
              message: jsonResponse['message'] ?? "SOMETHING_WRONG",
              context: context);
        }
      } else {
        Navigator.pop(context);
        _showDifferentTypeOfDialogs(
            message: jsonResponse['message'] ?? "SOMETHING_WRONG",
            context: context);
      }
    }).catchError((onError) {
      Navigator.pop(context);
    });
  }

  // bottom sheets
  bottomSheetButtonUi() {
    return Visibility(
      visible: showBottomSheet,
      maintainAnimation: true,
      maintainState: true,
      child: GestureDetector(
        onTap: () {
          if (isBottomSheetButtonClickable) {
            isBottomSheetButtonClickable = false;
            _getRentalDetailsList();
          }
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 38,
            width: 110,
            decoration: new BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: Center(
              child: SizedBox(
                child: Transform.rotate(
                  angle: 135,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// stations api
  _getStationsOnMapApi() async {
    var betteryAlarm = _prefs.getBool('betteryAlarm');
    if (betteryAlarm != null && betteryAlarm) {
      _initBatteryInfo();
    }
    var req = {
      "latitude": MyConstants.currentLat.toString(),
      "longitude": MyConstants.currentLong.toString()
    };
    var jsonReqString = json.encode(req);
    print("accesstoken " + _prefs.get('accessToken').toString());
    await getMapLocationsApi(
            jsonReqString, _prefs.get('accessToken').toString())
        .then((response) {
      final jsonResponse = json.decode(response.body);
      StationsListPojo stationsListPojo =
          StationsListPojo.fromJson(jsonResponse);
      if (response.statusCode == 200) {
        if (jsonResponse['status'] == 0 &&
            jsonResponse['message'].compareTo('ILLEGAL_ACCESS') == 0) {
          debugPrint('status_12345 ---->     ${jsonResponse['status']}');
          _prefs.setBool('is_login', false);
          _navigateToLoginScreen();
        }
        if (stationsListPojo.status == 0 &&
            stationsListPojo.message.compareTo('ILLEGAL_ACCESS') == 0) {
          _prefs.setBool('is_login', false);
          _navigateToLoginScreen();
        } else {
          _mapLocationList = [];
          _mapLocationList = stationsListPojo.mapLocations;
          debugPrint('stationsListPojo2 ---->     ${_mapLocationList.length}');
          _initMarkers(_mapLocationList);
          if (animateFirstTime) {
            CameraUpdate cameraUpdate =
                CameraUpdate.newLatLngZoom(_latlng1, _zoomLevel);
            if (_mapController != null)
              _mapController.animateCamera(cameraUpdate);
            animateFirstTime = false;
          }
          setState(() {});
        }
      } else {
        debugPrint("rentBattery_PowerbankAPI   getStationsOnMapApi else");
        _showDifferentTypeOfDialogs(
            message: stationsListPojo.message, context: context);
      }
    }).catchError((onError) {
      debugPrint(
          "rentBattery_PowerbankAPI   getStationsOnMapApi ${onError.toString()}");
    });
  }

  _navigateToLoginScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  _showDifferentTypeOfDialogs(
      {String title, String message, BuildContext context, String currncy}) {
    switch (message) {
      case "SOMETHING_WRONG":
        {
          debugPrint("firebasemessegeis     ->      SOMETHING_WRONG");
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions: AppLocalizations.of(context)
                  .translate("something_went_wrong"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      case "POWERBANK_RENTED_ALREADY":
        {
          debugPrint("firebasemessegeis     ->      POWERBANK_RENTED_ALREADY");
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions: AppLocalizations.of(context)
                  .translate("You can only borrow one Powerbank at a time"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      case "POWERBANK_RETURNED":
        {
          debugPrint("firebasemessegeis     ->      POWERBANK_RETURNED");
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context).translate("THANK YOU"),
              descriptions: AppLocalizations.of(context).translate(
                  "You have successfully brought back the Powerbank"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/congratulation.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      case "POWERBANK_RETURNED_MSG":
        {
          debugPrint("firebasemessegeis     ->      POWERBANK_RETURNED_MSG");
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context).translate("THANK YOU"),
              descriptions: AppLocalizations.of(context).translate(
                  "You have successfully brought back the Powerbank"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/congratulation.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      case "RENTAL_PERIOD_EXCEEDED":
        {
          debugPrint("firebasemessegeis     ->      RENTAL_PERIOD_EXCEEDED");
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context)
                  .translate("RENTAL PERIOD EXCEEDED"),
              descriptions: AppLocalizations.of(context)
                  .translate("RENTAL PERIOD EXCEEDED DES"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      case "POWERBANK_SOLD_MSG":
        {
          debugPrint("firebasemessegeis     ->      POWERBANK_SOLD_MSG");
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context)
                  .translate("RENTAL PERIOD EXCEEDED"),
              descriptions: AppLocalizations.of(context)
                  .translate("RENTAL PERIOD EXCEEDED DES"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      case "STATION_OFFLINE":
        {
          debugPrint("firebasemessegeis     ->      STATION_OFFLINE");
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context)
                  .translate("RENTAL STATION IS OFFLINE"),
              descriptions: AppLocalizations.of(context)
                  .translate("RENTAL STATION IS OFFLINE DES"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      case "SUCCESS":
        {
          debugPrint("firebasemessegeis     ->      STATION_OFFLINE");
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context).translate("Congratulations"),
              descriptions:
                  "${AppLocalizations.of(context).translate("Your Powerbank has been successfully released from slot")} $currncy ${AppLocalizations.of(context).translate("Your Powerbank has been successfully released from slot two")}",
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/congratulation.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      case "FAILED_TXN_EXISTS":
        {
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions:
                  AppLocalizations.of(context).translate("FAILED_TXN_EXISTS"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
      //FAILED_TXN_EXISTS
      default:
        {
          openDialogWithSlideInAnimation(
            context: context,
            itemWidget: CommonErrorDialog(
              title: title ??
                  AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions: message ??
                  AppLocalizations.of(context)
                      .translate("something_went_wrong"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            ),
          );
        }
        break;
    }
  }

// battery functionality
  void _initBatteryInfo() async {
    Battery _battery = Battery();
    var batteryLevel = await _battery.batteryLevel;
    isNotificationSent = await _prefs.getBool('isNotificationSent');
    if (batteryLevel < 20 &&
        isNotificationSent != null &&
        !isNotificationSent) {
      _prefs.setBool('isNotificationSent', true);
      sendBatterAlarmToServer();
    } else if (batteryLevel > 20) {
      _prefs.setBool('isNotificationSent', false);
    }
  }

  sendBatterAlarmToServer() async {
    await sendAlarm(_prefs.get('userId').toString(),
            _prefs.get('accessToken').toString())
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {}
    }).catchError((onError) {});
  }

  void _initMarkers(List<MapLocation> locationList) async {
    _markers.clear();
    final Uint8List blackMarkerIcon = await getBytesFromAsset(
        'assets/images/black_marker.png', Dimens.oneTwentyFive.toInt());
    final Uint8List greenMarkerIcon = await getBytesFromAsset(
        'assets/images/green_marker.png', Dimens.oneTwentyFive.toInt());
    final List<MapMarker> markers = [];

    for (int i = 0; i < locationList.length; i++) {
      Marker resultMarker = Marker(
        icon: locationList[i].open == true
            ? BitmapDescriptor.fromBytes(greenMarkerIcon)
            : BitmapDescriptor.fromBytes(blackMarkerIcon),
        consumeTapEvents: false,
        onTap: () {
          // _onMarkerClick(locationList[i]);
        },
        markerId: MarkerId(locationList[i].id.toString()),
        infoWindow: InfoWindow(
            onTap: () {
              // _onMarkerClick(locationList[i]);
            },
            title: "${locationList[i].name}",
            snippet: "${locationList[i].name}"),
        position: LatLng(
          double.parse(locationList[i].latitude),
          double.parse(locationList[i].longitude),
        ),
      );
      // Marker
      markers.add(
        MapMarker(
            id: locationList[i].id.toString(),
            position: LatLng(
              double.parse(locationList[i].latitude),
              double.parse(locationList[i].longitude),
            ),
            icon: locationList[i].open == true
                ? BitmapDescriptor.fromBytes(greenMarkerIcon)
                : BitmapDescriptor.fromBytes(blackMarkerIcon),
            data: locationList[i],
            context: context),
      );
      _markers.add(resultMarker);
      setState(() {});
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }
    // setState(() {});

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {});
  }

  _getDetailsApi() async {
    await getUserDetailsApi(_prefs.get('userId').toString(),
            _prefs.get('accessToken').toString())
        .then((response) {
      final jsonResponse = json.decode(response.body);
      UserDetailsPojo userDetailsPojo = UserDetailsPojo.fromJson(jsonResponse);
      if (response.statusCode == 200) {
        UserDetails userdetails = userDetailsPojo.userDetails;
        _prefs.setString('walletAmount', userdetails.walletAmount.toString());
        _prefs.setBool('isRental', userDetailsPojo.isRental);
        setState(() {});
      } else {
        debugPrint("rentBattery_PowerbankAPI   getDetailsApi");
        _showDifferentTypeOfDialogs(
            message: userDetailsPojo.message, context: context);
      }
    }).catchError((value) {
      debugPrint("rentBattery_PowerbankAPI   getDetailsApi catchError");
    });
  }

  _updateLanguage() {
    //   "{
    //   ""id"":1,
    //   ""language"":""en""
    // }"

    //   "{
    //   ""status"":1,
    //   ""message"":""Success""
    // }"

    var req = {
      "id": _prefs.get('userId').toString(),
      "language": _prefs.getString('language_code')
    };
    var jsonReqString = json.encode(req);
    debugPrint("languageApiResponse:-   $jsonReqString");
    var apicall =
        updateLanguage(jsonReqString, _prefs.get('accessToken').toString());
    apicall.then((response) {
      debugPrint("languageApiResponse:-   ${response.body}");
    }).catchError((value) {
      debugPrint("languageApiResponse   getDetailsApi catchError");
    });
  }

  _getRentalDetailsList() {
    var apicall = getCurrentRentalDetailsApi(
        _prefs.get('userId').toString(), _prefs.get('accessToken').toString());
    apicall.then((response) {
      isBottomSheetButtonClickable = true;
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonResponse['status'].toString() == "1") {
          var rentalPrice = jsonResponse['rentalDetails']['rentalPrice'];
          rentalTime = jsonResponse['rentalDetails']['rentalTime'];
          _modalBottomSheetMenu(rentalPrice, rentalTime);
        } else if (jsonResponse['status'].toString() == "2") {
          debugPrint("rentBattery_PowerbankAPI   getRentalDetailsList   2");
          _showDifferentTypeOfDialogs(
              message: jsonResponse['message'] ?? "SOMETHING_WRONG",
              context: context);
        } else if (jsonResponse['status'].toString() == "0") {
          _prefs.setString(
              'walletAmount', jsonResponse['walletAmount'].toString());
          setState(() {
            showBottomSheet = false;
          });
        } else {
          setState(() {
            showBottomSheet = false;
          });
        }
      } else {
        _showDifferentTypeOfDialogs(
            message: jsonResponse["message"] ?? "SOMETHING_WRONG",
            context: context);
      }
    }).catchError((error) {
      _showDifferentTypeOfDialogs(message: error.toString(), context: context);
    });
  }

  void _modalBottomSheetMenu(rentalPrice, rentalTime) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 95,
                  //margin: EdgeInsets.fromLTRB(20,20,20,0),
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              HomeTimerBottomSheeet(
                rentalPrice: rentalPrice,
                rentalTime: rentalTime,
                walletAmount: _walletAmount,
              )
            ],
          );
        });
  }

  // firebase messaging
  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.subscribeToTopic('flutter');
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      _prefs.setString('fcmtoken', token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var _message;
        // if (Theme.of(context).platform == TargetPlatform.iOS) {
        //   _message = message['notification'];
        // } else {
        //   _message = message['notification'];
        // }

        if (message['notification'] == null) {
          _message = message["aps"]['alert'];
        } else {
          _message = message['notification'];
        }

        // print('on_message ${message["aps"]['alert']['title']}');
        // print('on_message ${message["aps"]['alert']['body']}');
        // print('on_message ${message['notification']["title"]}');
        // print('on_message ${message['notification']['body']}');
        showFirebaseMesgDialog(_message, context);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
      debugPrint("firebase_token    ${settings.alert}");
      _firebaseMessaging.getToken().then((token) {
        debugPrint("firebase_token    $token");
        _prefs.setString('fcmtoken', token);
      });
    });
  }

  showFirebaseMesgDialog(message, context) {
    _showDifferentTypeOfDialogs(
        title: message["title"], message: message['body'], context: context);
  }

// void initbatteryInfo() async {
//   Battery _battery = Battery();
//   var batteryLevel = await _battery.batteryLevel;
//   isNotificationSent = await _prefs.getBool('isNotificationSent');
//   if (batteryLevel < 20 &&
//       isNotificationSent != null &&
//       !isNotificationSent) {
//     _prefs.setBool('isNotificationSent', true);
//     sendBatterAlarmToServer();
//   } else if (batteryLevel > 20) {
//     _prefs.setBool('isNotificationSent', false);
//   }
// }
//
// sendBatterAlarmToServer() async {
//   await sendAlarm(
//       prefs.get('userId').toString(), prefs.get('accessToken').toString())
//       .then((response) {
//     print(response.body);
//     if (response.statusCode == 200) {}
//   }).catchError((onError) {});
// }

}
