import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/faq/help_list_model.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/my_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  SharedPreferences prefs;

  var is_visible = false;
  var selected_index = -1;
  var isExpanding = true;
  List<RentalFaqs> helpList;
  var isListPos;

  @override
  void initState() {
    super.initState();
    loadShredPref();
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    await getHelpList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: color_white,
          child: Column(
            children: <Widget>[
              appBarView(
                  name: "FAQ",
                  context: context,
                  callback: () {
                    Navigator.pop(context);
                  }),
              bodyUI_WithApi_listView(context)
            ],
          )),
    );
  }

  listEmptyUI() {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "There is no data yet",
              style: sliderTitleTextStyle,
            ),
            SizedBox(
              height: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyUI_WithApi_listView(BuildContext context) {
    return helpList == null
        ? Expanded(
          child: Center(
              child: CircularProgressIndicator(),
            ),
        )
        : helpList.length == 0
            ? listEmptyUI()
            : Expanded(
                child: ListView.builder(
                    itemCount: helpList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var item = helpList[index];
                      return Container(
                        margin: EdgeInsets.only(
                          left: screenPadding,
                          right: screenPadding,
                          top: 15,
                          bottom: helpList.length-1==index?30:0
                        ),
                        child:item.id==-1?Text(item.question.toUpperCase(),style: faqRsStyle,):Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index != 0
                                ? Divider(
                                    color: Colors.grey.withOpacity(0.3),
                                    thickness: 1,
                                  )
                                : SizedBox(),
                            GestureDetector(
                              onTap: () {
                                if (isListPos == index) {
                                  isListPos = -1;
                                } else {
                                  isListPos = index;
                                }

                                setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.question,
                                        style: titleTextStyle,
                                      ),
                                    ),
                                    Container(
                                      child: SvgPicture.asset(
                                        isListPos == index
                                            ? "assets/images/arrow_up.svg"
                                            : "assets/images/arrow_down.svg",
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isListPos != index
                                ? Container()
                                : Text(
                                    item.answer,
                                    style: addBtnTextStyle,
                                  ),
                          ],
                        ),
                      );
                    }),
              );
  }

  var language = "";

  List<RentalFaqs> rentalFaqs;
  List<RentalFaqs> rentalStationFaqs;
  List<RentalFaqs> powerbankFaqs;

  List<RentalFaqs> paymentsFaqs;
  getHelpList() {


    var apicall = getHelpListApi(prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        log("jsonResponse${response.body}");
        if (jsonResponse['status'].toString() == "1") {
          helpList = [];
          rentalFaqs=[];
          rentalStationFaqs=[];
          powerbankFaqs=[];
          paymentsFaqs=[];
          HelpListResponse stationsListPojo = HelpListResponse.fromJson(jsonResponse);

          rentalFaqs = stationsListPojo.rentalFaqs;
          helpList.add(RentalFaqs(
            id: -1,question: "Rental"

          ));
          helpList.addAll(rentalFaqs);
          rentalStationFaqs = stationsListPojo.rentalStationFaqs;
          helpList.add(RentalFaqs(
              id: -1,question: "rentalStation"

          ));
          helpList.addAll(rentalStationFaqs);
          powerbankFaqs = stationsListPojo.powerbankFaqs;
          helpList.add(RentalFaqs(
              id: -1,question: "Powerbank"

          ));
          helpList.addAll(powerbankFaqs);
          paymentsFaqs = stationsListPojo.paymentsFaqs;
          helpList.add(RentalFaqs(
              id: -1,question: "Payments"

          ));
          helpList.addAll(paymentsFaqs);
          setState(() {});
        } else if (jsonResponse['status'].toString() == "0") {
          helpList = [];
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else if (jsonResponse['status'].toString() == "2") {
          helpList = [];
          helpList = [];
          setState(() {

          });
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        }
      } else {
        helpList = [];
        setState(() {

        });
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      helpList = [];
      helpList = [];
      setState(() {

      });
      print('error : $error');
    });
  }
}
