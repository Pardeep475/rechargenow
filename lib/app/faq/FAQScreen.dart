import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/faq/help_list_model.dart';
import 'package:recharge_now/common/custom_dialog_box_error.dart';
import 'package:recharge_now/common/custom_widgets/common_error_dialog.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/app_colors.dart';
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
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(padding: EdgeInsets.only(top: 10)),
                    helpList == null
                        ? SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : helpList.isEmpty
                            ? SliverFillRemaining(
                                child: listEmptyUI(),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  var item = helpList[index];
                                  return _itemContent(item, index);
                                }, childCount: helpList.length),
                              ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _itemContent(RentalFaqs item, int index) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimens.twentyThree,
          right: Dimens.twentyThree,
          bottom: helpList.length - 1 == index ? Dimens.thirtyThree : 0),
      child: item.id == -1
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dimens.twentyFive,
                ),
                Text(
                  item.question.toUpperCase(),
                  style: faqRsStyle,
                ),
                SizedBox(
                  height: Dimens.ten,
                ),
                Divider(
                  color: AppColor.divider_color,
                  thickness: 1,
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.question,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 13,
                                height: 1.2),
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
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          item.answer,
                          style: addBtnTextStyle,
                        ),
                      ),
                Divider(
                  color: AppColor.divider_color,
                  thickness: 1,
                )
              ],
            ),
    );
  }

  listEmptyUI() {
    return Center(
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
                            left: Dimens.twentyThree,
                            right: Dimens.twentyThree,
                            top: Dimens.thirtyThree,
                            bottom: helpList.length - 1 == index
                                ? Dimens.thirtyThree
                                : 0),
                        child: item.id == -1
                            ? Text(
                                item.question.toUpperCase(),
                                style: faqRsStyle,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  index != 0
                                      ? Divider(
                                          color: AppColor.divider_color,
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.question,
                                              style: TextStyle(
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  height: 1.2),
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

  getHelpList() async {
    await getHelpListApi(prefs.get('accessToken').toString()).then((response) {
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          _successResponseOne(jsonResponse);
        } else {
          _errorResponse();
        }
      } else {
        _errorResponse();
      }
    }).catchError((onError) {
      _errorResponse();
    });
  }

  void _successResponseOne(jsonResponse) {
    helpList = [];
    rentalFaqs = [];
    rentalStationFaqs = [];
    powerbankFaqs = [];
    paymentsFaqs = [];
    HelpListResponse stationsListPojo = HelpListResponse.fromJson(jsonResponse);

    rentalFaqs = stationsListPojo.rentalFaqs;
    helpList.add(RentalFaqs(id: -1, question: "Rental"));
    helpList.addAll(rentalFaqs);
    rentalStationFaqs = stationsListPojo.rentalStationFaqs;
    helpList.add(RentalFaqs(id: -1, question: "rentalStation"));
    helpList.addAll(rentalStationFaqs);
    powerbankFaqs = stationsListPojo.powerbankFaqs;
    helpList.add(RentalFaqs(id: -1, question: "Powerbank"));
    helpList.addAll(powerbankFaqs);
    paymentsFaqs = stationsListPojo.paymentsFaqs;
    helpList.add(RentalFaqs(id: -1, question: "Payments"));
    helpList.addAll(paymentsFaqs);
    setState(() {});
  }

  void _errorResponse() {
    helpList = [];
    setState(() {});
    openDialogWithSlideInAnimation(
      context: context,
      itemWidget: CommonErrorDialog(
        title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
        descriptions:
            AppLocalizations.of(context).translate("something_went_wrong"),
        text: AppLocalizations.of(context).translate("Ok"),
        img: "assets/images/something_went_wrong.svg",
        double: 37.0,
        isCrossIconShow: true,
        callback: () {},
      ),
    );
  }
}
