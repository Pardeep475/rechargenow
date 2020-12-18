import 'dart:async';

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:android_intent/android_intent.dart';
import 'package:battery/battery.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:intercom_flutter/intercom_flutter.dart';
///import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/faq/FAQScreen.dart';
import 'package:recharge_now/app/history/HistoryScreen.dart';
import 'package:recharge_now/app/notification/notification_list_screen.dart';
import 'package:recharge_now/app/paymentscreens/add_payment_method_screen.dart';
import 'package:recharge_now/app/paymentscreens/payment_screen.dart';
import 'package:recharge_now/app/promo/promo_screen.dart';
import 'package:recharge_now/app/scan_bar_qr_code_screen.dart';
import 'package:recharge_now/app/settings/SettingsScreen.dart';
import 'package:recharge_now/auth/intro_screen.dart';
import 'package:recharge_now/auth/login_screen.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/station_list_model.dart';
import 'package:recharge_now/models/user_deatil_model.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:recharge_now/utils/color_list.dart';
import 'package:recharge_now/utils/map_helper.dart';
import 'package:recharge_now/utils/map_marker.dart';
import 'package:recharge_now/utils/my_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:platform/platform.dart';

import 'bottomsheet/home_bottomsheet.dart';
import 'bottomsheet/how_timer_bottomsheet.dart';
import 'chat/ContactScreen.dart';
import 'home_toolbar.dart';
import 'mietstation/StationDetailsMarkerClickScreen.dart';
import 'mietstation/mietstation_list_scren.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController _animateController;
  var isBottomSheetButtonClickable = true;
  var location = new Location();
  var zoomLevel = 16.0;

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 16;

  GoogleMapController mapController;
  LocationData _locationData;
  bool _serviceEnabled = false;
  var showBottomSheet = false;
  var walletAmount = "";
  String result = "Hey there !";
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  /// Color of the cluster circle
  final Color _clusterColor = primaryGreenColor;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  // static Map<String, double> currentLocation;
  LocationData currentLocation;

  SharedPreferences prefs;
  Completer<GoogleMapController> _controller = Completer();

  // LatLng _latlng1 = LatLng(52.520008,13.404954);
  LatLng _latlng1 = LatLng(MyConstants.currentLat, MyConstants.currentLong);

  //static LatLng _latlng1 =  LatLng(28.6221846, 77.3830408);
  //static LatLng _latlng1 =  LatLng(0.0, 0.0);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition;
  bool _saving = false;
  List<MapLocation> maplocationList;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var animateFirstTime = true;
  var showGoogleMap = true;
  var iosLocationFirstTime = true;
  Timer timer;

  @override
  void initState() {
    super.initState();
    initbatteryInfo();
    //init intercom
    initIntercom();

    _animateController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    //get location first time
    /*   this._getLocation().then((value) {
      MyConstants.currentLat = value.latitude;
      MyConstants.currentLong = value.longitude;
      _latlng1 = LatLng(value.latitude, value.longitude);
      print("firstTimelatlong "+_latlng1.toString());


      setState(() {

      });

      */ /* _kGooglePlex = CameraPosition(
        target: LatLng(_latitude, _longitude),
        zoom: 14.4746,
      );*/ /*
    });*/

    /*  _saving=true;
    //Timer.run(() =>  MyUtils.showLoaderDialog(context)());
     Timer(Duration(seconds: 2), () {
       setState(() {
         showGoogleMap=true;
         _saving=false;
         //Navigator.pop(context);
       });
     });*/
    loadShredPref();
    firebaseCloudMessaging_Listeners();
    checkLocationServiceEnableOrDisable();
    // permissionCode();
    getLocationData();
  }

  locationChangeListener() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        print("onLocationChanged " +
            currentLocation.latitude.toString() +
            " : " +
            currentLocation.longitude.toString());
        MyConstants.currentLat = currentLocation.latitude;
        MyConstants.currentLong = currentLocation.longitude;

        _latlng1 = LatLng(MyConstants.currentLat, MyConstants.currentLong);
        _lastMapPosition = _latlng1;
        //code to animate the camera into current location
        if (animateFirstTime) {
          //animateFirstTime = false;
          getStationsOnMapApi();
        }

        setMarker_OnCurrentLocation();
      });
    });
  }

  getLocationData() {
    Geolocator().getCurrentPosition().then((Position position) {
      setState(() {
        Position _currentPosition = position;
        MyConstants.currentLat = _currentPosition.latitude;
        MyConstants.currentLong = _currentPosition.longitude;
        _latlng1 = LatLng(MyConstants.currentLat, MyConstants.currentLong);
        print("currentlocationFirstTime : " + _latlng1.toString());

        _lastMapPosition = _latlng1;
        CameraUpdate cameraUpdate =
            CameraUpdate.newLatLngZoom(_latlng1, zoomLevel);
        mapController.animateCamera(cameraUpdate);
        //  getStationsOnMapApi();
      });
    }).catchError((e) {
      print(e);
    });
  }

  /* permissionCode() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var permission_result =
    await _permissionHandler.requestPermissions([PermissionGroup.location]);
    switch (permission_result[PermissionGroup.location]) {
      case PermissionStatus.granted:
        print("granted");
        // do something
        break;
      case PermissionStatus.denied:
        //permissionCode();
        // do something
        break;
      case PermissionStatus.disabled:
      // do something
        break;
      case PermissionStatus.restricted:
      // do something
        break;

      default:
    }
  }*/
  checkLocationServiceEnableOrDisable() async {
    //  PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    print("serviceEnabled" + _serviceEnabled.toString());
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      _latlng1 = LatLng(MyConstants.currentLat, MyConstants.currentLong);
      _lastMapPosition = _latlng1;
      //code to animate the camera into current location
      getStationsOnMapApi();
    } else if (_serviceEnabled) {
      locationChangeListener();
      _getCurrentLocation();
    }
    print("_serviceEnabled.toString()--- " + _serviceEnabled.toString());

    //_permissionGranted = await location.hasPermission();
    // print('_permissionGranted.toString()>>> '+_permissionGranted.toString());

    /*if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    // var batteryInfromation = Provider.of<BatteryInformation>(context);
    //print("batteryInfromation${batteryInfromation.batteryLevel}");
    return Scaffold(
      key: _drawerKey,
      drawer: drawerUI(),
      body: ModalProgressHUD(
        child: Container(
            child: Stack(
          children: <Widget>[
            mapViewUI(),
            HomeScreenToolbar(
              callBack: (value) {
                if (value == 1) {
                  walletAmount = prefs.get('walletAmount').toString();
                  setState(() {});

                  _drawerKey.currentState.openDrawer();
                } else if (value == 2) {
                  //notification click
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NotificationScreen()));
                }
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: buildTabView(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 183),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[buttonRefreshUI()],
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
                    buttonLocationUI(),
                    buttonDamageUI(),
                  ],
                ),
              ),
            ),
            scannerButtonUI(),
            bottomSheetButtonUi()
          ],
        )),
        inAsyncCall: _saving,
      ),
    );
  }

  var rentalTime;

  getRentalDetailsList() {
    var apicall = getCurrentRentalDetailsApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) {
      isBottomSheetButtonClickable = true;

      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        log("GenRentalDetail${jsonResponse}");
        if (jsonResponse['status'].toString() == "1") {
          var rentalPrice = jsonResponse['rentalDetails']['rentalPrice'];
          rentalTime = jsonResponse['rentalDetails']['rentalTime'];
          _modalBottomSheetMenu(rentalPrice, rentalTime);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else if (jsonResponse['status'].toString() == "0") {
          prefs.setString(
              'walletAmount', jsonResponse['walletAmount'].toString());
          setState(() {
            showBottomSheet = false;
          });
        } else {
          setState(() {
            showBottomSheet = false;
          });
        }
        /*   setState(() {
        });*/
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  bottomSheetButtonUi() {
    return Visibility(
      visible: showBottomSheet,
      maintainAnimation: true,
      maintainState: true,
      child: GestureDetector(
        onTap: () {
          if (isBottomSheetButtonClickable) {
            isBottomSheetButtonClickable = false;
            getRentalDetailsList();
          }
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 38,
              width: 110,
              //margin: EdgeInsets.fromLTRB(20,20,20,0),
              decoration: new BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: Center(
                  child: SizedBox(
                      /*SvgPicture.asset(
                       'assets/images/qr-code.svg',
                     ),)*/
                      child: Transform.rotate(
                angle: 135,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              )))),
        ),
      ),
    );
  }

  appIconUi() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: SizedBox(
        width: 180,
        height: 40,
        child: Container(
          width: 160,
          //height: 30,
          //padding: EdgeInsets.all(20),
          child: Image.asset(
            'assets/images/logo.png',
            //fit: BoxFit.cover,
            /*height: double.infinity,
            width: double.infinity,*/
            /* alignment: Alignment.center,*/
          ),
        ),
      ),
    );
  }

  scannerButtonUI() {
    return GestureDetector(
        onTap: () {
          scanQR();
          //showBottomSheetTimer(context);

          // showBottomSheet2(context);
          // showBottomSheetUI(context);
          //custumAlertDialogBatteryUnlocked(1,context);
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
              ))),
        ));
  }

