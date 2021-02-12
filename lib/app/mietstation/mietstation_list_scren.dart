import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/mietstation/near_by_stationlist_item.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';
import 'package:recharge_now/utils/color_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mietstation_detail.dart';
import 'mietstation_item.dart';

class StationListScreen extends StatefulWidget {
  @override
  _StationListScreenState createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  List<NearbyLocation> maplocationList;
  SharedPreferences prefs;

  var today_Day = "";
  var todays_hoursList = List<String>();

  DateTime date;

  @override
  void initState() {
    loadShredPref();
    super.initState();
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    getStationsOnMapApi();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  body() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          appBarView(
              name: AppLocalizations.of(context)
                  .translate("RENTAL STATION")
                  .toUpperCase(),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          maplocationList == null
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : maplocationList.length == 0
                  ? emptyStation()
                  : listViewMietstation()
        ],
      ),
    );
  }

  listViewMietstation() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          itemCount: maplocationList.length,
          itemBuilder: (BuildContext context, int position) {
            return maplocationList == null ||
                    (maplocationList != null && maplocationList.length == 0)
                ? emptyStation()
                : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MietStationDetailScreen(
                                    nearbyLocation: maplocationList[position],
                                  )));
                    },
                    child: MietStationItem(
                      nearbyLocation: maplocationList[position],
                    ));
          }),
    );
  }

  Widget bodyUI_WithApi_listView() {
    return maplocationList == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : maplocationList.length == 0
            ? emptyStation()
            : ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: maplocationList.length,
                itemBuilder: (context, index) {
                  //Datum datum = eventList.data[index];
                  return MietStationItem();
                });
  }

  emptyStation() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: 118,
            height: 123,
            child: Center(
              child: Image.asset(
                'assets/images/empty_stattion.png',
                width: 118,
                height: 123,
              ),
            ),
          ),
          SizedBox(
            height: 43,
          ),
          Text(
            AppLocalizations.of(context).translate('NoRENTAL'),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,
                height: 1.3,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: text_black),
          )
        ],
      ),
    );
  }

  getStationsOnMapApi() {
    debugPrint(
        "my_current_lat_lng :-   latitude  ${MyConstants.currentLat.toString()}    longitude  ${MyConstants.currentLong.toString()}");

    var req = {
      "latitude": MyConstants.currentLat.toString(),
      "longitude": MyConstants.currentLong.toString(),
    };
    var jsonReqString = json.encode(req);
    print(jsonReqString);

    var apicall = getNearbyLocationsApi(
        jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        NearbyStationsListPojo stationsListPojo =
            NearbyStationsListPojo.fromJson(jsonResponse);
        maplocationList = [];
        maplocationList.addAll(stationsListPojo.nearbyLocations);
        print("CheckLength${maplocationList.length}");
        // for timing between
        if (maplocationList.length == 0) {
          /* var json = {
            "message": "Success",
            "nearbyLocations": [
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
                "id": 2,
                "name": "LocationB",
                "address":
                "Capital O 10540 Hotel JD Residency, Shahi Majra, Industrial Area, Sector 58, Sahibzada Ajit Singh Nagar, Punjab, India",
                "category": "Restaurant",
                "onlineStations": 0,
                "distance": "2.54 KM",
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
              }
            ],
            "status": 1
          };
          NearbyStationsListPojo stationsListPojo2 =
              NearbyStationsListPojo.fromJson(json);
          maplocationList.addAll(stationsListPojo2.nearbyLocations);
          print("CheckLengthmaplocationList${maplocationList.length}");*/
        }
        date = DateTime.now();

        for (int i = 0; i < maplocationList.length; i++) {
          if (date.weekday == 1) {
            today_Day = "Monday";
            todays_hoursList.add(maplocationList[i].mondayHours.toString());
          } else if (date.weekday == 2) {
            today_Day = "Tuesday";
            todays_hoursList.add(maplocationList[i].tuesdayHours.toString());
          } else if (date.weekday == 3) {
            today_Day = "Wednesday";
            todays_hoursList.add(maplocationList[i].wednesdayHours.toString());
          } else if (date.weekday == 4) {
            today_Day = "Thursday";
            todays_hoursList.add(maplocationList[i].thursdayHours.toString());
          } else if (date.weekday == 5) {
            today_Day = "Friday";
            todays_hoursList.add(maplocationList[i].fridayHours.toString());
          } else if (date.weekday == 6) {
            today_Day = "Saturday";
            todays_hoursList.add(maplocationList[i].saturdayHours.toString());
          } else if (date.weekday == 7) {
            today_Day = "Sunday";
            todays_hoursList.add(maplocationList[i].sundayHours.toString());
          }
        }

        print("weekday is ${date.weekday}");
        setState(() {});
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  stationLogoUI(url) {
    return Container(
      // margin: EdgeInsets.only(top: 20),
      child: Center(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              side: BorderSide(width: 0.5, color: Colors.grey)),
          child: Container(
              //margin: EdgeInsets.fromLTRB(20,0,0,0),
              width: 90.0,
              height: 90.0,
              // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height

              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                    // fit: BoxFit.fill,
                    image: new NetworkImage(url))
                //,fit: BoxFit.cover,
                ,
                // size: Size(300.0, 400.0),
              ) // You can add a Icon instead of text also, like below.
              //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
              ),
        ),
      ),
    );
  }
}
// listEmptyUI() {
//   return Center(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         SizedBox(
//             width: 60,
//             height: 60,
//             child: SvgPicture.asset(
//               'assets/images/emptylist_placeholder.svg',
//               color: color_grey,
//             )),
//         SizedBox(
//           height: 30,
//         ),
//         Text(
//           "Es sind keine Mietstationen in deiner Nähe",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: color_grey,
//             fontSize: 14, /*fontWeight: FontWeight.bold*/
//           ),
//         )
//       ],
//     ),
//   );
// }
