import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'dart:convert';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';
import 'package:recharge_now/utils/paymentutils/PaymentCard.dart';
import 'package:recharge_now/utils/paymentutils/input_formatters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCard extends StatefulWidget {
  @override
  AddCardState createState() => AddCardState();
}

class AddCardState extends State<AddCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  String creditCardNumber = "", expriryDate = "", cvv;
  int month, year;
  SharedPreferences prefs;
  TextEditingController cardHolderName=TextEditingController();
  TextEditingController carNumberControler=TextEditingController();
  TextEditingController cardDueDateController=TextEditingController();

  @override
  void initState() {
    super.initState();
    loadShredPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              appBarView(
                  name: "ADD CREDIT CARD",
                  context: context,
                  callback: () {
                    Navigator.pop(context);
                  }),
              Container(
                height: MediaQuery.of(context).size.width * .40,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0,4),
                        color: Color(0xff7174DF).withOpacity(0.44),
                      )
                    ],
                    gradient: MyUtils.gradientColor(
                        Color(0xFF9154DF), Color(0xFF5494DF))),
                margin: EdgeInsets.fromLTRB(
                    screenPadding, screenPadding, screenPadding, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.asset("asssts/images/card_view,png"),
                    ),
                    Text(
                      "Card number",
                      style: cardTextStyle,
                    ),
                    Text(
                      "5525 5256 5264 8989",
                      style: cardNumberTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Holder Name",
                                  style: cardTextStyle,
                                ),
                                Text(
                                  "Mr. RechargeNow",
                                  style: cardNumberTextStyle,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Valid until",
                                  style: cardTextStyle,
                                ),
                                Text(
                                  "04/24",
                                  style: cardNumberTextStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Form(
                  key: _formKey,
                  autovalidate: _validate,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(
                                screenPadding, 24, screenPadding, 7),
                            child: Text("Card Number", style: loginDetailText)),
                      ),
                      Container(
                        decoration: MyUtils.showRoundCornerDecoration(),
                        margin: EdgeInsets.fromLTRB(
                            screenPadding, 0, screenPadding, 14),
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            new LengthLimitingTextInputFormatter(19),
                            new CardNumberInputFormatter()
                          ],
                          style: addCardStyle,
                          // cursorColor: Colors.greenAccent,
                          // cursorRadius: Radius.circular(16.0),
                          // cursorWidth: 16.0,
                          validator: CardUtils.validateCardNum,
                          decoration: InputDecoration(
                              hintText: "XXXX XXXX XXXX XXXX",
                              hintStyle: addCardStyle,
                              border: InputBorder.none,
                              fillColor: Colors.deepOrange,
                              focusColor: Colors.deepOrange,
                              hoverColor: Colors.deepOrange),

                          onSaved: (text) {
                            //creditCardNumber = text;
                            creditCardNumber = CardUtils.getCleanedNumber(text);
                            setState(() {});
                          },
                        ),
                      ),
                      secondUI(),
                    ],
                  )),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: buttonView(
                    text: "Add  Card",
                    callback: () {
                      _ValidateForm();
                    }),
                margin:
                EdgeInsets.only(left: screenPadding, right: screenPadding),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  secondUI() {
    return Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin:
                        EdgeInsets.fromLTRB(screenPadding, 0, screenPadding, 7),
                        child: Text("Expiration Date", style: loginDetailText)),
                  ),
                  Container(
                    decoration: MyUtils.showRoundCornerDecoration(),
                    margin: EdgeInsets.fromLTRB(screenPadding, 0, screenPadding, 5),
                    padding: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,

                      style: addCardStyle,
                      // cursorColor: Colors.greenAccent,
                      // cursorRadius: Radius.circular(16.0),
                      // cursorWidth: 16.0,
                      validator: CardUtils.validateDate,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        new LengthLimitingTextInputFormatter(4),
                        new CardMonthInputFormatter()
                      ],

                      decoration: InputDecoration(
                          hintText: "MM/YY",
                          border: InputBorder.none,
                          hintStyle: addCardStyle,
                          // labelText: "Credit Card",
                          fillColor: Colors.deepOrange,
                          focusColor: Colors.deepOrange,
                          hoverColor: Colors.deepOrange),

                      onSaved: (text) {
                        expriryDate = text;
                        List<int> expiryDate = CardUtils.getExpiryDate(text);
                        month = expiryDate[0];
                        year = expiryDate[1];
                        print(month);
                        print(year);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin:
                        EdgeInsets.fromLTRB(screenPadding, 0, screenPadding, 7),
                        child: Text("CVV", style: loginDetailText)),
                  ),
                  Container(
                    decoration: MyUtils.showRoundCornerDecoration(),
                    margin: EdgeInsets.fromLTRB(screenPadding, 0, screenPadding, 7),
                    padding: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      //maxLength: 3,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      // cursorColor: Colors.greenAccent,
                      // cursorRadius: Radius.circular(16.0),
                      // cursorWidth: 16.0,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).translate("This field is required");
                        }
                        if (value.length < 3 || value.length > 3) {
                          return "CVV ist ungültig";
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                          hintText: "123",
                          border: InputBorder.none,
                          hintStyle: addCardStyle,
                          // labelText: "Credit Card",
                          fillColor: Colors.deepOrange,
                          focusColor: Colors.deepOrange,
                          hoverColor: Colors.deepOrange),

                      onSaved: (text) {
                        cvv = text;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _ValidateForm() {
    //Navigator.of(context).pushReplacementNamed('/seondScreen');
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      // callAddCardApi();
      addCard();
      // Navigator.of(context).pushNamed('/HomePage');
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
    //print("Email33333>>> " + email.toString().trim());
    //  Navigator.of(context).pushNamed('/HomePage');
  }

  addCard() {
    var req = {
      "number": creditCardNumber,
      "expireMonth": month,
      "expireYear": year,
      "type": "",
      "cvv2": cvv
    };
    debugPrint("add_card_response  $req");
    //MyUtils.showLoaderDialog(context);
    var jsonReqString = json.encode(req);
    var apicall = addCreditCardApi(prefs.get('userId').toString(),
        jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      debugPrint("add_card_response   ${response.body}");
      //Navigator.pop(context);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          // MyUtils.showAlertDialog(jsonResponse['message'].toString());
          if (jsonResponse['status'].toString() == "1") {
            Navigator.of(context).pop({'response': true});
          }
        } else if (jsonResponse['status'].toString() == "0") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      //Navigator.pop(context);
      print('error : $error');
    });
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
  }
}
