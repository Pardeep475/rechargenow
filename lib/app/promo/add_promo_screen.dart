import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/promo/redeem_screen.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddPromosScreen extends StatefulWidget {
  @override
  _AddPromosScreen createState() => _AddPromosScreen();
}

class _AddPromosScreen extends State<AddPromosScreen> {
  SharedPreferences prefs;
  var promoCode = "";
  var isError = false;
  var errorMessage = "";

// Add variable to top of class

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     debugPrint(
    //         "visible   $visible  ${_scrollController.initialScrollOffset}  ${_scrollController.position.minScrollExtent}");
    //     if (visible) {
    //       _scrollController.animateTo(
    //           MediaQuery.of(context).size.height,
    //           duration: Duration(milliseconds: 100),
    //           curve: Curves.ease);
    //     } else {
    //       _scrollController.animateTo(
    //           0,
    //           duration: Duration(milliseconds: 100),
    //           curve: Curves.ease);
    //     }
    //   },
    // );
    loadShredPref();
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildBodyUI(),
    );
  }

  buildBodyUI() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(right: 32.0, top: 55),
                      alignment: Alignment.centerRight,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'assets/images/close_black.png',
                          height: 14,
                          width: 14,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: screenPadding,
                          top: screenPadding,
                          right: screenPadding),
                      child: Image.asset(
                        "assets/images/bell.png",
                        height: 150,
                        width: 150,
                      )),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        left: screenPadding,
                        top: screenPadding,
                        right: screenPadding),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('promo code small'),
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF28272C),
                          fontSize: Dimens.twentyThree,
                          height: 1.4),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: screenPadding, top: 8, right: screenPadding),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('enter your promocode here'),
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF28272C),
                          fontSize: Dimens.fifteen,
                          height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: screenPadding, top: 43, right: screenPadding),
                    child: Text(
                      AppLocalizations.of(context).translate('ENTER CODE'),
                      style: loginDetailText,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: 7, left: screenPadding, right: screenPadding),
                    height: 45,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: MyUtils.showRoundCornerDecoration(),
                    child: TextField(
                      autofocus: true,
                      textAlign: TextAlign.start,
                      style: editTextStyle,
                      onChanged: (text) {
                        if (isError) {
                          isError = false;
                          setState(() {});
                        }
                        promoCode = text;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)
                              .translate('Add Promo-Code here'),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  isError
                      ? Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              left: screenPadding, right: screenPadding),
                          child: Text(
                            "$errorMessage",
                            textAlign: TextAlign.start,
                            style: redTextStyle,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenPadding, top: 8, right: screenPadding),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('YOU WOULD LIKE TO GET CREDIT'),
                          textAlign: TextAlign.center,
                          style: addCardTextStyle,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: screenPadding,
                            top: 19,
                            bottom: 65,
                            right: screenPadding),
                        child: buttonView(
                            text: AppLocalizations.of(context)
                                .translate('REDEEM'),
                            callback: () {
                              addPromosButtonClick();
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  addPromosButtonClick() {
    if (promoCode.trim().length == 0) {
      MyUtils.showAlertDialog(
          AppLocalizations.of(context).translate('enter your promocode here'),
          context);
    } else {
      addPromos();
    }
  }

  addPromos() {
    var req = {
      "userId": prefs.get('userId').toString(),
      "promoCode": promoCode
    };
    print(req);
    // MyUtils.showLoaderDialog(context);
    var jsonReqString = json.encode(req);
    var apicall =
        redeemPromoCodeApi(jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      // print(response.body);
      //Navigator.pop(context);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //MyUtils.showAlertDialog(jsonResponse['message'].toString());

        if (jsonResponse['status'].toString() == "1") {
          prefs.setString(
              'walletAmount', jsonResponse['walletAmount'].toString());
          Navigator.of(context).pop({'response': true});
          // navigatoToSuccessScreen();
        } else if (jsonResponse['status'].toString() == "0") {
          isError = true;
          errorMessage = jsonResponse['message'].toString();
          errorMessage = AppLocalizations.of(context).translate('promo_error');
          notify();
          // MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);

        } else if (jsonResponse['status'].toString() == "2") {
          isError = true;
          errorMessage = jsonResponse['message'].toString();
          errorMessage = AppLocalizations.of(context).translate('promo_error');
          notify();
          //   MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          isError = true;
          errorMessage = jsonResponse['message'].toString();
          errorMessage = AppLocalizations.of(context).translate('promo_error');
          notify();
          // MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        }
        // MessageListPojo stationsListPojo = MessageListPojo.fromJson(jsonResponse);
        //messagesList.add(stationsListPojo.messageList);

      } else {
        MyUtils.showAlertDialog(
            AppLocalizations.of(context).translate("something_went_wrong"),
            context);
      }
    }).catchError((error) {
      // Navigator.pop(context);
      print('error : $error');
    });
  }

  void navigatoToSuccessScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RedeemSuccess()));
  }

  void notify() {
    setState(() {});
  }
}
