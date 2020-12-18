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
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddPaymentMethodInitialScreen extends StatefulWidget {
  @override
  _AddPaymentMethodInitialScreenState createState() => _AddPaymentMethodInitialScreenState();
}

class _AddPaymentMethodInitialScreenState extends State<AddPaymentMethodInitialScreen> {
  SharedPreferences prefs;
  var digitComplete = false;
  bool _saving = false;

  initSession() async {
    prefs = await SharedPreferences.getInstance();
  }

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
                      name: "Zahlung",
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
                      AppLocalizations.of(context).translate('ADD PAYMENT METHOD'),
                      style: sliderTitleTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 13, left: screenPadding, right: screenPadding),
                    child: Text(
                      AppLocalizations.of(context).translate('paymentMETHODDESC'),
                      textAlign: TextAlign.center,
                      style: locationTitleStyle,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * .50,
                    width: MediaQuery.of(context).size.width * .50,
                    child: Image.asset("assets/images/add_card.png"),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/tick.png",
                          height: 20,
                          width: 20,
                        ),
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                "Different payment methods",
                                textAlign: TextAlign.start,
                                style: locationTitleStyle,
                              ),
                            ))
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/tick.png",
                          height: 20,
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "No deposit required",
                              textAlign: TextAlign.start,
                              style: locationTitleStyle,
                            ),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/tick.png",
                          height: 20,
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "Different payment methods",
                              textAlign: TextAlign.start,
                              style: locationTitleStyle,
                            ),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: buttonView(callback: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Payments()));
                    }),
                    margin: EdgeInsets.only(
                        left: screenPadding, right: screenPadding),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            inAsyncCall: _saving,
          )),
    );
  }
}
