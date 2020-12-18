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
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/CreditCardListPojo.dart';
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
              appBarView(
                  name: AppLocalizations.of(context).translate("PAYMENTS")
                      .toUpperCase()
                      .toUpperCase(),
                  context: context,
                  callback: (){
                    Navigator.pop(context);
                  },
                  isEnableBack: true
              ),
              SizedBox(height: 12,),
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
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate("Why add payment method?"),
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Color(0xff2F2F2F), fontSize: 16,
                fontFamily: 'Montserrat',
                height: 1.2,fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context).translate("payment_text"),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color(0xff686868),
              height: 1.4,
              fontFamily: 'Montserrat',
              fontSize: 14, /*fontWeight: FontWeight.bold*/
            ),
          ),
        ],
      ),
    );
  }

  title() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Text(AppLocalizations.of(context).translate("Payment methods"),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          textDirection: TextDirection.ltr),
    );
  }

  createBillingAgreementApi() {
    var apicall = getCreateBillingAgreementApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) async {
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
        } else if (jsonResponse['status'].toString() == "0") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  paypalButtonUI() {
    return GestureDetector(
        onTap: () {
          //callAddCardApi();
          createBillingAgreementApi();
          // Navigator.of(context).push(new MaterialPageRoute(
          //     builder: (BuildContext context) => AgreePaypalTermsConditionScreen()));
          // createBillingAgreementApi();
        },
        child: new Container(
            height: 45,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            // padding: const EdgeInsets.all(3.0),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: new BoxDecoration(
              //color: Colors.green,
              border: Border.all(color: Colors.black12),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 24,
                      width: 24,
                      child: SvgPicture.asset(
                        'assets/images/paypal.svg',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(AppLocalizations.of(context).translate("PayPal"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff2F2F2F),
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal),
                          textDirection: TextDirection.ltr),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    height: 24,
                    width: 30,
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
  appleButtonUI() {
    return GestureDetector(
        onTap: () {

        },
        child: new Container(
            height: 45,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            // padding: const EdgeInsets.all(3.0),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: new BoxDecoration(
              //color: Colors.green,
              border: Border.all(color: Colors.black12),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 24,
                      width: 24,
                      child: SvgPicture.asset(
                        'assets/images/apple.svg',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text('Apple Pay',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff2F2F2F),
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal),
                          textDirection: TextDirection.ltr),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    height: 24,
                    width: 30,
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
          //callAddCardApi();
          _NavigatetoAddCard();
          //Navigator.of(context).pushNamed('/Signup');
        },
        child: new Container(
            height: 45,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
            // padding: const EdgeInsets.all(3.0),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: new BoxDecoration(
              //color: Colors.green,
              border: Border.all(color: Colors.black12),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 24,
                      width: 24,
                      child: SvgPicture.asset(
                        'assets/images/menu-payment.svg',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                          AppLocalizations.of(context).translate("Credit card"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff2F2F2F),
                              fontSize: 14,
                              fontFamily: 'Montserrat',

                              fontWeight: FontWeight.normal),
                          textDirection: TextDirection.ltr),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    height: 24,
                    width: 30,
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

  creditCardItemUI(index) {
    return new Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        // padding: const EdgeInsets.all(3.0),
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: new BoxDecoration(
          color: Colors.black12,
          // border: Border.all(color: Colors.black12),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 24,
                  width: 24,
                  child: conditionalCardTypesAndPaypal(creditCardList[
                  index]), //for different card type icons and paypal
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text(
                      creditCardList[index].paymentMethod == "CreditCard"
                          ? creditCardList[index].number
                          : creditCardList[index].payerEmail,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color(0xff2F2F2F),
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                      textDirection: TextDirection.ltr),
                ),
              ],
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  showAlertDialog1(context, creditCardList[index].id);
                },
                child: Container(
                  height: 24,
                  width: 30,
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
    return
      (creditCardList!=null&&creditCardList.length==0)?Container():
      creditCardList == null
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

  getCreditCardList() {
    var apicall = getCreditCardListApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        creditCardList=[];
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          CreditCardListPojo stationsListPojo =
          CreditCardListPojo.fromJson(jsonResponse);
          creditCardList = stationsListPojo.creditCards;
          setState(() {});
        } else if (jsonResponse['status'].toString() == "0") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
        }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  deleteCreditCard(cardId) {
    var apicall =
    deleteCreditCardApi(cardId, prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //MyUtils.showAlertDialog(jsonResponse['message'].toString());
        if (jsonResponse['status'].toString() == "1") {
          getCreditCardList();
          setState(() {});
        } else if (jsonResponse['status'].toString() == "0") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
        }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    getCreditCardList();
    // creditCardList=[];

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
                  SizedBox(height: 10,),
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
                  SizedBox(height: 30,),
                  Text(AppLocalizations.of(context).translate("Remove payment method?"),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),

                  Text(AppLocalizations.of(context).translate("Are you sure you want to delete your payment method?"),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),),

                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: () {
                      deleteCreditCard(cardId.toString());
                      Navigator.of(context).pop();              },
                    child: Container(
                      // margin: new EdgeInsets.fromLTRB(0,0,0,0),
                      height: 45,
                      width: 250,
                      child: new Center(
                        child: new Text(AppLocalizations.of(context).translate("Ok"),
                            style: new TextStyle(
                                color:
                                Colors.white,
                                //fontWeight: FontWeight.bold,
                                fontSize: 14.0, fontWeight: FontWeight.bold)),
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
                  color:
                  Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 14.0, fontWeight: FontWeight.bold)),
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
                  color:
                  Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 14.0, fontWeight: FontWeight.bold)),
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
      content: Text(AppLocalizations.of(context).translate("Are you sure you want to delete?")),
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

  _launchURL(finalUrl) async {
    var url = finalUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
