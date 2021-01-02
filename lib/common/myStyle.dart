import 'package:flutter/material.dart';
import 'package:recharge_now/utils/Dimens.dart';

String fontFamily = "Montserrat";

double screenPadding = Dimens.thirtyThree;

TextStyle textStyle = TextStyle(
    color: const Color(0XFFFFFFFF),
    fontSize: Dimens.sixteen,
    fontWeight: FontWeight.normal);

ThemeData appTheme = new ThemeData(
  hintColor: Colors.white,
  accentColor: primaryGreenColor,
);

Color textFieldColor = const Color.fromRGBO(255, 255, 255, 0.1);

TextStyle buttonTextStyle = TextStyle(
    color: const Color.fromRGBO(255, 255, 255, 0.8),
    fontSize: Dimens.forteen,
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

//  color hex codes

Color primaryGreenColor = const Color(0xFF54DF6C);
Color color_white = const Color(0xFFFFFFFF);
Color color_light_grey = const Color(0xFFededed);
Color color_grey = const Color(0xFFA9A9A9);
Color color_blackChat = const Color(0xFF313131);
Color color_greyChat = const Color(0xFFE9E9E9);
Color color_red = const Color(0xFFF44336);

// HowToWorkScreen font family

//slider header , also login text, otp screen //release loctaion //empty promo code// add prmo code //history screen
TextStyle sliderTitleTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twenty,
    color: Color(0xFF28272C),
    height: 1.4);
//faq
TextStyle titleTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontSize: Dimens.thrteen,
    height: 1.2);

TextStyle faqRsStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: Color(0xFF54DF6C),
    fontSize: Dimens.eighteen,
    height: 1.2);

//login, addd prmo code
TextStyle hintTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9E9E9E),
    height: 1.2);

TextStyle redTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.w500,
    color: color_red,
    height: 1.2);

//login, addd prmo code
TextStyle editTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    height: 1.2);

TextStyle sliderDescriptionTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: Color(0xFF686868),
    fontSize: Dimens.forteen,
    height: 1.4);

TextStyle sliderButtonTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontSize: Dimens.forteen,
    height: 1.4);

//login page
TextStyle termsText = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: colorCode(686868),
    decoration: TextDecoration.none,
    fontSize: Dimens.twelve,
    height: 1.2);

//login page
TextStyle termsBoldText = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: Color(0xFF54DF83),
    decoration: TextDecoration.none,
    fontSize: Dimens.twelve,
    height: 1.4);

//login page//optp page//add card// add card subtitle// settings
TextStyle loginDetailText = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: colorCode(686868),
    fontSize: Dimens.eleven,
    height: 1.4);
//redeem success
TextStyle redeemSuccesss = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: colorCode(686868),
    fontSize: Dimens.forteen,
    height: 1.4); //redeem success
TextStyle redeemSuccesssValue = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: colorCode(686868),
    fontSize: Dimens.forteen,
    height: 1.4);

TextStyle skipTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: colorCode(848490),
    fontSize: Dimens.forteen,
    height: 1.2);

TextStyle appBarTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: Color(0xFF28272C),
    fontSize: Dimens.fifteen,
    height: 1.9);

//release location, add payment text
TextStyle locationTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: colorCode(686868),
    fontSize: Dimens.forteen,
    height: 1.2);

//drawer login
TextStyle drawerTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2F2F2F),
    fontSize: Dimens.forteen,
    height: 1.2);

//drawer login doller
TextStyle drawerRsStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    color: Color(0xFF54DF6C),
    fontSize: Dimens.forteen,
    height: 1.2);

//add card
TextStyle addCardStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    color: Color(0xFF28272C),
    fontSize: Dimens.thrteen,
    height: 1.2);

//add promo card
TextStyle addPromoCodeStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontSize: Dimens.eleven,
    height: 2);

//add promo code
TextStyle addPromoCodeTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twenty,
    color: Colors.white,
    height: 1.4);

//add promo code button
TextStyle addBtnTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.thrteen,
    color: Color(0xFF848490),
    height: 2.2);

//empty string
TextStyle emptyTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twenty,
    color: Color(0xFF28272C),
    height: 1.4);

//add card shwoing list
TextStyle cardSubTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.forteen,
    color: Colors.white,
    height: 1.4);

//add card shwing list//invite friends//history empty screen
TextStyle subTitleTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.forteen,
    color: colorCode(686868),
    height: 1.8);

//add prmo card shwoing list, invite friends
TextStyle addCardTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.forteen,
    decoration: TextDecoration.underline,
    color: Color(0xFF2D2D2D),
    height: 1.4);

//add card shwoing list
TextStyle cardTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.eleven,
    decoration: TextDecoration.underline,
    color: Colors.white.withOpacity(0.5),
    height: 2);

//add card shwoing list
TextStyle cardNumberTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.forteen,
    color: Colors.white,
    height: 1.4);

//add card shwoing list
TextStyle historyTitleTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.eighteen,
    color: Color(0xFF54DF6C),
    height: 2.2);

//add colorCode
Color colorCode(var number) {
  String string = "0xFF${number.toString()}";
  return Color(int.parse(string));
}
