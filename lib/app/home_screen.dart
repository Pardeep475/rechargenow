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
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/faq/FAQScreen.dart';
import 'package:recharge_now/app/history/HistoryScreen.dart';
import 'package:recharge_now/app/notification/notification_list_screen.dart';
import 'package:recharge_now/app/paymentscreens/add_payment_method_screen.dart';
import 'package:recharge_now/app/promo/promo_screen.dart';
import 'package:recharge_now/app/scan_bar_qr_code_screen.dart';
import 'package:recharge_now/app/settings/SettingsScreen.dart';
import 'package:recharge_now/auth/intro_screen.dart';
import 'package:recharge_now/auth/login_screen.dart';
import 'package:recharge_now/common/CustomDialogBox.dart';
import 'package:recharge_now/common/custom_widgets/ItemSlotEightStation.dart';
import 'package:recharge_now/common/custom_widgets/common_error_dialog.dart';
import 'package:recharge_now/common/custom_widgets/item_pannel_station.dart';
import 'package:recharge_now/common/custom_widgets/item_slot_six_station.dart';
import 'package:recharge_now/common/custom_widgets/item_station_tower.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/station_list_model.dart';
import 'package:recharge_now/models/user_deatil_model.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/app_colors.dart';
import 'package:recharge_now/utils/color_list.dart';
import 'package:recharge_now/utils/map_helper.dart';
import 'package:recharge_now/utils/map_marker.dart';
import 'package:recharge_now/utils/my_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:platform/platform.dart';
import 'bottomsheet/how_timer_bottomsheet.dart';
import 'home_toolbar.dart';
import 'mietstation/StationDetailsMarkerClickScreen.dart';
import 'mietstation/mietstation_detail.dart';
import 'mietstation/mietstation_list_scren.dart';
import 'mietstation/near_by_stationlist_item.dart';

class HomeScreen extends StatefulWidget {
  final bool isLocationOn;

  HomeScreen({this.isLocationOn});

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

    loadShredPref();
    firebaseCloudMessaging_Listeners();
    if (widget.isLocationOn != null) {
      if (widget.isLocationOn) {
        getStationsOnMapApi();
      } else {
        checkLocationServiceEnableOrDisable();
        getLocationData();
      }
    } else {
      checkLocationServiceEnableOrDisable();
      getLocationData();
    }
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
        prefs.setDouble("lat", _locationData.latitude);
        prefs.setDouble("long", _locationData.longitude);

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

