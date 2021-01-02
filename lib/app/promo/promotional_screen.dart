import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/promo_list_model.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_promo_screen.dart';


class PromotionScreen extends StatefulWidget {
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<PromotionScreen> {
  SharedPreferences prefs;
  var emptyUi = false;
  List<PromoCode> promoList ;

  @override
  void initState() {
    super.initState();

    loadShredPref();

    emptyUi = false;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(child: buildBodyUI()));
  }

  void _NavigatetoAddPromos() async {
    /* Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => AddPromosScreen()));
*/
    Map results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => AddPromosScreen()));

    if (results != null && results['response'] == true) {
      getPromosList();
      setState(() {});
    }
  }

  buildBodyUI() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              appBarView(
                  name: AppLocalizations.of(context).translate('promo code'),
                  context: context,
                  callback: () {
                    Navigator.pop(context);
                  }),

              promoList==null?Expanded(child: Center(child: Center(
                child: CircularProgressIndicator(),
              ),)):Container(
                height: MediaQuery.of(context).size.height * .68,
                margin: EdgeInsets.fromLTRB(screenPadding, 0, screenPadding, 0),
                child: emptyUi
                    ? Container(
                  // margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  height: MediaQuery.of(context).size.height * .60,
                  alignment: Alignment.center,
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 160,
                              height: 220,
                              // color: Colors.red,
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 40),
                              //alignment: Alignment.bottomLeft,
                              child: Image.asset(
                                'assets/images/add_card_empty.png',
                              )),
                          Text(
                            //No promo-codes available yet
                            AppLocalizations.of(context).translate('No promo-codes available yet'),
                            style: emptyTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                )
                    : promosList(),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: buttonView(
                    text: AppLocalizations.of(context).translate('ADD PROMO-CODE').toUpperCase(),
                    callback: () {
                      _NavigatetoAddPromos();
                    }),
                margin:
                EdgeInsets.only(left: screenPadding, right: screenPadding,bottom: 50),
              ),


            ],
          ),
        ],
      ),
    );
  }

  promosList() {
    return ListView.builder(
        itemCount: promoList.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext ctxt, int index) {
          return promosItemUI(index);
        });
  }

  promosItemUI(index) {
    return new Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xff7174DF).withOpacity(0.44),
                  offset: Offset(0,4),
                  blurRadius: 10
              )
            ],
            gradient:
            MyUtils.gradientColor(Color(0xFF9D77E8), Color(0xFF9064EA))),
        child: InkWell(
          onTap: () {

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('promo code'),
                style: addPromoCodeStyle,
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(promoList[index].name,
                    style: addPromoCodeTextStyle),
              ),
              SizedBox(
                height: 5,
              ),

              Text(promoList[index].description,
                  style: cardSubTextStyle,
                  textDirection: TextDirection.ltr),
            ],
          ),
        ));
  }

  getPromosList() {
    var apicall = getPromoCodeApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        log("getPromosList$jsonResponse");
        if (jsonResponse['status'].toString() == "1") {
          PromosListPojo stationsListPojo =
          PromosListPojo.fromJson(jsonResponse);
          promoList=[];
          promoList = stationsListPojo.promoCodes;
          print(promoList.length);
          if (promoList.length == 0) {
            emptyUi = true;
          } else {
            emptyUi = false;
          }

          setState(() {});
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
      print('error : $error');
    });
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    getPromosList();
  }
}
