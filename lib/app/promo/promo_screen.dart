import 'package:flutter/material.dart';
import 'package:recharge_now/app/promo/invite_screen.dart';
import 'package:recharge_now/app/promo/promotional_screen.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/my_utils.dart';

class PromoCodeScreen extends StatefulWidget {
  @override
  _PromoCodeScreenState createState() => _PromoCodeScreenState();
}

//
class _PromoCodeScreenState extends State<PromoCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appBarView(
              name: AppLocalizations.of(context).translate('promo code'),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: MyUtils.gradientColor(
                    Color(0xFF9D77E8), Color(0xFF9064EA))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 6),
                  child: Text(
                    AppLocalizations.of(context).translate('promo code'),
                    style: addPromoCodeStyle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        /**/
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                  "${AppLocalizations.of(context)
                                      .translate('ADD PROMO CODE')}\n",
                                  maxLines: 2,
                                  softWrap: true,
                                  style: addPromoCodeTextStyle),
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: 25),
                                padding: EdgeInsets.only(left: 54, right: 54,top: 3,bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF2F3F7),
                                    borderRadius: BorderRadius.all(Radius.circular(50))),
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('add'),
                                    textAlign: TextAlign.center,
                                    style: addBtnTextStyle),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PromotionScreen()));
                              },
                            )
                          ],
                        )),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 110,
                        child: Image.asset("assets/images/add.png"),
                      ),
                    )
                  ],
                )
              ],
            ),
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 25,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: MyUtils.gradientColor(
                    Color(0xFF54DF6C), Color(0xFF54DF83))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 6),
                  child: Text(
                    AppLocalizations.of(context).translate('INVITATION CODE'),
                    style: addPromoCodeStyle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        /**/
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                  AppLocalizations.of(context).translate(
                                      'Invite friends and receive bonus'),
                                  style: addPromoCodeTextStyle),
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: 25),
                                padding: EdgeInsets.only(left: 54, right: 54,top: 3,bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF2F3F7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('Invite'),
                                    style: addBtnTextStyle),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            InviteFriendsScreen()));
                              },
                            )
                          ],
                        )),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 110,
                        child: Image.asset("assets/images/invite.png"),
                      ),
                    )
                  ],
                )
              ],
            ),
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 25,
            ),
          ),
        ],
      ),
    );
  }
}
