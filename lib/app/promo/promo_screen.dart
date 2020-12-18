import 'package:flutter/material.dart';
import 'package:recharge_now/app/promo/invite_screen.dart';
import 'package:recharge_now/app/promo/promotional_screen.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/my_utils.dart';

class PromoCodeScreen extends StatefulWidget {
  @override
  _PromoCodeScreenState createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appBarView(
              name: "Promo - Code",
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
                    "Promo-Code".toUpperCase(),
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
                              child: Text("Add \nPromo-Code",
                                  style: addPromoCodeTextStyle),
                            ),
                            GestureDetector(
                              child: Container(
                                height: 36,
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.only(left: 54, right: 54),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF2F3F7),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                                child: Text("Add", style: addBtnTextStyle),
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
                    "INVITATION CODE",
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
                              child: Text("Invite friends & receive bonus",
                                  style: addPromoCodeTextStyle),
                            ),
                            GestureDetector(
                              child: Container(
                                height: 36,
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.only(left: 54, right: 54),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF2F3F7),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                                child: Text("Invite", style: addBtnTextStyle),
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