  getLocationData() async {
    await Geolocator().getCurrentPosition().then((Position position) {
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

  checkLocationServiceEnableOrDisable() async {
    _serviceEnabled = await location.serviceEnabled();
    print("serviceEnabledLocation" + _serviceEnabled.toString());
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      _latlng1 = LatLng(MyConstants.currentLat, MyConstants.currentLong);
      _lastMapPosition = _latlng1;
      getStationsOnMapApi();
    } else if (_serviceEnabled) {
      // locationChangeListener();
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          debugPrint("rentBattery_PowerbankAPI   getRentalDetailsList   2");
          _showDifferentTypeOfDialogs(
              jsonResponse['message'].toString(), context);
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
      } else {
        debugPrint("rentBattery_PowerbankAPI   else");
        _showDifferentTypeOfDialogs("SOMETHING_WRONG", context);
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

          // var rentalPrice = "30";
          // rentalTime = "01:07:40";
          // walletAmount = "40";
          // _modalBottomSheetMenu(rentalPrice, rentalTime);
          // debugPrint(
          //     "HomeTimerBottomSheeet     Rental Price  $rentalPrice    Rental Time  $rentalTime  Wallet Amount   $walletAmount");
          // HomeTimerBottomSheeet(
          //   rentalPrice: rentalPrice,
          //   rentalTime: rentalTime,
          //   walletAmount: walletAmount,
          // );
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
                          child: Container(child: Icon(Icons.clear))),
                      SizedBox(
                        height: Dimens.twentyFive,
                      ),
                      Center(
                        child: SizedBox(
                          height: Dimens.fifty,
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
                  walletAmount,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF54DF6C),
                      fontSize: Dimens.fifteen,
                      height: 1.2),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddPaymentMethodInitialScreen()));
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
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => HistoryScreen()));
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
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => HowToWorkScreen(
                            isFromHome: true,
                          )));
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
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => PromoCodeScreen()));
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
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => FAQScreen()));
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
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanQrBarCodeScreen()),
    ).then((qrResult) {
      debugPrint("barcode_is_scanner_result   $qrResult");
      if (qrResult != null && qrResult != "" && qrResult != "-1") {
        rentBattery_PowerbankAPI(
            prefs.get('userId').toString(), qrResult.toString());
      }
    });
  }

  _getCurrentLocation() async {
    if (LocalPlatform().isIOS) {
      if (iosLocationFirstTime) {
        await Geolocator().getCurrentPosition().then((Position position) {
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
    Intercom.registerUnidentifiedUser(); // <<< add this
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

  // custumAlertDialogBatteryUnlocked(slotNumber, context) {}

  // void custumBottomSheetMarkerClick(MapLocation data, context) {
  //   showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       builder: (builder) {
  //         return Container(
  //           height: 290.0,
  //           child: Stack(
  //             children: <Widget>[
  //               Container(
  //                   margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
  //                   //padding: EdgeInsets.all(8),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: const Radius.circular(15.0),
  //                         topRight: const Radius.circular(15.0)),
  //                     boxShadow: [
  //                       BoxShadow(color: Colors.black12, blurRadius: 5)
  //                     ],
  //                   ),
  //                   child: Container(
  //                     margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
  //                     child: Stack(
  //                       children: <Widget>[
  //                         GestureDetector(
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: Align(
  //                               alignment: Alignment.topRight,
  //                               child: Icon(Icons.clear)),
  //                         ),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: <Widget>[
  //                             Row(
  //                               mainAxisSize: MainAxisSize.max,
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: <Widget>[
  //                                 Flexible(
  //                                   child: Container(
  //                                     margin: EdgeInsets.fromLTRB(8, 20, 8, 8),
  //                                     padding: EdgeInsets.all(8),
  //                                     child: Column(
  //                                       mainAxisSize: MainAxisSize.max,
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: <Widget>[
  //                                         Text(data.name.toString(),
  //                                             overflow: TextOverflow.ellipsis,
  //                                             maxLines: 1,
  //                                             style: TextStyle(
  //                                                 fontSize: 16,
  //                                                 fontWeight: FontWeight.bold)),
  //                                         SizedBox(
  //                                           height: 5,
  //                                         ),
  //                                         Text(data.category.toString(),
  //                                             overflow: TextOverflow.ellipsis,
  //                                             maxLines: 1,
  //                                             style: TextStyle(
  //                                                 fontSize: 14,
  //                                                 color: primaryGreenColor,
  //                                                 fontWeight: FontWeight.bold)),
  //                                         SizedBox(
  //                                           height: 10,
  //                                         ),
  //                                         Text(data.address.toString(),
  //                                             overflow: TextOverflow.ellipsis,
  //                                             maxLines: 1,
  //                                             style: TextStyle(fontSize: 14)),
  //                                         SizedBox(
  //                                           height: 10,
  //                                         ),
  //                                         Row(
  //                                           mainAxisSize: MainAxisSize.max,
  //                                           //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                           children: <Widget>[
  //                                             Row(
  //                                               children: <Widget>[
  //                                                 SizedBox(
  //                                                   width: 15,
  //                                                   height: 15,
  //                                                   child: SvgPicture.asset(
  //                                                     'assets/images/placeholder.svg',
  //                                                   ),
  //                                                 ),
  //                                                 SizedBox(
  //                                                   width: 5,
  //                                                 ),
  //                                                 Text(data.distance.toString(),
  //                                                     style: TextStyle(
  //                                                         fontSize: 10,
  //                                                         color: Colors.black,
  //                                                         fontWeight:
  //                                                             FontWeight.bold))
  //                                               ],
  //                                             ),
  //                                             SizedBox(
  //                                               width: 20,
  //                                             ),
  //                                             Row(
  //                                               children: <Widget>[
  //                                                 SvgPicture.asset(
  //                                                   'assets/images/battery-powerbank.svg',
  //                                                 ),
  //                                                 SizedBox(
  //                                                   width: 5,
  //                                                 ),
  //                                                 Text(
  //                                                     data.availablePowerbanks
  //                                                             .toString() +
  //                                                         " " +
  //                                                         AppLocalizations.of(
  //                                                                 context)
  //                                                             .translate(
  //                                                                 "Available"),
  //                                                     style: TextStyle(
  //                                                         fontSize: 10,
  //                                                         color: Colors.black,
  //                                                         fontWeight:
  //                                                             FontWeight.bold))
  //                                               ],
  //                                             ),
  //                                             SizedBox(
  //                                               width: 20,
  //                                             ),
  //                                             Row(
  //                                               children: <Widget>[
  //                                                 SvgPicture.asset(
  //                                                   'assets/images/Star.svg',
  //                                                 ),
  //                                                 SizedBox(
  //                                                   width: 5,
  //                                                 ),
  //                                                 Text(
  //                                                     data.freeSlots
  //                                                             .toString() +
  //                                                         " " +
  //                                                         AppLocalizations.of(
  //                                                                 context)
  //                                                             .translate(
  //                                                                 "Free"),
  //                                                     style: TextStyle(
  //                                                         fontSize: 10,
  //                                                         color: Colors.black,
  //                                                         fontWeight:
  //                                                             FontWeight.bold))
  //                                               ],
  //                                             )
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               height: 10,
  //                             ),
  //                             Container(
  //                               margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
  //                               child: Row(
  //                                 // mainAxisSize: MainAxisSize.max,
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: <Widget>[
  //                                   /*navigateButton(data),
  //
  //                     markerDetailsButton(data),*/
  //                                   Expanded(
  //                                     child: GestureDetector(
  //                                       onTap: () {
  //                                         Navigator.of(context).pop();
  //                                         onStartNavigationClicked(data);
  //                                       },
  //                                       child: Container(
  //                                         height: 45,
  //                                         decoration: new BoxDecoration(
  //                                           border: new Border.all(
  //                                               width: .5, color: Colors.grey),
  //                                           borderRadius:
  //                                               const BorderRadius.all(
  //                                             const Radius.circular(30.0),
  //                                           ),
  //                                         ),
  //                                         child: Center(
  //                                           child: new Text(
  //                                               AppLocalizations.of(context)
  //                                                   .translate("Navigate"),
  //                                               style: new TextStyle(
  //                                                   color: Colors.black,
  //                                                   //fontWeight: FontWeight.bold,
  //                                                   fontSize: 14.0,
  //                                                   fontWeight:
  //                                                       FontWeight.bold)),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     width: 10,
  //                                   ),
  //                                   Expanded(
  //                                     child: GestureDetector(
  //                                       onTap: () {
  //                                         Navigator.of(context).pop();
  //                                         Navigator.of(context).push(
  //                                             new MaterialPageRoute(
  //                                                 builder: (BuildContext
  //                                                         context) =>
  //                                                     StationDetailsMarkerClickScreen(
  //                                                         nearbyLocation:
  //                                                             data)));
  //                                       },
  //                                       child: Container(
  //                                         decoration: new BoxDecoration(
  //                                           color: primaryGreenColor,
  //                                           /* border: new Border.all(
  //                         width: .5,
  //                         color:Colors.grey),*/
  //                                           borderRadius:
  //                                               const BorderRadius.all(
  //                                             const Radius.circular(30.0),
  //                                           ),
  //                                         ),
  //                                         height: 45,
  //                                         child: Center(
  //                                           child: new Text(
  //                                               AppLocalizations.of(context)
  //                                                   .translate("Details"),
  //                                               style: new TextStyle(
  //                                                   color: Colors.white,
  //                                                   //fontWeight: FontWeight.bold,
  //                                                   fontSize: 14.0,
  //                                                   fontWeight:
  //                                                       FontWeight.bold)),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   )),
  //
  //               //center logo code
  //               Align(
  //                 alignment: Alignment.topCenter,
  //                 child: Container(
  //                   //margin: EdgeInsets.only(top: 200),
  //                   padding: EdgeInsets.all(10),
  //                   child: Card(
  //                     elevation: 5,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.all(Radius.circular(45)),
  //                       // side: BorderSide(width: 1, color: Colors.grey)
  //                     ),
  //                     child: Container(
  //                       //color: primaryGreenColor,
  //                       //margin: EdgeInsets.fromLTRB(20,0,0,0),
  //                       width: 90.0,
  //                       height: 90.0,
  //                       // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
  //
  //                       decoration: new BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           image: new DecorationImage(
  //                               fit: BoxFit.fill,
  //                               image: new NetworkImage(
  //                                   data.imageFullPath.toString())))
  //                       /*child: IconButton(
  //                    icon:  Image.network(IMAGE_BASE_URL+data.imageAvatarPath.toString()
  //                      //,fit: BoxFit.cover,
  //                    ),
  //                    // size: Size(300.0, 400.0),
  //                    onPressed: () {
  //
  //                    },
  //                  )*/
  //                       , // You can add a Icon instead of text also, like below.
  //                       //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
  //                     ),
  //                   ),
  //                 ), /*Container(
  //                color: primaryGreenColor,
  //                //padding: EdgeInsets.all(10),
  //                child: SizedBox(
  //                    width: 80,
  //                    height: 80,
  //                    child:  Image.asset("assets/images/logo.png"))*/ /*Image.network(IMAGE_BASE_URL+data.imageAvatarPath))*/ /*
  //
  //              */ /*Image.network(
  //                                           MyConstants.SERVICE_IMAGE+datum.image,
  //                                           width: 60,
  //                                           height: 60,
  //                                           fit:BoxFit.fill )*/ /*
  //            )*/
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  rentBattery_PowerbankAPI(userId, deviceId) async {
    MyUtils.showLoaderDialog(context);
    var req = {"userId": userId, "deviceId": deviceId};
    var jsonReqString = json.encode(req);
    await rentBattery_PowerbankApi(
            jsonReqString, prefs.get('accessToken').toString())
        .then((response) {
      debugPrint("rentBattery_PowerbankAPI   ${response.body}");
      if (response.statusCode == 200) {
        Navigator.pop(context);
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          setState(() {
            showBottomSheet = true;
          });
          _showDifferentTypeOfDialogs("SUCCESS", context,
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
          debugPrint("rentBattery_PowerbankAPI   else    200");
          _showDifferentTypeOfDialogs(
              jsonResponse['message'].toString(), context);
        }
      } else {
        debugPrint("rentBattery_PowerbankAPI   else");
        Navigator.pop(context);
        _showDifferentTypeOfDialogs("SOMETHING_WRONG", context);
      }
    }).catchError((onError) {
      debugPrint("rentBattery_PowerbankAPI   catch");
      Navigator.pop(context);
      _showDifferentTypeOfDialogs("SOMETHING_WRONG", context);
    });
  }

  bool isNotificationSent = false;

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    timer = Timer.periodic(
        Duration(seconds: 60), (Timer t) => getStationsOnMapApi());
    // getStationsOnMapApi();
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

  getLocation() async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    MyConstants.currentLat = _locationData.latitude;
    MyConstants.currentLong = _locationData.longitude;
    prefs.setDouble("lat", _locationData.latitude);
    prefs.setDouble("long", _locationData.longitude);

    print("onLocationChanged Splash : " +
        MyConstants.currentLat.toString() +
        " : " +
        MyConstants.currentLong.toString());
  }

  getTestNotification() {
    // testNotificaitonFired
    print("accesstoken " + prefs.get('accessToken').toString());
    var apicall = testNotificaitonFired(prefs.get('accessToken').toString());
    apicall.then((value) {
      debugPrint('status_12345 ---->     ${value.body}');
    });
  }

  getStationsOnMapApi() async {
    if (widget.isLocationOn != null) {
      if (widget.isLocationOn) {
      } else {
        getLocation();
      }
    } else {
      getLocation();
    }

    var betteryAlarm = prefs.getBool('betteryAlarm');
    if (betteryAlarm != null && betteryAlarm) {
      initbatteryInfo();
    }
    var req = {
      "latitude": MyConstants.currentLat.toString(),
      "longitude": MyConstants.currentLong.toString()
    };
    var jsonReqString = json.encode(req);
    print("accesstoken " + prefs.get('accessToken').toString());

    print(jsonReqString);

    await getMapLocationsApi(jsonReqString, prefs.get('accessToken').toString())
        .then((response) {
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
        if (stationsListPojo.status == 0 &&
            stationsListPojo.message.compareTo('ILLEGAL_ACCESS') == 0) {
          prefs.setBool('is_login', false);
          navigateToLoginScreen();
        } else {
          maplocationList = [];
          maplocationList = stationsListPojo.mapLocations;
          debugPrint('stationsListPojo2 ---->     ${maplocationList.length}');
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
        debugPrint("rentBattery_PowerbankAPI   getStationsOnMapApi else");
        _showDifferentTypeOfDialogs("SOMETHING_WRONG", context);
      }
    }).catchError((onError) {
      debugPrint("rentBattery_PowerbankAPI   getStationsOnMapApi catchError");
      _showDifferentTypeOfDialogs("SOMETHING_WRONG", context);
    });
  }

  getDetailsApi() async {
    await getUserDetailsApi(
            prefs.get('userId').toString(), prefs.get('accessToken').toString())
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        UserDetailsPojo userDetailsPojo =
            UserDetailsPojo.fromJson(jsonResponse);
        UserDetails userdetails = userDetailsPojo.userDetails;
        prefs.setString('walletAmount', userdetails.walletAmount.toString());
        prefs.setBool('isRental', userDetailsPojo.isRental);
        setState(() {});
      } else {
        debugPrint("rentBattery_PowerbankAPI   getDetailsApi");
        _showDifferentTypeOfDialogs("SOMETHING_WRONG", context);
      }
    }).catchError((value) {
      debugPrint("rentBattery_PowerbankAPI   getDetailsApi catchError");
      _showDifferentTypeOfDialogs("SOMETHING_WRONG", context);
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
      // Intercom.sendTokenToIntercom(token);

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
    _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
      debugPrint("firebase_token    ${settings.alert}");
      // if (settings.alert) {
      _firebaseMessaging.getToken().then((token) {
        debugPrint("firebase_token    $token");
        prefs.setString('fcmtoken', token);
      });
      // }
    });
  }

  // SOMETHING_WRONG
  // POWERBANK_RENTED_ALREADY
  // POWERBANK_RETURNED
  // POWERBANK_RETURNED_MSG
  // RENTAL_PERIOD_EXCEEDED
  // POWERBANK_SOLD_MSG
  // STATION_OFFLINE

  showFirebaseMesgDialog(message, context) {
    debugPrint("rentBattery_PowerbankAPI   showFirebaseMesgDialog");
    _showDifferentTypeOfDialogs(message["title"], context);
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return CustomDialogBoxError(
    //         title:
    //         AppLocalizations.of(context).translate("ERROR OCCURRED"),
    //         descriptions: jsonResponse['message'].toString(),
    //         text: AppLocalizations.of(context).translate("Ok"),
    //         img: "assets/images/something_went_wrong.svg",
    //         double: 37.0,
    //         isCrossIconShow: true,
    //         callback: () {},
    //       );
    //     });

    // Dialog myDialog = Dialog(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    //   //this right here
    //   child: Container(
    //     margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
    //     height: message['title'] == "POWERBANK ZURCKGEGEBEN" ? 480 : 350.0,
    //     // width: 600.0,
    //
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         SizedBox(
    //           height: 10,
    //         ),
    //         Align(
    //           alignment: Alignment.center,
    //           child: message['title'] == "POWERBANK ZURCKGEGEBEN"
    //               ? SizedBox(
    //                   width: 200,
    //                   height: 250,
    //                   child: Image.asset(
    //                     'assets/images/return_powerbank.png',
    //                   ),
    //                 )
    //               : SvgPicture.asset(
    //                   'assets/images/battery-unlocked.svg',
    //                 ),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         Text(
    //           message['title'],
    //           style: TextStyle(
    //               color: Colors.black,
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold),
    //         ),
    //         SizedBox(
    //           height: 15,
    //         ),
    //         Text(
    //           message['body'],
    //           textAlign: TextAlign.center,
    //           style: TextStyle(color: Colors.grey),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         closeButton()
    //       ],
    //     ),
    //   ),
    // );
    // return showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) => myDialog);
  }

  _showDifferentTypeOfDialogs(message, context, {String currncy}) {
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
    }
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
    // openDialogWithSlideInAnimation(
    //   context: context,
    //   itemWidget: ItemPanelTower(
    //     data: data,
    //     onDetailPressed: (MapLocation value) {
    //       debugPrint("on detail pressed    ${value.name}");
    //       _onDetailMarkerClick(context, value);
    //     },
    //     onNavigationPressed: (MapLocation value) {
    //       debugPrint("on navigation pressed  ${value.name}");
    //       _onNavigatorMarkerClick(value);
    //     },
    //   ),
    // );

    switch (data.freeSlots) {
      case 6:
        openDialogWithSlideInAnimation(
            context: context,
            itemWidget: ItemSlotSixStation(
              data: data,
              onDetailPressed: (MapLocation value) {
                debugPrint("on detail pressed    ${value.name}");
                _onDetailMarkerClick(context, value);
              },
              onNavigationPressed: (MapLocation value) {
                debugPrint("on navigation pressed  ${value.name}");
                _onNavigatorMarkerClick(value);
              },
            ));
        break;
      case 8:
        openDialogWithSlideInAnimation(
            context: context,
            itemWidget: ItemSlotEightStation(
              data: data,
              onDetailPressed: (MapLocation value) {
                debugPrint("on detail pressed    ${value.name}");
                _onDetailMarkerClick(context, value);
              },
              onNavigationPressed: (MapLocation value) {
                debugPrint("on navigation pressed  ${value.name}");
                _onNavigatorMarkerClick(value);
              },
            ));
        break;
      case 12:
        openDialogWithSlideInAnimation(
            context: context,
            itemWidget: ItemSlotEightStation(
              data: data,
              onDetailPressed: (MapLocation value) {
                debugPrint("on detail pressed    ${value.name}");
                _onDetailMarkerClick(context, value);
              },
              onNavigationPressed: (MapLocation value) {
                debugPrint("on navigation pressed  ${value.name}");
                _onNavigatorMarkerClick(value);
              },
            ));
        break;
      case 24:
        openDialogWithSlideInAnimation(
            context: context,
            itemWidget: ItemStationTower(
              data: data,
              onDetailPressed: (MapLocation value) {
                debugPrint("on detail pressed    ${value.name}");
                _onDetailMarkerClick(context, value);
              },
              onNavigationPressed: (MapLocation value) {
                debugPrint("on navigation pressed  ${value.name}");
                _onNavigatorMarkerClick(value);
              },
            ));
        break;
      case 48:
        openDialogWithSlideInAnimation(
            context: context,
            itemWidget: ItemPanelTower(
              data: data,
              onDetailPressed: (MapLocation value) {
                debugPrint("on detail pressed    ${value.name}");
                _onDetailMarkerClick(context, value);
              },
              onNavigationPressed: (MapLocation value) {
                debugPrint("on navigation pressed  ${value.name}");
                _onNavigatorMarkerClick(value);
              },
            ));
        break;
      default:
        {
          openDialogWithSlideInAnimation(
              context: context,
              itemWidget: ItemSlotSixStation(
                data: data,
                onDetailPressed: (MapLocation value) {
                  debugPrint("on detail pressed    ${value.name}");
                  _onDetailMarkerClick(context, value);
                },
                onNavigationPressed: (MapLocation value) {
                  debugPrint("on navigation pressed  ${value.name}");
                  _onNavigatorMarkerClick(value);
                },
              ));
        }
    }

    // showModalBottomSheet<void>(
    //     context: context,
    //     backgroundColor: Colors.transparent,
    //     builder: (BuildContext context) {
    //       var filePath = "assets/images/slot6station.png";
    //       var isLongImage = false;
    //
    //
    //       return BottomSheetWidget(
    //         data,
    //         slotTypeFilePath: filePath,
    //         isLongImage: isLongImage,
    //       );
    //     });
  }

  void _onNavigatorMarkerClick(MapLocation data) async {
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

  void _onDetailMarkerClick(BuildContext context, MapLocation data) {
    NearbyLocation value = NearbyLocation(
      id: data.id,
      name: data.name,
      address: data.address,
      availablePowerbanks: data.availablePowerbanks,
      status: data.status,
      description: data.description,
      category: data.category,
      city: data.city,
      country: data.country,
      distance: data.distance,
      freeSlots: data.freeSlots,
      fridayClosed: data.fridayClosed,
      fridayHours: data.fridayHours,
      houseNumber: data.houseNumber,
      imageAvatarPath: data.imageAvatarPath,
      imageFullPath: data.imageFullPath,
      latitude: data.latitude,
      longitude: data.longitude,
      mondayClosed: data.mondayClosed,
      mondayHours: data.mondayHours,
      pincode: data.pincode,
      saturdayClosed: data.saturdayClosed,
      saturdayHours: data.saturdayHours,
      sundayClosed: data.sundayClosed,
      sundayHours: data.sundayHours,
      thursdayClosed: data.thursdayClosed,
      thursdayHours: data.thursdayHours,
      tuesdayClosed: data.tuesdayClosed,
      tuesdayHours: data.tuesdayHours,
      wednesdayClosed: data.wednesdayClosed,
      wednesdayHours: data.wednesdayHours,
    );

    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) => MietStationDetailScreen(
          nearbyLocation: value,
        ),
      ),
    );
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

  sendBatterAlarmToServer() async {
    await sendAlarm(
            prefs.get('userId').toString(), prefs.get('accessToken').toString())
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {}
    }).catchError((onError) {});
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('primaryGreenColor', primaryGreenColor));
  }
}