//TODO: drawerbuttonUI method is used to side navigation
  drawerbuttonUI() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
      //width: 50.0,
      //height: 50.0,
      // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        // You can use like this way or like the below line
        color: Colors.white,
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/images/menu.svg',
        ),
        // size: Size(300.0, 400.0),
        onPressed: () {},
      ), // You can add a Icon instead of text also, like below.
      //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
    );
  }

  buttonStationsUI() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
      //width: 50.0,
      //height: 50.0,
      // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        // You can use like this way or like the below line
        color: Colors.white,
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/images/restaraunts.svg',
        ),
        // size: Size(300.0, 400.0),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => StationListScreen()));
        },
      ), // You can add a Icon instead of text also, like below.
      //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
    );
  }

  buttonLocationUI() {
    return IconButton(
      padding: EdgeInsets.only(left: 20),
      icon: SvgPicture.asset(
        'assets/images/musicIcon.svg',
      ),
      // size: Size(300.0, 400.0),
      onPressed: () async {
          await Intercom.displayMessenger();
        // _currentLocation();
        //_getCurrentLocation();
        //showBottomSheet2(context);
        /* Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => ContactScreen()));*/
        /* Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ContactScreen1()),);*/
      },
      iconSize: 50.0,
    );
  }

  buttonDamageUI() {
    return IconButton(
      padding: EdgeInsets.only(right: 20),
      icon: SvgPicture.asset(
        'assets/images/locator.svg',
      ),
      // size: Size(300.0, 400.0),
      onPressed: () async {
        checkLocationServiceEnableOrDisable();
      },
      iconSize: 50.0,
    );
  }

  buttonRefreshUI() {
    return InkWell(
      onTap: () {
        _animateController.repeat();

        Timer(Duration(seconds: 2), () {
          _animateController.reset();
        });

        getStationsOnMapApi();
        getDetailsApi();
      },
      child: Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        //width: 50.0,
        //height: 50.0,
        // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          // You can use like this way or like the below line
          color: Colors.white,
        ),
        child: Center(
          child: IconButton(
            icon: SizedBox(
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
            // size: Size(300.0, 400.0),
          ),
        ), // You can add a Icon instead of text also, like below.
        //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
      ),
    );
  }

  buildTabView() {
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
          borderRadius: BorderRadius.all(Radius.circular(150))),
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
                        builder: (BuildContext context) =>
                            StationListScreen()));
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
      'List ',
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
      'Map ',
      style: TextStyle(
          fontSize: 11.0,
          height: 1.8,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: Color(0xff231F20)),
    );
  }

  drawerUI() {
    return Drawer(
        child: Container(
            color: color_white,
            width: double.infinity,
            height: double.infinity,
            child: navigationDrawer()));
  }

  Widget navigationDrawer() {
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
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(child: Icon(Icons.clear))),
                      SizedBox(
                        height: 20,
                      ),
                      /*  RichText(
                        text: TextSpan(
                          */ /*style: defaultStyle,
                      text: " The RichText widget allows you to . ",*/ /*
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Hello, ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            TextSpan(
                                text: 'Charger',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: primaryGreenColor))
                          ],
                        ),
                      ),*/
                      /* Text(
                        "Hello, Charger",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),

*/

                      Center(
                        child: SizedBox(
                          height: 40,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.fill,
                            /*height: double.infinity,
            width: double.infinity,*/
                            /* alignment: Alignment.center,*/
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        height: 0.3,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              ListTile(
                contentPadding: EdgeInsets.only(left: 25, right: 10),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('PAYMENT'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset('assets/images/menu-payment.svg'),
                trailing: Text(
                  walletAmount,
                  style: drawerRsStyle,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddPaymentMethodInitialScreen()));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 25, right: 0),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('HISTORY'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset('assets/images/meu-history.svg'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => HistoryScreen()));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 25, right: 0),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('HOW IT WORKS'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset('assets/images/meu-how-it-work.svg'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => HowToWorkScreen(
                            isFromHome: true,
                          )));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 25, right: 0),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    "PROMO - CODE",
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset('assets/images/meni-promo.svg'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => PromoCodeScreen()));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 25, right: 0),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    "FAQ",
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset('assets/images/menu-help.svg'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => FAQScreen()));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 25, right: 0),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('SETTINGS'),
                    style: drawerTitleStyle,
                  ),
                ),
                leading: SvgPicture.asset('assets/images/menu-settings.svg'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => SettingsScreen()));
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

  mapViewUI() {
    return Visibility(
      visible: showGoogleMap,
      child: GoogleMap(
        //onTap: _onAddMarker(),
        mapToolbarEnabled: false,
        rotateGesturesEnabled: true,
        zoomControlsEnabled: false,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _latlng1,
          zoom: _currentZoom,
        ),
        mapType: MapType.normal,
        markers: _markers,
        //onMapCreated: _onMapCreated,
        onMapCreated: (controller) => _onMapCreated(controller),
        //onCameraMove: _onCameraMove,
        onCameraMove: (position) => _updateMarkers(position.zoom),
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
      ),
    );
  }

  setMarker_OnCurrentLocation() async {
    final Uint8List greenMarkerIcon =
        await getBytesFromAsset('assets/images/currentLocatorIcon.png', 120);
    Marker resultMarker = Marker(
      markerId: MarkerId("You"),
      icon: BitmapDescriptor.fromBytes(greenMarkerIcon),
      infoWindow: InfoWindow(title: "You", snippet: ""),
      position: LatLng(_latlng1.latitude, _latlng1.longitude),
    );
    _markers.add(resultMarker);
    setState(() {});
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    //_controller.complete(controller);
    //setState(() {
    mapController = controller;

    ///  });
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers(List<MapLocation> locationList) async {
    _markers.clear();
    final Uint8List blackMarkerIcon =
        await getBytesFromAsset('assets/images/black_marker.png', 120);
    final Uint8List greenMarkerIcon =
        await getBytesFromAsset('assets/images/green_marker.png', 120);
    final List<MapMarker> markers = [];

    for (int i = 0; i < locationList.length; i++) {
      Marker resultMarker = Marker(
        icon: locationList[i].open == true
            ? BitmapDescriptor.fromBytes(greenMarkerIcon)
            : BitmapDescriptor.fromBytes(blackMarkerIcon),
        consumeTapEvents: false,
        onTap: () {
          //_onMarkerClick(locationList[i]);
        },
        markerId: MarkerId(locationList[i].id.toString()),
        infoWindow: InfoWindow(
            onTap: () {
              //          _onMarkerClick(locationList[i]);
            },
            title: "${locationList[i].name}",
            snippet: "${locationList[i].name}"),
        position: LatLng(double.parse(locationList[i].latitude),
            double.parse(locationList[i].longitude)),
      );
      // Marker
      markers.add(
        MapMarker(
            id: locationList[i].id.toString(),
            position: LatLng(double.parse(locationList[i].latitude),
                double.parse(locationList[i].longitude)),
            icon: locationList[i].open == true
                ? BitmapDescriptor.fromBytes(greenMarkerIcon)
                : BitmapDescriptor.fromBytes(blackMarkerIcon),
            data: locationList[i],
            context: context),
      );
      _markers.add(resultMarker);
      setState(() {});
    }
    /*for (LatLng markerLocation in locationList) {
      final BitmapDescriptor markerImage =
      await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
        ),
      );
    }*/

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      //_areMarkersLoading = true;
    });

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

    setState(() {
      //_areMarkersLoading = false;
    });
  }

  Future<void> scanQR() async {
    var qrResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ScanQrBarCodeScreen()));
    if (qrResult != null && qrResult != "" && qrResult != "-1") {
      rentBattery_PowerbankAPI(
          prefs.get('userId').toString(), qrResult.toString());
    }

    /*String qrResult;
    // Platform messages may fail, so we use a try/catch PlatformException.


    try {
      qrResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print("ff6666$qrResult");



    } on PlatformException {
      qrResult = 'Failed to get platform version.';
    }*/
  }

  _getCurrentLocation() {
    // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    // if(_latlng1.latitude=="52.520008"){
    if (LocalPlatform().isIOS) {
      if (iosLocationFirstTime) {
        Geolocator().getCurrentPosition().then((Position position) {
          setState(() {
            Position _currentPosition = position;
            MyConstants.currentLat = _currentPosition.latitude;
            MyConstants.currentLong = _currentPosition.longitude;
            iosLocationFirstTime = false;

            _latlng1 = LatLng(MyConstants.currentLat, MyConstants.currentLong);
            // print("currentlocationbuttonClick : "+_latlng1.toString());
            CameraUpdate cameraUpdate =
                CameraUpdate.newLatLngZoom(_latlng1, zoomLevel);
            mapController.animateCamera(cameraUpdate);
          });
        }).catchError((e) {
          print(e);
        });
      } else {
        CameraUpdate cameraUpdate =
            CameraUpdate.newLatLngZoom(_latlng1, zoomLevel);
        mapController.animateCamera(cameraUpdate);
      }
    } else {
      CameraUpdate cameraUpdate =
          CameraUpdate.newLatLngZoom(_latlng1, zoomLevel);
      mapController.animateCamera(cameraUpdate);
    }
  }

  initIntercom() async {
     await Intercom.initialize('nait0fkp',
        iosApiKey: 'ios_sdk-4a6b5dbb9308a9ce3a9f8879b85d20753d28bf1d',
        androidApiKey: 'android_sdk-105de09284d5c5ca5aa918e21f02cc744407fc32');
    Intercom.registerUnidentifiedUser();  // <<< add this
  }

  void _modalBottomSheetMenu(rentalPrice, rentalTime) {
    showModalBottomSheet(
        /* shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),*/
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
                            topRight: const Radius.circular(10.0))),
                    child: Center(
                        child: SizedBox(
                            child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    )))),
              ),
              HomeTimerBottomSheeet(
                rentalPrice: rentalPrice,
                rentalTime: rentalTime,
                walletAmount: walletAmount,
              )
            ],
          );
        });
  }

  custumAlertDialogBatteryUnlocked(slotNumber, context) {}

  custumAlertDialogAddPaymentMethod() {
    Dialog myDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
        height: 350.0,
        // width: 600.0,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                  alignment: Alignment.topRight, child: Icon(Icons.clear)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/wallet-euro.svg',
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate("Check your payment methods"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    AppLocalizations.of(context).translate(
                        "Please add a payment method to confirm your account"),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  creditCardButtonUI(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => myDialog);
  }

  creditCardButtonUI() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Payments()));
        },
        child: new Container(
            height: 45,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            // padding: const EdgeInsets.all(3.0),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: new BoxDecoration(
              //color: Colors.green,
              border: Border.all(color: Colors.black12),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(
                        'assets/images/menu-payment.svg',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                          AppLocalizations.of(context).translate("Add Payment"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          textDirection: TextDirection.ltr),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    height: 24,
                    width: 30,
                    /* child: SvgPicture.asset(
                      'assets/images/heart.svg',
                    ),*/
                    child: Icon(
                      Icons.chevron_right,
                      // size: screenAwareSize(20.0, context),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )));
  }

  void custumBottomSheetMarkerClick(MapLocation data, context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) {
          return Container(
            height: 290.0,
            child: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                    //padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15.0),
                          topRight: const Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.clear)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(8, 20, 8, 8),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(data.name.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(data.category.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: primaryGreenColor,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(data.address.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 14)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 15,
                                                    height: 15,
                                                    child: SvgPicture.asset(
                                                      'assets/images/placeholder.svg',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(data.distance.toString(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                    'assets/images/battery-powerbank.svg',
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      data.availablePowerbanks
                                                              .toString() +
                                                          " " +
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  "Available"),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  SvgPicture.asset(
                                                    'assets/images/Star.svg',
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      data.freeSlots
                                                              .toString() +
                                                          " " +
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  "Free"),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  // mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    /*navigateButton(data),

                      markerDetailsButton(data),*/
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          onStartNavigationClicked(data);
                                        },
                                        child: Container(
                                          height: 45,
                                          decoration: new BoxDecoration(
                                            border: new Border.all(
                                                width: .5, color: Colors.grey),
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(30.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: new Text(
                                                AppLocalizations.of(context)
                                                    .translate("Navigate"),
                                                style: new TextStyle(
                                                    color: Colors.black,
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      StationDetailsMarkerClickScreen(
                                                          nearbyLocation:
                                                              data)));
                                        },
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            color: primaryGreenColor,
                                            /* border: new Border.all(
                          width: .5,
                          color:Colors.grey),*/
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(30.0),
                                            ),
                                          ),
                                          height: 45,
                                          child: Center(
                                            child: new Text(
                                                AppLocalizations.of(context)
                                                    .translate("Details"),
                                                style: new TextStyle(
                                                    color: Colors.white,
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),

                //center logo code
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    //margin: EdgeInsets.only(top: 200),
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                        // side: BorderSide(width: 1, color: Colors.grey)
                      ),
                      child: Container(
                        //color: primaryGreenColor,
                        //margin: EdgeInsets.fromLTRB(20,0,0,0),
                        width: 90.0,
                        height: 90.0,
                        // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height

                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    data.imageFullPath.toString())))
                        /*child: IconButton(
                     icon:  Image.network(IMAGE_BASE_URL+data.imageAvatarPath.toString()
                       //,fit: BoxFit.cover,
                     ),
                     // size: Size(300.0, 400.0),
                     onPressed: () {

                     },
                   )*/
                        , // You can add a Icon instead of text also, like below.
                        //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                      ),
                    ),
                  ), /*Container(
                 color: primaryGreenColor,
                 //padding: EdgeInsets.all(10),
                 child: SizedBox(
                     width: 80,
                     height: 80,
                     child:  Image.asset("assets/images/logo.png"))*/ /*Image.network(IMAGE_BASE_URL+data.imageAvatarPath))*/ /*

               */ /*Image.network(
                                            MyConstants.SERVICE_IMAGE+datum.image,
                                            width: 60,
                                            height: 60,
                                            fit:BoxFit.fill )*/ /*
             )*/
                ),
              ],
            ),
          );
        });
  }

  custumAlertDialogMarkerClick1(MapLocation data, context) {
    Dialog myDialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //this right here
        child: Container(
            margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
            //padding: EdgeInsets.all(8),
            height: 185.0,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                      alignment: Alignment.topRight, child: Icon(Icons.clear)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            //padding: EdgeInsets.all(10),
                            child: SizedBox(
                                width: 45,
                                height: 45,
                                child: Image.network(IMAGE_BASE_URL +
                                    data.imageFullPath.toString()))
                            /*Image.network(
                                      MyConstants.SERVICE_IMAGE+datum.image,
                                      width: 60,
                                      height: 60,
                                      fit:BoxFit.fill )*/
                            ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(data.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(data.category,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: primaryGreenColor,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(data.address,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: SvgPicture.asset(
                                            'assets/images/placeholder.svg',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(data.distance.toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/images/battery-powerbank.svg',
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                            data.availablePowerbanks
                                                    .toString() +
                                                " Available",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/images/Star.svg',
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                            data.freeSlots.toString() + " Free",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: new EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          /*navigateButton(data),

                markerDetailsButton(data),*/
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                onStartNavigationClicked(data);
                              },
                              child: Container(
                                height: 45,
                                decoration: new BoxDecoration(
                                  border: new Border.all(
                                      width: .5, color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  ),
                                ),
                                child: Center(
                                  child: new Text("Navigate",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            StationDetailsMarkerClickScreen(
                                                nearbyLocation: data)));
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: primaryGreenColor,
                                  /* border: new Border.all(
                    width: .5,
                    color:Colors.grey),*/
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  ),
                                ),
                                height: 45,
                                child: Center(
                                  child: new Text("Details",
                                      style: new TextStyle(
                                          color: Colors.white,
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*    SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                   Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 45,
                    decoration: new BoxDecoration(

                      border: new Border.all(
                          width: .5,
                          color: Colors.grey),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    child: Center(
                      child: new Text("Cancel",
                          style: new TextStyle(
                              color:
                              Colors.black,
                              //fontWeight: FontWeight.bold,
                              fontSize: 14.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
*/
                  ],
                ),
              ],
            )));
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => myDialog);
  }

  closeButtonUnlockbattery() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        getRentalDetailsList();
      },
      child: Container(
        // margin: new EdgeInsets.fromLTRB(0,0,0,0),
        height: 45,
        width: 250,
        child: new Center(
          child: new Text('Ok',
              style: new TextStyle(
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold)),
        ),

        decoration: new BoxDecoration(
          color: primaryGreenColor,
          /* border: new Border.all(
              width: .5,
              color:Colors.grey),*/
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
      ),
    );
  }

  closeButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        // margin: new EdgeInsets.fromLTRB(0,0,0,0),
        height: 45,
        width: 250,
        child: new Center(
          child: new Text('Ok',
              style: new TextStyle(
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold)),
        ),

        decoration: new BoxDecoration(
          color: primaryGreenColor,
          /* border: new Border.all(
              width: .5,
              color:Colors.grey),*/
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
      ),
    );
  }

  navigateButton(MapLocation data) {
    return GestureDetector(
      onTap: () {
        onStartNavigationClicked(data);
      },
      child: Expanded(
        child: Container(
          //padding: new EdgeInsets.fromLTRB(35,15,35,15),
          height: 45,
          width: MediaQuery.of(context).size.width,

          decoration: new BoxDecoration(
            border: new Border.all(width: .5, color: Colors.grey),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),

          child: new Center(
            child: new Text("Navigate",
                style: new TextStyle(
                    color: Colors.black,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  markerDetailsButton(MapLocation data) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                StationDetailsMarkerClickScreen(nearbyLocation: data)));
      },
      child: Expanded(
        child: Container(
          //padding: new EdgeInsets.fromLTRB(35,15,35,15),
          /* height: 45,
          width: 100,*/
          child: new Center(
            child: new Text("Details",
                style: new TextStyle(
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold)),
          ),

          decoration: new BoxDecoration(
            color: primaryGreenColor,
            /* border: new Border.all(
                width: .5,
                color:Colors.grey),*/
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
        ),
      ),
    );
  }

  rentBattery_PowerbankAPI(userId, deviceId) {
    /* setState(() {
      _saving = true;
    });*/
    MyUtils.showLoaderDialog(context);
    var req = {"userId": userId, "deviceId": deviceId};

    print(req);
    var jsonReqString = json.encode(req);
    var apicall;
    apicall = rentBattery_PowerbankApi(
        jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        /* setState(() {
          _saving = false;
        });*/
        Navigator.pop(context);
        final jsonResponse = json.decode(response.body);

        //MyUtils.showAlertDialog(jsonResponse['message'].toString());

        if (jsonResponse['status'].toString() == "1") {
          setState(() {
            showBottomSheet = true;
          });
          //  custumAlertDialogBatteryUnlocked(jsonResponse['slotNumber'], context);
        } else if (jsonResponse['status'].toString() == "0") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else if (jsonResponse['status'].toString() == "3") {
          custumAlertDialogAddPaymentMethod();
        } else if (jsonResponse['status'].toString() == "4") {
          MyUtils.showRentalRefusedDialog(
              jsonResponse['message'].toString(), context);
        }
      } else {
        /*setState(() {
          _saving = false;
        });*/
        Navigator.pop(context);
        //MyUtils.showAlertDialog(AllString.something_went_wrong);
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
      /*setState(() {
        _saving = false;
      });*/
      Navigator.pop(context);
      MyUtils.showAlertDialog(AllString.something_went_wrong, context);
    });
  }

  bool isNotificationSent = false;

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => getStationsOnMapApi());
    walletAmount = await prefs.get('walletAmount').toString();
    isNotificationSent = await prefs.getBool('isNotificationSent');
    print(prefs.get('accessToken').toString());
    if (prefs.get("isRental") == true) {
      showBottomSheet = true;
      setState(() {});
    }
    getDetailsApi();
    getStationsOnMapApi();
    getRentalDetailsList();
  }

  navigateToLoginScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  getStationsOnMapApi() {
    var betteryAlarm = prefs.getBool('betteryAlarm');
    if (betteryAlarm != null && betteryAlarm) {
      initbatteryInfo();
    }
    var req = {
      "latitude": MyConstants.currentLat.toString(),
      "longitude": MyConstants.currentLong.toString()
      /*"latitude": "30.7320822",
      "longitude": "76.76264739999999"*/
    };
    var jsonReqString = json.encode(req);
    print("accesstoken " + prefs.get('accessToken').toString());

    print(jsonReqString);

    var apicall =
        getMapLocationsApi(jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      debugPrint('status_12345 ---->     ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse.toString());

        if (jsonResponse['status'] == 0 &&
            jsonResponse['message'].compareTo('ILLEGAL_ACCESS') == 0) {
          debugPrint('status_12345 ---->     ${jsonResponse['status']}');
          prefs.setBool('is_login', false);
          navigateToLoginScreen();
        }

        StationsListPojo stationsListPojo =
            StationsListPojo.fromJson(jsonResponse);
        debugPrint('status_12345 ---->     ${stationsListPojo.status}');
        debugPrint('status_12345 ---->     ${stationsListPojo.message}');
        if (stationsListPojo.status == 0 &&
            stationsListPojo.message.compareTo('ILLEGAL_ACCESS') == 0) {
          debugPrint('status_12345 ---->     ${stationsListPojo.message}');
          prefs.setBool('is_login', false);
          navigateToLoginScreen();
        } else {
          maplocationList = [];
          maplocationList = stationsListPojo.mapLocations;
          if (maplocationList.length == 0) {
            /*   var json = {
              "message": "Success",
              "mapLocations": [
                {
                  "id": 1,
                  "name": "LocationA",
                  "address":
                  "Capital O 10540 Hotel JD Residency, Shahi Majra, Industrial Area, Sector 58, Sahibzada Ajit Singh Nagar, Punjab, India",
                  "category": "Restaurant",
                  "onlineStations": 0,
                  "distance": "1.54 KM",
                  "latitude": "29.907420799",
                  "longitude": "77.9096036",
                  "description": "This is the setails for location",
                  "mondayHours": "10:00 - 22:00",
                  "tuesdayHours": "10:00 - 22:00",
                  "wednesdayHours": "10:00 - 22:00",
                  "thursdayHours": "10:00 - 22:00",
                  "fridayHours": "10:00 - 22:00",
                  "saturdayHours": "10:00 - 22:00",
                  "sundayHours": "10:00 - 22:00",
                  "mondayClosed": false,
                  "tuesdayClosed": false,
                  "wednesdayClosed": false,
                  "thursdayClosed": false,
                  "fridayClosed": false,
                  "saturdayClosed": false,
                  "sundayClosed": true,
                  "availablePowerbanks": 21,
                  "freeSlots": 3,
                  "imagePath": "/uploadedFiles/locations/Home.jpg",
                  "thumbnailPath": "/uploadedFiles/locations/HomeA.jpg",
                  "open": false
                },
                {
                  "id": 1,
                  "name": "LocationA",
                  "address":
                  "Capital O 10540 Hotel JD Residency, Shahi Majra, Industrial Area, Sector 58, Sahibzada Ajit Singh Nagar, Punjab, India",
                  "category": "Restaurant",
                  "onlineStations": 0,
                  "distance": "1.54 KM",
                  "latitude": "29.907420799",
                  "longitude": "77.9096036",
                  "description": "This is the setails for location",
                  "mondayHours": "10:00 - 22:00",
                  "tuesdayHours": "10:00 - 22:00",
                  "wednesdayHours": "10:00 - 22:00",
                  "thursdayHours": "10:00 - 22:00",
                  "fridayHours": "10:00 - 22:00",
                  "saturdayHours": "10:00 - 22:00",
                  "sundayHours": "10:00 - 22:00",
                  "mondayClosed": false,
                  "tuesdayClosed": false,
                  "wednesdayClosed": false,
                  "thursdayClosed": false,
                  "fridayClosed": false,
                  "saturdayClosed": false,
                  "sundayClosed": true,
                  "availablePowerbanks": 21,
                  "freeSlots": 3,
                  "imagePath": "/uploadedFiles/locations/Home.jpg",
                  "thumbnailPath": "/uploadedFiles/locations/HomeA.jpg",
                  "open": false
                },
              ],
              "status": 1
            };
            StationsListPojo stationsListPojo2 =
            StationsListPojo.fromJson(json);
            maplocationList.addAll(stationsListPojo2.mapLocations);*/
          }
          debugPrint('stationsListPojo2 ---->     ${maplocationList.length}');
          // _onAddMarker(maplocationList);
          _initMarkers(maplocationList);
          if (animateFirstTime) {
            CameraUpdate cameraUpdate =
                CameraUpdate.newLatLngZoom(_latlng1, zoomLevel);
            mapController.animateCamera(cameraUpdate);
            animateFirstTime = false;
          }
          setState(() {});
        }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  getDetailsApi() {
    /* setState(() {
      _saving = true;
    });*/
    var apicall = getUserDetailsApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        /* setState(() {
          _saving = false;
        });*/
        // final jsonResponse = json.decode(response.body);
        /*      final jsonResponse = {
          "status":1,
          "message":"Success",
          "userDetails":{
            "id":2,
            "usercodeUsed":false,
            "deleted":false,
            "countryCode":"+91",
            "phoneNumber":"9756264795",
            "usercode": "FTQ0CL",
            "accessToken": "h0KJ8ZLKaEkQabgzFl1B/Q==",
            "createdOn":"Sun Jan 26 11:32:10 IST 2020",
            "walletAmount":0,
            "contactMethod":"PhoneNumber",
            "authyId":"218899105"
          }
        };*/
        //print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+jsonResponse.toString());
        final jsonResponse = json.decode(response.body);
        UserDetailsPojo userDetailsPojo =
            UserDetailsPojo.fromJson(jsonResponse);
        UserDetails userdetails = userDetailsPojo.userDetails;

        //  prefs.setString('walletAmount', ""+userdetails.walletAmount);
        // prefs.setBool('is_login', true);
        // prefs.setInt('userId', userdetails.id);
        // prefs.setString('accessToken', jsonResponse['userDetails']['accessToken']);
        //prefs.setString('usercode', jsonResponse['userDetails']['usercode']);
        prefs.setString('walletAmount', userdetails.walletAmount.toString());
        prefs.setBool('isRental', userDetailsPojo.isRental);

        setState(() {});
      } else {
        /*setState(() {
          _saving = false;
        });*/
        //final jsonResponse = json.decode(response.body);
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
      /* setState(() {
        _saving = false;
      });*/
    });
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

  void onMarkerClick(MapLocation data, BuildContext context) {
    //
    showBottomSheet2(context, data);
    //custumBottomSheetMarkerClick(data, context);
    //custumAlertDialogMarkerClick1(data,context);
    /* Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => OfferListScreen(offerDataList:data,distance:data.distance,latitude:data.latitude,longitude:data.longitude)));
    */
  }

  onStartNavigationClicked(MapLocation data) async {
    String origin = "" +
        MyConstants.currentLat.toString() +
        "," +
        MyConstants.currentLong.toString(); // lat,long like 123.34,68.56

    print(origin);
    String destination = data.latitude + "," + data.longitude;
    if (new LocalPlatform().isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data:
              Uri.encodeFull("https://www.google.com/maps/dir/?api=1&origin=" +
                  /* origin +*/ "&destination=" +
                  destination +
                  "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    } else {
      String url =
          "https://www.google.com/maps/dir/?api=1&origin=" /*+ origin */ +
              "&destination=" +
              destination +
              "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.subscribeToTopic('flutter');
    if (LocalPlatform().isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("fcmtoken:" + token);
       Intercom.sendTokenToIntercom(token);

      var fcmtoken = token;
      prefs.setString('fcmtoken', token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        var _message;
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          _message = message['aps']['alert'];
        } else {
          _message = message['notification'];
        }

        //showDialogForNotificiation_forground(_message);
        showFirebaseMesgDialog(_message, context);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        // if(message['notification']['title']=="test"){
        /*Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => SubPage()));*/
        //  }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  showDialogForNotificiation_forground(message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message['notification']['title']),
          subtitle: Text(message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            color: primaryGreenColor,
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  showFirebaseMesgDialog(message, context) {
    Dialog myDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: message['title'] == "POWERBANK ZURCKGEGEBEN" ? 480 : 350.0,
        // width: 600.0,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: message['title'] == "POWERBANK ZURCKGEGEBEN"
                  ? SizedBox(
                      width: 200,
                      height: 250,
                      child: Image.asset(
                        'assets/images/return_powerbank.png',
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/images/battery-unlocked.svg',
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              message['title'],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message['body'],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            closeButton()
          ],
        ),
      ),
    );
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => myDialog);
  }

  Future<LocationData> _getLocation() async {
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
    return currentLocation;
  }

  void showBottomSheetTimer(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return HomeTimerBottomSheeet();
        });
  }

  void showBottomSheet2(BuildContext context, MapLocation data) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          var filePath = "assets/images/slot6station.png";
          var isLongImage = false;
          switch (data.freeSlots) {
            case 6:
              filePath = "assets/images/slot6station.png";
              isLongImage = false;
              break;
            case 8:
              filePath = "assets/images/slot8station.png";
              isLongImage = false;
              break;
            case 12:
              filePath = "assets/images/slot8station.png";
              isLongImage = false;
              break;
            case 24:
              filePath = "assets/images/stationtower.png";
              isLongImage = true;
              break;
            case 48:
              filePath = "assets/images/panelstation.png";
              isLongImage = true;
              break;
          }

          return BottomSheetWidget(
            data,
            slotTypeFilePath: filePath,
            isLongImage: isLongImage,
          );
        });
  }

  @override
  void dispose() {
    timer?.cancel();
    _animateController.dispose();

    super.dispose();
  }

  void initbatteryInfo() async {
    Battery _battery = Battery();
    var batteryLevel = await _battery.batteryLevel;
    print("batteryLevel$batteryLevel");
    isNotificationSent = await prefs.getBool('isNotificationSent');
    if (batteryLevel < 20 &&
        isNotificationSent != null &&
        !isNotificationSent) {
      prefs.setBool('isNotificationSent', true);
      sendBatterAlarmToServer();
    } else if (batteryLevel > 20) {
      prefs.setBool('isNotificationSent', false);
    }
  }

  sendBatterAlarmToServer() {
    var apicall = sendAlarm(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) async {
      print(response.body);
      if (response.statusCode == 200) {}
    }).catchError((error) {
      print('error : $error');
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('primaryGreenColor', primaryGreenColor));
  }
}
