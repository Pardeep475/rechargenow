/*
//
//
//
//import 'dart:ui';
//
//import 'package:app/ui/commonwidget/common_action_botton.dart';
//import 'package:app/ui/commonwidget/custom_rounded_rectangular_border.dart';
//import 'package:app/ui/login/login.dart';
//import 'package:app/ui/register/register.dart';
//import 'package:app/ui/register/register_almost_done.dart';
//import 'package:app/utils/colors.dart';
//import 'package:app/utils/fonts.dart';
//import 'package:app/utils/images.dart';
//import 'package:app/utils/strings.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:dots_indicator/dots_indicator.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//
//class Welcome extends StatefulWidget {
//  @override
//  _WelcomeState createState() => _WelcomeState();
//}
//
//class _WelcomeState extends State<Welcome> {
//  int currentIndexPage;
//  int pageLength;
//
//  @override
//  void initState() {
//    currentIndexPage = 0;
//    pageLength = 3;
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        body: Column(
//      children: <Widget>[
//        Expanded(
//          child: Stack(
//            children: <Widget>[
//              PageView(
//                children: <Widget>[
//                  Walkthrougth(
//                    title: "Buy",
//                    textContent: EshakooshString.dummy_text,
//                    image: EshakooshImages.walkthrough1,
//                  ),
//                  Walkthrougth(
//                    title: "Sell",
//                    textContent: EshakooshString.dummy_text,
//                    image: EshakooshImages.walkthrough2,
//                  ),
//                  Walkthrougth(
//                      title: "Auction",
//                      textContent: EshakooshString.dummy_text,
//                      image: EshakooshImages.walkthrough3),
//                ],
//                onPageChanged: (value) {
//                  setState(() => currentIndexPage = value);
//                },
//              ),
//              Positioned(
//                top: MediaQuery.of(context).size.height * 0.7,
//
//                // left: MediaQuery.of(context).size.width * 0.35,
//                // left: MediaQuery.of(context).size.width * 0.35,
//
//                child: Padding(
//                  padding: EdgeInsets.only(
//                      left: MediaQuery.of(context).size.width * 0.42),
//                  child: Align(
//                    alignment: Alignment.center,
//                    child: new DotsIndicator(
//                      dotsCount: pageLength,
//                      position: currentIndexPage,
//                      decorator: DotsDecorator(
//                        activeColor: EshaKooshcolors.primary_color,
//                        color: Colors.white,
//                        shape: CustomRoundedRectangleBorder(
//                          borderRadius:
//                              new BorderRadius.all(new Radius.circular(16.0)),
//                          borderWidth: 8.0,
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              )
//            ],
//          ),
//        ),
//        Container(
//          color: Colors.white,
//          padding: const EdgeInsets.only(
//              left: 35.0, right: 35.0, top: 10.0, bottom: 60.0),
//          child: Column(
//            children: <Widget>[
//              InkWell(
//                child: CommonActionBottonWidget(text: EshakooshString.sign_up),
//                onTap: () {
//                  Navigator.push(
//                    context,
//                    CupertinoPageRoute(builder: (context) => RegisterPage()),
//                  );
//                },
//              ),
//              SizedBox(
//                height: 30.0,
//              ),
//              InkWell(
//                  onTap: () {
//                    Navigator.push(
//                      context,
//                      CupertinoPageRoute(builder: (context) => LoginPage()),
//                    );
//                  },
//                  child: LoginButton())
//            ],
//          ),
//        )
//      ],
//    ));
//  }
//}
//
//class Walkthrougth extends StatelessWidget {
//  final String textContent;
//  final String title;
//  final String image;
//
//  Walkthrougth({Key key, @required this.textContent, this.title, this.image})
//      : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//     color: Colors.white,
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height,
//      child: Column(
//        children: <Widget>[
//          Expanded(flex: 70, child: Container(
//            width: MediaQuery.of(context).size.width,
//            color: Colors.white,
//              child: SvgPicture.asset(image,))),
//          Expanded(
//            flex: 10,
//            child: Container(
//
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  title,
//                  textAlign: TextAlign.center,
//                  style: new TextStyle(
//                      fontSize: 20.0,
//                      color: EshaKooshcolors.textHeaderBlackColor,
//                      fontFamily: EshaKooshFonts.font_family,
//                      fontWeight: FontWeight.w500),
//                ),
//              ),
//            ),
//          ),
//          Expanded(
//            flex: 20,
//            child: Container(
//              child: Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 35.0),
//                child: Text(
//                  textContent,
//                  style: new TextStyle(
//                      fontSize: 16.0,
//                      height: 1.5,
//                      wordSpacing: 2,
//                      color: EshaKooshcolors.textHeaderBlackColor,
//                      fontFamily: EshaKooshFonts.font_family,
//                      fontWeight: FontWeight.w400),
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//Widget LoginButton() {
//  return Container(
//    //width: 100.0,
//    height: 55.0,
//    decoration: new BoxDecoration(
//      color: EshaKooshcolors.color_white,
//      borderRadius: new BorderRadius.circular(6.0),
//      border: Border.all(color: EshaKooshcolors.primary_color, width: 1.0),
//    ),
//    child: new Center(
//      child: Text(
//        EshakooshString.login,
//        style: new TextStyle(
//            fontSize: 18.0,
//            color: EshaKooshcolors.primary_color,
//            fontFamily: EshaKooshFonts.font_family,
//            fontWeight: FontWeight.w500),
//      ),
//    ),
//  );
//}

import 'dart:ui';

import 'package:app/ui/commonwidget/common_action_botton.dart';
import 'package:app/ui/commonwidget/custom_rounded_rectangular_border.dart';
import 'package:app/ui/login/login.dart';
import 'package:app/ui/register/register.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/fonts.dart';
import 'package:app/utils/images.dart';
import 'package:app/utils/strings.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int currentIndexPage;
  int pageLength;

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          flex: 90,
          child: PageView(
            children: <Widget>[
              Walkthrougth(
                title: "Buy",
                textContent: EshakooshString.dummy_text,
                image: EshakooshImages.walkthrough1,
                paddingtop: 0.0,
                paddingLeftright: 0.0,
                isBoxFit: true,
              ),
              Walkthrougth(
                title: "Sell",
                textContent: EshakooshString.dummy_text,
                image: EshakooshImages.walkthrough2,
                paddingtop: 35.0,
                paddingLeftright: 35.0,
                isBoxFit: false,
              ),
              Walkthrougth(
                title: "Auction",
                textContent: EshakooshString.dummy_text,
                image: EshakooshImages.walkthrough3,
                paddingtop: 35.0,
                paddingLeftright: 35.0,
                isBoxFit: false,
              ),
            ],
            onPageChanged: (value) {
              setState(() => currentIndexPage = value);
            },
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.center,
              child: new DotsIndicator(
                dotsCount: pageLength,
                position: currentIndexPage,
                decorator: DotsDecorator(
                  activeColor: EshaKooshcolors.primary_color,
                  color: Colors.white,
                  shape: CustomRoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(16.0)),
                    borderWidth: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
//        Expanded(
//          child: Stack(
//            children: <Widget>[
//
//            ],
//          ),
//        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
              left: 35.0, right: 35.0, top: 10.0, bottom: 50.0),
          child: Column(
            children: <Widget>[
              CommonActionBottonWidget(
                onPressed:()
                  {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  text: EshakooshString.sign_up),
              SizedBox(
                height: 30.0,
              ),
              LoginButton(context)
            ],
          ),
        )
      ],
    ));
  }
}

class Walkthrougth extends StatelessWidget {
  final String textContent;
  final String title;
  final String image;
  final double paddingLeftright;
  final double paddingtop;
  final isBoxFit;

  Walkthrougth(
      {Key key,
      @required this.textContent,
      this.title,
      this.image,
      this.paddingLeftright,
      this.paddingtop,
      this.isBoxFit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 75,
              child: Container(
                  margin: EdgeInsets.only(
                      left: paddingLeftright,
                      right: paddingLeftright,
                      top: paddingtop),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: isBoxFit
                      ? SvgPicture.asset(
                          image,
                          fit: BoxFit.fill,
                        )
                      : SvgPicture.asset(
                          image,
                        ))),
          SizedBox(height: 10.0),
          Expanded(
            flex: 8,
            child: Container(
              color: Colors.white,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: EshaKooshcolors.textHeaderBlackColor,
                      fontFamily: EshaKooshFonts.font_family,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 17,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  textContent,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 16.0,
                      height: 1.4,
                      wordSpacing: 2,
                      color: EshaKooshcolors.textHeaderBlackColor,
                      fontFamily: EshaKooshFonts.font_family,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget LoginButton(BuildContext context) {
  return Container(
    height: 55.0,
    decoration: new BoxDecoration(
      color: EshaKooshcolors.color_white,
      borderRadius: new BorderRadius.circular(6.0),
      border: Border.all(color: EshaKooshcolors.primary_color, width: 1.0),
    ),
    child: FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: new Center(
        child: Text(
          EshakooshString.login,
          style: new TextStyle(
              fontSize: 18.0,
              color: EshaKooshcolors.primary_color,
              fontFamily: EshaKooshFonts.font_family,
              fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
*/
