import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/models/history_list_model.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {


  Completer<GoogleMapController> _controller = Completer();
  SharedPreferences prefs;
  List<History> historyList ;

  @override
  void initState() {
    super.initState();


    loadShredPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_white,
      body: Container(
          height: double.infinity,
          color: color_white,
          child: Column(
            children: <Widget>[
              appBarView(
                  name: "HISTORY",
                  context: context,
                  callback: () {
                    Navigator.pop(context);
                  }),
             historyList==null?Expanded(child: Center(child: CircularProgressIndicator())) :historyList.length==0?listEmptyUI():stickyListView()
            ],
          )),
    );
  }

  listEmptyUI() {
    return Expanded(
      child: Column(
        children: [
          Image.asset('assets/images/emptyhistory.png',fit: BoxFit.cover,),
          // SvgPicture.asset(
          //   'assets/images/emptyhistory.svg',
          //   allowDrawingOutsideViewBox: true,
          // ),
          Text(
            "There is no history yet",
            textAlign: TextAlign.center,
            style: sliderTitleTextStyle,
          ),
          SizedBox(height: 10,),
          Text(
            "As soon as you rent your first Powerbank, you\n will see here all information about renting",
            textAlign: TextAlign.center,
            style: subTitleTextStyle,
          ),
        ],
      ),
    );

  }


  Widget bodyUI_WithApi_listView(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: historyList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            //Datum datum = eventList.data[index];
            return Container(

              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {

                  },
                  child:
                  index == 0 || index == 6
                      ? Container( padding: EdgeInsets.only(left: screenPadding,top:10, right: screenPadding),
                    child: Text(
                        index == 0 ? "MARCH 2020" : "FEBRUARY 2020",
                        style: historyTitleTextStyle),
                  )
                  :Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(left: screenPadding, right: screenPadding),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenPadding, right: screenPadding),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "19 March",
                              style: appBarTitleStyle,
                            ),
                            Text(
                              "0,00 Rs",
                              style: appBarTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenPadding, right: screenPadding),
                        child: Text(
                          "18-15 18-15",
                          style: addBtnTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }


  stickyListView(){
    return Expanded(
      child: StickyGroupedListView<History, String>(
        elements: newHostry,
        order: StickyGroupedListOrder.ASC,
        groupBy: (History element) =>
        element.monthYear,
        groupComparator: (String value1, String value2) =>
            value2.compareTo(value1),
        itemComparator: (History element1, History element2) =>
            element1.monthYear.compareTo(element2.monthYear),
        floatingHeader: true,
        groupSeparatorBuilder: (History element) => Container(
          height: 50,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                '${element.monthYear}',
                style: historyTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        itemBuilder: (_, History element) {
          return InkWell(
            onTap: (){
              showBottomSheet(context,element);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.only(left: screenPadding, right: screenPadding),
                  child: Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenPadding, right: screenPadding),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        element.transactionDate,
                        style: appBarTitleStyle,
                      ),
                      Text(
                        element.totalAmount,
                        style: appBarTitleStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenPadding, right: screenPadding),
                  child: Text(
                    "${element.locationName}",
                    style: addBtnTextStyle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showBottomSheet(BuildContext context, History history) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Center(
              child: Wrap(
                children: <Widget>[
                  Text(
                    "Rental-ID ",
                    style: appBarTitleStyle,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Station-ID",
                        style: drawerTitleStyle,
                      ),
                      Text(
                        history.stationNumber,
                        style: addBtnTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Powerbank-ID",
                        style: drawerTitleStyle,
                      ),
                      Text(
                        history.powerbankNumber,
                        style: addBtnTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Start",
                        style: drawerTitleStyle,
                      ),
                      Text(

                        history.rentalDate,//16:25 Uhr / 01.09.2020
                        style: addBtnTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "End",
                        style: drawerTitleStyle,
                      ),
                      Text(
                        history.transactionDate,//16:25 Uhr / 01.09.2020
                        style: addBtnTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 20),
                        padding: EdgeInsets.only(
                            left: screenPadding, right: screenPadding),
                        alignment: Alignment.center,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF54DF6C),
                              Color(0xFF54DF83),
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "REND PERIOD",
                              style: sliderButtonTextStyle,
                            ),
                            Spacer(),
                            Text(
                              history.rentalTime,//2d : 23h : 28m
                              style: sliderButtonTextStyle,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {}),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "LOCATION",
                    style: appBarTitleStyle,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        history.locationName,
                        style: drawerTitleStyle,
                      ),
                      Text(
                        "#${history.locationName}",
                        style: addBtnTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Abegegeben",
                        style: drawerTitleStyle,
                      ),
                      Text(
                        "${history.returnLocationName}",
                        style: addBtnTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }




  getHistoryApi() {
    var apicall = getUserHistoryApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) {
      log("response.body${response.body}");
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        HistoryListPojo stationsListPojo =
            HistoryListPojo.fromJson(jsonResponse);
        historyList = stationsListPojo.history;

        /*if(historyList.length==0){
          var json= {
            "status": 1,
            "message": "Success",
            "history": [
              {
                "id": 1,
                "locationName": "Street B",
                "transactionDate": "15 Feb 2020",
                "rentalTime": "1:25 Hours",
                "longitude": "76.7626477",
                "latitude": "30.7320825",
                "type": "Rental",
                "paymentStatus": "Success",
                "totalAmount": "1.50 €"
              },
              {
                "id": 2,
                "locationName": "Street B",
                "transactionDate": "16 Jan 2020",
                "rentalTime": "1:25 Hours",
                "longitude": "76.7626477",
                "latitude": "30.7320825",
                "type": "NewRental",
                "paymentStatus": "Success",
                "totalAmount": "2.50 €"
              },
              {
                "id": 3,
                "locationName": "Street B",
                "transactionDate": "16 Jun 2020",
                "rentalTime": "1:25 Hours",
                "longitude": "76.7626477",
                "latitude": "30.7320825",
                "type": "NewRental",
                "paymentStatus": "Success",
                "totalAmount": "2.50 €"
              },
              {
                "id": 3,
                "locationName": "Street B",
                "transactionDate": "16 Feb 2020",
                "rentalTime": "1:25 Hours",
                "longitude": "76.7626477",
                "latitude": "30.7320825",
                "type": "NewRental",
                "paymentStatus": "Success",
                "totalAmount": "2.50 €"
              }
            ]
          };
           stationsListPojo =
          HistoryListPojo.fromJson(json);
          historyList = stationsListPojo.history;

        }*/
        groupByDate();
        setState(() {});
      } else {
        final jsonResponse = json.decode(response.body);
        MyUtils.showAlertDialog(jsonResponse['message'], context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  HashMap<String, History> historyMapList=HashMap();
  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    print("prefsuserId ${prefs.get('userId')}");
    await getHistoryApi();



  }
  List<History> newHostry=[];
  void groupByDate() {

    historyList.forEach((element) {
      var arr=element.transactionDate.split(" ");
      var monthYear=arr[1]+" "+arr[2];
      print("monthYear$monthYear");
      element.monthYear=monthYear;
      newHostry.add(element);
    });
    setState(() {

    });
    /*var groupByDate = groupBy(historyList, (obj) => obj['transactionDate'].substring(3, 10));
    groupByDate.forEach((date, list) {
      // Header
      print('${date}:');

      // Group
      list.forEach((listItem) {
        // List item
        print('groupByDate${listItem.transactionDate}, ${listItem.locationName}');
      });
      // day section divider
      print('\n');
    });*/
  }
}
