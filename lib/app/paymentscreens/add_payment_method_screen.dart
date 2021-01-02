import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:recharge_now/app/paymentscreens/payment_screen.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPaymentMethodInitialScreen extends StatefulWidget {
  @override
  _AddPaymentMethodInitialScreenState createState() =>
      _AddPaymentMethodInitialScreenState();
}

class _AddPaymentMethodInitialScreenState
    extends State<AddPaymentMethodInitialScreen> {
  SharedPreferences prefs;
  var digitComplete = false;
  bool _saving = false;

  initSession() async {
    prefs = await SharedPreferences.getInstance();
  }

//PaymentSmall
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: color_white,
          child: ModalProgressHUD(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  appBarView(
                      name: AppLocalizations.of(context)
                          .translate('PaymentSmall'),
                      context: context,
                      callback: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    height: 43,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('ADD PAYMENT METHOD'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimens.twentyThree,
                          color: Color(0xFF28272C),
                          height: 1.4),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: Dimens.twenty,
                        left: screenPadding,
                        right: screenPadding),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('paymentMETHODDESC'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimens.fifteen,
                          color: Color(0xFF686868),
                          height: 1.4),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.thirtyFive,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * .50,
                    width: MediaQuery.of(context).size.width * .50,
                    child: Image.asset("assets/images/add_card.png"),
                  ),
                  SizedBox(
                    height: Dimens.thirtyFive,
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimens.eight),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/tick.png",
                          height: Dimens.eighteen,
                          width: Dimens.eighteen,
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(left: Dimens.ten),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Different payment methods'),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF686868),
                                fontSize: Dimens.fifteen,
                                height: 1.2),
                          ),
                        ))
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimens.eight),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/tick.png",
                          height: Dimens.eighteen,
                          width: Dimens.eighteen,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: Dimens.ten),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('No saftey deposit required'),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF686868),
                                  fontSize: Dimens.fifteen,
                                  height: 1.2),
                            ),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimens.eight),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/tick.png",
                          height: Dimens.eighteen,
                          width: Dimens.eighteen,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: Dimens.ten),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('Secure payment transactions'),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF686868),
                                  fontSize: Dimens.fifteen,
                                  height: 1.2),
                            ),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                  ),
                  SizedBox(
                    height: Dimens.sixty,
                  ),
                  Container(
                    child: buttonView(
                        text: AppLocalizations.of(context).translate('Next'),
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Payments()));
                        }),
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                  ),
                  SizedBox(
                    height: Dimens.sixty,
                  ),
                ],
              ),
            ),
            inAsyncCall: _saving,
          )),
    );
  }
}
