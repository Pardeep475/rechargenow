import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/app/home_screen.dart';
import 'package:recharge_now/app/home_screen_new.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HowToWorkScreen extends StatefulWidget {
  bool isFromHome;

  HowToWorkScreen({this.isFromHome});

  @override
  _HowToWorkScreenState createState() => _HowToWorkScreenState();
}

class _HowToWorkScreenState extends State<HowToWorkScreen> {
  var titleToolbar = "How To Work";
  SharedPreferences prefs;
  var currentTab = 0;

  String buttonNext = "";

  BuildContext context;

  int pageLength;
  var pageController = PageController();

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    //buttonNext=;
    setState(() {});
  }

  @override
  void initState() {
    currentTab = 0;
    pageLength = 4;
    loadShredPref();
    super.initState();

    var textstyle = TextStyle(
        height: 1.5,
        letterSpacing: 1.0,
        fontWeight: FontWeight.bold,
        fontSize: 18);
  }

  introSliderTitlePortionFirst(assetImage, title, subTitle) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 100,
          child: SizedBox(
              height: 502,
              child: Image.asset(
                assetImage,
                fit: BoxFit.cover,
              )),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 30,
          child: Container(
              height: 51,
              width: 200,
              child: Image.asset('assets/images/logo.png')),
        ),
   /*     widget.isFromHome
            ? Positioned(
                right: Dimens.twenty,
                top: Dimens.oneTwentyFive,
                child: InkWell(
                  onTap: () {
                   Navigator.pop(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF2F3F7),
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimens.twenty,vertical: Dimens.ten),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Skip')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff848490),
                                fontSize: 12.0,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      )),
                ),
              )
            : Positioned(top: 120, child: SizedBox()),*/
        Positioned(
          bottom: 0,
          left: 40,
          right: 40,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: sliderTitleTextStyle,
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: sliderDescriptionTextStyle,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }

  introSliderTitlePortionSecond(assetImage, title, subTitle) {
    return Stack(
      children: [
        Positioned(
          left: 50,
          right: 50,
          top: 150,
          bottom: 150,
          child: Image.asset(
            assetImage,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 30,
          child: Container(
              height: 51,
              width: 200,
              child: Image.asset('assets/images/logo.png')),
        ),
        /*widget.isFromHome
            ? Positioned(
                right: Dimens.twenty,
                top: Dimens.oneTwentyFive,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF2F3F7),
                          borderRadius:
                          BorderRadius.all(Radius.circular(50.0))),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimens.twenty,vertical: Dimens.ten),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Skip')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff848490),
                                fontSize: 12.0,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      )),
                ),
              )
            : Positioned(top: 120, child: SizedBox()),*/
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: sliderTitleTextStyle,
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: sliderDescriptionTextStyle,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }

  introSliderTitlePortionThree(assetImage, title, subTitle) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 30,
          top: 170,
          bottom: 150,
          child: Image.asset(
            assetImage,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 30,
          child: Container(
              height: 51,
              width: 200,
              child: Image.asset('assets/images/logo.png')),
        ),
        /*widget.isFromHome
            ? Positioned(
                right: Dimens.twenty,
                top: Dimens.oneTwentyFive,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF2F3F7),
                          borderRadius:
                          BorderRadius.all(Radius.circular(50.0))),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimens.twenty,vertical: Dimens.ten),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Skip')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff848490),
                                fontSize: 12.0,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      )),
                ),
              )
            : Positioned(top: 120, child: SizedBox()),*/
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: sliderTitleTextStyle,
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: sliderDescriptionTextStyle,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }

  introSliderTitlePortionFour(assetImage, title, subTitle) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 70,

          child: Image.asset(
            assetImage,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 30,
          child: Container(
              height: 51,
              width: 200,
              child: Image.asset('assets/images/logo.png')),
        ),
        /*widget.isFromHome
            ? Positioned(
          right: Dimens.twenty,
          top: Dimens.oneTwentyFive,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffF2F3F7),
                    borderRadius:
                    BorderRadius.all(Radius.circular(50.0))),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.twenty,vertical: Dimens.ten),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('Skip')
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff848490),
                          fontSize: 12.0,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                )),
          ),
        )
            : Positioned(top: 120, child: SizedBox()),*/
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                height: 90,
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        stops: [
                          0.0,
                          0.9
                        ],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        tileMode: TileMode.repeated)),
                width: double.infinity,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: sliderTitleTextStyle,
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Text(
                      subTitle,
                      textAlign: TextAlign.center,
                      style: sliderDescriptionTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      backgroundColor: Colors.white,
      body: buildBodyUI(),
    );
  }

  Widget buildBodyUI() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          initViewPager(context),
          Container(
            height: 20,
            child: DotsIndicator(
              dotsCount: pageLength,
              position: currentTab.toDouble(),
              decorator: DotsDecorator(
                color: Color(0xffF2F3F7),
                activeColor: Color(0xff686868),
                size: Size(10, 10),
                activeSize: Size(10, 10),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: Container(
              height: 50,
              alignment: Alignment.bottomCenter,
              margin:
                  EdgeInsets.only(left: screenPadding, right: screenPadding),
              child: buttonView(
                  text: currentTab == 3
                      ? AppLocalizations.of(context).translate('LETS GO')
                      : AppLocalizations.of(context).translate('Next'),
                  callback: () {
                    if (currentTab == 3 && !widget.isFromHome) {
                      prefs.setBool('isSkip', true);
                      if (prefs.getBool('is_login') != null &&
                          prefs.getBool('is_login') == true) {
                        Navigator.of(context).pushReplacementNamed('/HomePage');
                      } else {
                        Navigator.of(context)
                            .pushReplacementNamed('/LoginScreen');
                      }
                    }
                    if (currentTab == 3 && widget.isFromHome) {
                      Navigator.pop(context);
                    } else {
                      pageController.nextPage(
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeIn);
                    }
                  }),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  void onDonePress() {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (BuildContext context) => HomeScreenNew()));
  }

  initViewPager(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: PageView(
        controller: pageController,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 200,
            // margin: EdgeInsets.only(
            //   left: 20,
            //   right: 20,
            // ),
            child: introSliderTitlePortionFirst(
                "assets/images/slider1.png",
                AppLocalizations.of(context).translate("FINDARENTALSTATION"),
                AppLocalizations.of(context)
                    .translate('FINDARENTALSTATIONDESC')),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: introSliderTitlePortionSecond(
                "assets/images/slider2.png",
                AppLocalizations.of(context).translate("ScantheQRCode"),
                AppLocalizations.of(context).translate('scanDESC')),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: introSliderTitlePortionThree(
                "assets/images/slider3.png",
                AppLocalizations.of(context).translate("CHARGE ON THE GO"),
                AppLocalizations.of(context).translate('CHARGEONDESC')),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: introSliderTitlePortionFour(
                "assets/images/slider4.png",
                AppLocalizations.of(context).translate('RETURNTITLE'),
                AppLocalizations.of(context).translate('RETURDESC')),
          ),
        ],
        onPageChanged: (value) {
          setState(() => currentTab = value);
        },
      ),
    );
  }
}
