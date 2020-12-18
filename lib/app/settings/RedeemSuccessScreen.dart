import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_screen.dart';

class RedeemSuccess extends StatefulWidget {
  @override
  _RedeemSuccess createState() => _RedeemSuccess();
}

class _RedeemSuccess extends State<RedeemSuccess> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: buildBodyUI(),
    );
  }

  buildBodyUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  navigateToHome();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    right: 32.0,
                    top: 55,
                  ),
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
              SizedBox(height: 100,),
              Image.asset(
                "assets/images/recharge.png",
                height: 200,
                width: 121,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    left: screenPadding,
                    top: screenPadding,
                    right: screenPadding),
                child: Text(
                  "Thank you for using RechargeNow",
                  textAlign: TextAlign.center,
                  style: sliderTitleTextStyle,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: screenPadding, top: 8, right: screenPadding),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Your rental was ",
                      style: redeemSuccesss,
                    ),
                    TextSpan(
                      text: "3h 59 min. \nTotal cost 4€ ",

                      style: redeemSuccesssValue,
                    )
                  ],),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 5,
              ),
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
                        left: screenPadding,
                        top: 8,
                        bottom: 65,
                        right: screenPadding),
                    child: buttonView(
                        text: "Weiter",
                        callback: () {
                         navigateToHome();
                        })),
              ],
            ),
          ),
        )
      ],
    );
  }

  void navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
  }
}
