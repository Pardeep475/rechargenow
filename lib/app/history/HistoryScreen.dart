import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/history_list_model.dart';
import 'package:recharge_now/utils/Dimens.dart';
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
  List<History> historyList;

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
                  name: AppLocalizations.of(context).translate('HISTORY'),
                  context: context,
                  callback: () {
                    Navigator.pop(context);
                  }),
              SizedBox(height: 10,),
              historyList == null
                  ? Expanded(child: Center(child: CircularProgressIndicator()))
                  : historyList.length == 0
                      ? listEmptyUI()
                      : stickyListView()
            ],
          )),
    );
  }

  listEmptyUI() {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
            'assets/images/emptyhistory.png',
            fit: BoxFit.cover,
          ),
          // SvgPicture.asset(
          //   'assets/images/emptyhistory.svg',
          //   allowDrawingOutsideViewBox: true,
          // ),
          Text(
            AppLocalizations.of(context).translate('There is no history yet'),
            textAlign: TextAlign.center,
            style: sliderTitleTextStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context).translate('as soon as you rent'),
            textAlign: TextAlign.center,
            style: subTitleTextStyle,
          ),
        ],
      ),
    );
  }

  // Widget bodyUI_WithApi_listView(BuildContext context) {
  //   return Expanded(
  //     child: ListView.builder(
  //         itemCount: historyList.length,
  //         padding: EdgeInsets.zero,
  //         itemBuilder: (context, index) {
  //           //Datum datum = eventList.data[index];
  //           return Container(
  //             child: Material(
  //               color: Colors.transparent,
  //               child: InkWell(
  //                 onTap: () {},
  //                 child: index == 0 || index == 6
  //                     ? Container(
  //                         padding: EdgeInsets.only(
  //                             left: screenPadding,
  //                             top: 10,
  //                             right: screenPadding),
  //                         child: Text(
  //                             index == 0 ? "MARCH 2020" : "FEBRUARY 2020",
  //                             style: historyTitleTextStyle),
  //                       )
  //                     : Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.only(
  //                                 left: screenPadding, right: screenPadding),
  //                             child: Divider(
  //                               color: Colors.grey.withOpacity(0.3),
  //                               thickness: 1,
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: EdgeInsets.only(
  //                                 left: screenPadding, right: screenPadding),
  //                             child: Row(
  //                               mainAxisSize: MainAxisSize.max,
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text(
  //                                   "19 March",
  //                                   style: appBarTitleStyle,
  //                                 ),
  //                                 Text(
  //                                   "0,00 Rs",
  //                                   style: appBarTitleStyle,
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: EdgeInsets.only(
  //                                 left: screenPadding, right: screenPadding),
  //                             child: Text(
  //                               "18-15 18-15",
  //                               style: addBtnTextStyle,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

  stickyListView() {
    return Expanded(
      child: StickyGroupedListView<History, String>(
        elements: newHostry,
        order: StickyGroupedListOrder.ASC,
        groupBy: (History element) => element.monthYear,
        groupComparator: (String value1, String value2) =>
            value2.compareTo(value1),
        itemComparator: (History element1, History element2) =>
            element1.monthYear.compareTo(element2.monthYear),
        floatingHeader: false,
        stickyHeaderBackgroundColor: Colors.white,

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
          debugPrint(
              "testing_date_format_history:-    ${element.rentalDate}   ${dateConvertMainTitle(element.rentalDate)}    ${element.monthYear}");
          return InkWell(
            onTap: () {
              showBottomSheet(context, element);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: screenPadding, right: screenPadding),
                  child: Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenPadding, right: screenPadding),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dateConvertMainTitle(element.rentalDate)}',
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
                  padding: EdgeInsets.only(
                      left: screenPadding, right: screenPadding),
                  child: Text(
                    "${startTimeAndEndTime(element.rentalDate, element.transactionDate)}",
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

  String startTimeAndEndTime(String startDate, String endDate) {
    DateFormat originalFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat targetFormat =
        new DateFormat("HH:mm", prefs.getString('language_code'));
    DateTime dateStart = originalFormat.parse(startDate);
    DateTime dateEnd = originalFormat.parse(endDate);
    String formattedStartDate = targetFormat.format(dateStart.toLocal());
    String formattedEndDate = targetFormat.format(dateEnd.toLocal());

    return "$formattedStartDate - $formattedEndDate";
  }

  String dateConvertMainTitle(String value) {
    DateFormat originalFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat targetFormat =
        new DateFormat("dd MMMM", prefs.getString('language_code'));
    DateTime date = originalFormat.parse(value);
    String formattedDate = targetFormat.format(date.toLocal());
    return formattedDate;
  }

  String dateConvert(String value) {
    DateFormat originalFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat targetFormat =
        new DateFormat("dd.MM.yyyy", prefs.getString('language_code'));
    DateTime date = originalFormat.parse(value);
    String formattedDate = targetFormat.format(date.toLocal());
    return formattedDate;
  }

  String dateConvertStartEnd(String value) {
    DateFormat originalFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
    var language = prefs.getString('language_code');
    DateFormat targetFormat = new DateFormat(
        "HH:mm ${language == 'en' ? "hr" : "Uhr"} / dd. MMM yyyy ",
        prefs.getString('language_code'));
    DateTime date = originalFormat.parse(value);
    String formattedDate = targetFormat.format(date.toLocal());
    return formattedDate.replaceAll('3r', "hr");
  }

  void showBottomSheet(BuildContext context, History history) {
    debugPrint("History_Address :-   ${history.locationAddress}");
    debugPrint("History_Address :-   ${history.returnLocationAddress}");

    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.fifteen),
                    topRight: Radius.circular(Dimens.fifteen),
                  ),
                ),
                padding: EdgeInsets.only(
                    left: Dimens.twenty,
                    right: Dimens.twenty,
                    bottom: Dimens.twenty),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: Dimens.fifteen,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Container(
                          height: Dimens.five,
                          width: Dimens.seventySeven,
                          decoration: BoxDecoration(
                            color: Color(0xFFEBEBEB),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.fifteen),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimens.sixteen,
                    ),
                    Text(
                      "RENTAL-ID ${history.id}",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2F2F2F),
                          fontSize: Dimens.forteen,
                          height: 1.2),
                    ),
                    SizedBox(
                      height: Dimens.forteen,
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                      thickness: 1,
                    ),
                    SizedBox(
                      height: Dimens.eleven,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Station-ID",
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F2F2F),
                              fontSize: Dimens.forteen,
                              height: 1.2),
                        ),
                        Text(
                          "#${history.stationNumber}",
                          style: addBtnTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimens.four,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Powerbank-ID",
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F2F2F),
                              fontSize: Dimens.forteen,
                              height: 1.2),
                        ),
                        Text(
                          "#${history.powerbankNumber}",
                          style: addBtnTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimens.four,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('Start'),
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F2F2F),
                              fontSize: Dimens.forteen,
                              height: 1.2),
                        ),
                        Text(
                          dateConvertStartEnd(history.rentalDate),
                          //16:25 Uhr / 01.09.2020history.rentalDate,//16:25 Uhr / 01.09.2020
                          style: addBtnTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimens.four,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('End'),
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F2F2F),
                              fontSize: Dimens.forteen,
                              height: 1.2),
                        ),
                        Text(
                          dateConvertStartEnd(history.transactionDate),
                          //16:25 Uhr / 01.09.2020
                          style: addBtnTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimens.twenty,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: screenPadding, right: screenPadding),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF54DF6C),
                            Color(0xFF54DF83),
                          ],
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.fifty),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimens.twelve),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('RENT PERIOD')
                                  .toUpperCase(),
                              style: sliderButtonTextStyle,
                            ),
                            Spacer(),
                            Text(
                              history.rentalTime, //2d : 23h : 28m
                              style: sliderButtonTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimens.twelve,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('LOCATION'),
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2F2F2F),
                          fontSize: Dimens.forteen,
                          height: 1.2),
                    ),
                    SizedBox(
                      height: Dimens.forteen,
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                      thickness: 1,
                    ),
                    SizedBox(
                      height: Dimens.eleven,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('Taken'),
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F2F2F),
                              fontSize: Dimens.forteen,
                              height: 1.2),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Expanded(
                          child: Text(
                            "${history.locationName}\n${history.locationAddress}",
                            maxLines: 3,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: Dimens.thrteen,
                              height: 1.4,
                              color: Color(0xFF848490),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimens.eight,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('Submitted'),
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F2F2F),
                              fontSize: Dimens.forteen,
                              height: 1.2),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Expanded(
                          child: Text(
                            "${history.returnLocationName}\n${history.returnLocationAddress}",
                            maxLines: 3,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: Dimens.thrteen,
                              height: 1.4,
                              color: Color(0xFF848490),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimens.thirtyThree,
                    ),
                  ],
                ),
              ),
            ],
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

  HashMap<String, History> historyMapList = HashMap();

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    print("prefsuserId ${prefs.get('userId')}");
    await getHistoryApi();
  }

  String dateConverGroupByDate(String value) {
    DateFormat originalFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat targetFormat =
        new DateFormat("dd MMMM yyyy", prefs.getString('language_code'));
    DateTime date = originalFormat.parse(value);
    String formattedDate = targetFormat.format(date.toLocal());
    return formattedDate;
  }

  List<History> newHostry = [];

  void groupByDate() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    historyList.forEach((element) {
      var transacion = dateConverGroupByDate(element.transactionDate);
      var arr = transacion.split(" ");
      var monthYear = arr[1] + " " + arr[2];
      print("monthYear$monthYear");
      element.monthYear = monthYear;
      newHostry.add(element);
    });
    setState(() {});
  }
}
