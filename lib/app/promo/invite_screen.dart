import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteFriendsScreen extends StatefulWidget {
  @override
  _InviteFriendsScreenState createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  SharedPreferences prefs;

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
        child: buildBodyUI(),
      ),
    );
  }

  buildBodyUI() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          appBarView(
              name: AppLocalizations.of(context).translate('INVITE FRIENDS'),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: screenPadding,
                        top: screenPadding,
                        right: screenPadding),
                    child: Image.asset(
                      "assets/images/invite_friends.png",
                      height: 150,
                      width: 150,
                    )),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: screenPadding,
                      top: screenPadding,
                      right: screenPadding),
                  child: Text(
                    AppLocalizations.of(context).translate('Invite a friend and get a bonus'),
                    textAlign: TextAlign.center,
                    style: sliderTitleTextStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: screenPadding, top: 5, right: screenPadding),
                  child: Text(
                    AppLocalizations.of(context).translate('invite description'),
                    style: subTitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
                left: screenPadding, top: 8, right: screenPadding),
            child: Text(
              AppLocalizations.of(context).translate('SHARE FRIENDSHIP CODE'),
              textAlign: TextAlign.center,
              style: addCardTextStyle,
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: screenPadding, top: 20, right: screenPadding),
              child: buttonView(text: prefs.get('usercode').toString(), callback: () {
                Share.share("Download die App „RechargeNow“ und lade dein Smartphone unterwegs! Gib den Promo-Code "+prefs.get('usercode').toString()+" ein und erhalte nach der ersten Powerbank Nutzung 5€ auf dein Wallet!");
              })),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }


  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }
}
