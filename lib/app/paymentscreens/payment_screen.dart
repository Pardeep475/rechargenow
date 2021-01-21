import 'dart:convert';
import 'package:platform/platform.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/paymentscreens/add_card_screen.dart';
import 'package:recharge_now/app/paymentscreens/payment_webview_screen.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/custom_widgets/common_error_dialog.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/CreditCardListPojo.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Payments extends StatefulWidget {
  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payments> {
  List<String> litems = ["1", "2", "Third", "4"];
  SharedPreferences prefs;

  List<CreditCard> creditCardList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadShredPref();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          appBarViewCross(
              name: AppLocalizations.of(context).translate("Payment methods"),
              context: context,
              callback: () {
                Navigator.pop(context);
              },
              isEnableBack: true),
          SizedBox(
            height: Dimens.fifteen,
          ),
          cardList(),
          paypalButtonUI(),
          //appleButtonUI(),
          creditCardButtonUI(),
          paymentText()
          // callApi()
        ],
      ),
    ));
  }

  paymentText() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.twentyThree, 0, Dimens.twentyThree, Dimens.twentyThree),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate("Why add payment method?"),
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Color(0xff2F2F2F),
                fontSize: Dimens.eighteen,
                fontFamily: 'Montserrat',
                height: 1.2,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: Dimens.twelve,
          ),
          Text(
            AppLocalizations.of(context).translate("payment_text"),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color(0xff686868),
              height: 1.4,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              fontSize: Dimens.fifteen, /*fontWeight: FontWeight.bold*/
            ),
          ),
        ],
      ),
    );
  }

  title() {
    return Container(
      padding: EdgeInsets.fromLTRB(Dimens.twentyThree, Dimens.twentyThree,
          Dimens.twentyThree, Dimens.six),
      child: Text(AppLocalizations.of(context).translate("Payment methods"),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontSize: Dimens.twentyThree,
              fontWeight: FontWeight.bold),
          textDirection: TextDirection.ltr),
    );
  }

  createBillingAgreementApi() async {
   await getCreateBillingAgreementApi(
            prefs.get('userId').toString(), prefs.get('accessToken').toString())
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //MyUtils.showAlertDialog(jsonResponse['message'].toString());
        if (jsonResponse['status'].toString() == "1") {
          var agreementURL = jsonResponse['agreementURL'];
          //_launchURL(agreementURL);
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  PaymentWebviewScreen(finalUrl: agreementURL)));
        } else {
          _showAnimatedDialog(jsonResponse['message'].toString());
        }
      } else {
        _showAnimatedDialog(
            AppLocalizations.of(context).translate("something_went_wrong"));
      }
    }).catchError((onError) {
      _showAnimatedDialog(
          AppLocalizations.of(context).translate("something_went_wrong"));
    });
  }

  // AppLocalizations.of(context)
  //             .translate("something_went_wrong")
  _showAnimatedDialog(String message) {
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

  paypalButtonUI() {
    return GestureDetector(
        onTap: () {
          createBillingAgreementApi();

          // showAlertDialog(context, "123123");
        },
        child: new Container(
            height: Dimens.fiftyFive,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(
                Dimens.twentyThree, Dimens.twelve, Dimens.twentyThree, 0),
            padding: EdgeInsets.only(left: Dimens.twelve, right: Dimens.twelve),
            decoration: new BoxDecoration(
              //color: Colors.green,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.twelve),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: Dimens.twentyEight,
                      width: Dimens.twentyEight,
                      child: SvgPicture.asset(
                        'assets/images/paypal.svg',
                      ),
                    ),
                    SizedBox(
                      width: Dimens.twelve,
                    ),
                    Container(
                      child: Text(
                          AppLocalizations.of(context).translate("PayPal"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff2F2F2F),
                              fontSize: Dimens.seventeen,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal),
                          textDirection: TextDirection.ltr),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    height: Dimens.twentySeven,
                    width: Dimens.thirtyThree,
                    /* child: SvgPicture.asset(
                      'assets/images/heart.svg',
                    ),*/
                    child: Icon(
                      Icons.chevron_right,
                      // size: screenAwareSize(20.0, context),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )));
  }

  _NavigatetoAddCard() async {
    Map results = await Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => AddCard()));

    if (results != null && results['response'] == true) {
      getCreditCardList();
      setState(() {});
    }
  }

  creditCardButtonUI() {
    return GestureDetector(
        onTap: () {
          _NavigatetoAddCard();
        },
        child: new Container(
            height: Dimens.fiftyFive,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(Dimens.twentyThree, Dimens.twelve,
                Dimens.twentyThree, Dimens.twentyThree),
            padding: EdgeInsets.only(left: Dimens.twelve, right: Dimens.twelve),
            decoration: new BoxDecoration(
              //color: Colors.green,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.twelve),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: Dimens.twentyEight,
                      width: Dimens.twentyEight,
                      child: SvgPicture.asset(
                        'assets/images/menu-payment.svg',
                      ),
                    ),
                    SizedBox(
                      width: Dimens.twelve,
                    ),
                    Container(
                      child: Text(
                          AppLocalizations.of(context).translate("Credit card"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff2F2F2F),
                              fontSize: Dimens.seventeen,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal),
                          textDirection: TextDirection.ltr),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    height: Dimens.twentySeven,
                    width: Dimens.thirtyThree,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )));
  }

  creditCardItemUI(index) {
    return new Container(
        height: Dimens.fiftyFive,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(
            Dimens.twentyThree, Dimens.eight, Dimens.twentyThree, Dimens.three),
        // padding: const EdgeInsets.all(3.0),
        padding: EdgeInsets.only(left: Dimens.twelve, right: Dimens.twelve),
        decoration: new BoxDecoration(
          color: Color(0xFFF2F3F7),
          // border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.twelve),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: Dimens.twentyEight,
                  width: Dimens.twentyEight,
                  child: conditionalCardTypesAndPaypal(creditCardList[
                      index]), //for different card type icons and paypal
                ),
                SizedBox(
                  width: Dimens.twelve,
                ),
                Container(
                  child: Text(
                      creditCardList[index].paymentMethod == "CreditCard"
                          ? creditCardList[index].number
                          : creditCardList[index].payerEmail,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color(0xff2F2F2F),
                          fontSize: Dimens.seventeen,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                      textDirection: TextDirection.ltr),
                ),
              ],
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  // showAlertDialog1(context, creditCardList[index].id);
                  openDialogWithSlideInAnimation(
                    context: context,
                    itemWidget: CommonErrorDialog(
                      title: AppLocalizations.of(context)
                          .translate("Remove payment method?"),
                      descriptions: AppLocalizations.of(context).translate(
                          "Are you sure you want to delete your payment method?"),
                      text: AppLocalizations.of(context).translate("Ok"),
                      img: "assets/images/something_went_wrong.svg",
                      double: 37.0,
                      isCrossIconShow: false,
                      callback: () {
                        debugPrint("delete_card   ${creditCardList[index].id.toString()}");
                        deleteCreditCard(creditCardList[index].id.toString());
                      },
                    ),
                  );
                },
                child: Container(
                  height: Dimens.twentySeven,
                  width: Dimens.thirtyThree,
                  /* child: SvgPicture.asset(
                    'assets/images/heart.svg',
                  ),*/
                  child: Icon(
                    Icons.clear,
                    // size: screenAwareSize(20.0, context),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  conditionalCardTypesAndPaypal(CreditCard creditCardList) {
    var image;
    //  amex, dinner, discover, jcb, maestro, mastercard, rupay, visa"
    if (creditCardList.paymentMethod == "CreditCard") {
      if (creditCardList.type == "amex") {
        image = Image.asset(
          'assets/images/Amex.png',
        );
      } else if (creditCardList.type == "dinner") {
        image = Image.asset(
          'assets/images/DinnerClub.png',
        );
      } else if (creditCardList.type == "discover") {
        image = Image.asset(
          'assets/images/Discover.jpg',
        );
      } else if (creditCardList.type == "jcb") {
        image = Image.asset(
          'assets/images/Jcb.jpeg',
        );
      } else if (creditCardList.type == "maestro") {
        image = Image.asset(
          'assets/images/Maestro.png',
        );
      } else if (creditCardList.type == "mastercard") {
        image = Image.asset(
          'assets/images/MarterCard.png',
        );
      } else if (creditCardList.type == "rupay") {
        image = Image.asset(
          'assets/images/Rupay.png',
        );
      } else if (creditCardList.type == "visa") {
        image = Image.asset(
          'assets/images/Visa.png',
        );
      }
    } else {
      image = SvgPicture.asset(
        'assets/images/paypal.svg',
      );
    }

    return image;
  }

  cardList() {
    return (creditCardList != null && creditCardList.length == 0)
        ? Container()
        : creditCardList == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: creditCardList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return creditCardItemUI(index);
                });
  }

  getCreditCardList() async {
    var apicall = await getCreditCardListApi(
            prefs.get('userId').toString(), prefs.get('accessToken').toString())
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        creditCardList = [];
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          CreditCardListPojo stationsListPojo =
              CreditCardListPojo.fromJson(jsonResponse);
          creditCardList = stationsListPojo.creditCards;
          setState(() {});
        } else {
          _showAnimatedDialog(jsonResponse['message'].toString());
        }
      } else {
        _showAnimatedDialog(
            AppLocalizations.of(context).translate("something_went_wrong"));
      }
    }).catchError((onError) {
      _showAnimatedDialog(
          AppLocalizations.of(context).translate("something_went_wrong"));
    });
  }

  deleteCreditCard(cardId) async {
    await deleteCreditCardApi(cardId, prefs.get('accessToken').toString())
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          getCreditCardList();
          setState(() {});
        } else {
          _showAnimatedDialog(jsonResponse['message'].toString());
        }
      } else {
        _showAnimatedDialog(
            AppLocalizations.of(context).translate("something_went_wrong"));
      }
    }).catchError((onError) {
      _showAnimatedDialog(
          AppLocalizations.of(context).translate("something_went_wrong"));
    });
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    getCreditCardList();
  }

  showAlertDialog1(BuildContext context, cardId) {
    Dialog myDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
        height: 300.0,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                  alignment: Alignment.topRight, child: Icon(Icons.clear)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 300.0,
              // width: 600.0,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 80.0,
                      width: 80.0,
                      child: Image.asset(
                        'assets/images/failure_occured.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate("Remove payment method?"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    AppLocalizations.of(context).translate(
                        "Are you sure you want to delete your payment method?"),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      deleteCreditCard(cardId.toString());
                    },
                    child: Container(
                      // margin: new EdgeInsets.fromLTRB(0,0,0,0),
                      height: 45,
                      width: 250,
                      child: new Center(
                        child: new Text(
                            AppLocalizations.of(context).translate("Ok"),
                            style: new TextStyle(
                                color: Colors.white,
                                //fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold)),
                      ),

                      decoration: new BoxDecoration(
                        color: primaryGreenColor,
                        /* border: new Border.all(
                  width: .5,
                  color:Colors.grey),*/
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => myDialog);
  }

  showAlertDialog(BuildContext context, cardId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      // child: Text(AppLocalizations.of(context).translate("Cancel")),
      child: Container(
        // margin: new EdgeInsets.fromLTRB(0,0,0,0),
        height: 40,
        width: 100,
        child: new Center(
          child: new Text(AppLocalizations.of(context).translate("Cancel"),
              style: new TextStyle(
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold)),
        ),

        decoration: new BoxDecoration(
          color: primaryGreenColor,
          /* border: new Border.all(
              width: .5,
              color:Colors.grey),*/
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      // child: Text(AppLocalizations.of(context).translate("Ok")),
      child: Container(
        // margin: new EdgeInsets.fromLTRB(0,0,0,0),
        height: 40,
        width: 100,
        child: new Center(
          child: new Text(AppLocalizations.of(context).translate("Ok"),
              style: new TextStyle(
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold)),
        ),

        decoration: new BoxDecoration(
          color: primaryGreenColor,
          /* border: new Border.all(
              width: .5,
              color:Colors.grey),*/
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
      ),
      onPressed: () {
        deleteCreditCard(cardId.toString());
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text(AppLocalizations.of(context).translate("Alert")),
      content: Text(AppLocalizations.of(context)
          .translate("Are you sure you want to delete?")),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
