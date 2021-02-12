// ItemStationTower
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/station_list_model.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/color_list.dart';

import '../myStyle.dart';

class ItemPanelTower extends StatelessWidget {
  final void Function(MapLocation) onNavigationPressed;
  final void Function(MapLocation) onDetailPressed;
  final MapLocation data;

  ItemPanelTower({this.onNavigationPressed, this.onDetailPressed, this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Wrap(
      verticalDirection: VerticalDirection.down,
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: Dimens.twentyFive,
                  top: Dimens.twentyFive,
                  right: Dimens.twentyFive,
                  bottom: Dimens.thirty),
              margin: EdgeInsets.only(
                top: Dimens.oneEightyFive,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              height: Dimens.twenty,
                              width: Dimens.twenty,
                              child: SvgPicture.asset(
                                "assets/images/close-black.svg",
                                fit: BoxFit.none,
                              ),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.seventyOne,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: Dimens.eighty,
                            width: Dimens.eighty,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffEBEBEB),
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.twelve),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: data.imageFullPath,
                              height: Dimens.seventy,
                              width: Dimens.seventy,
                              // errorWidget: (a, d, c) {
                              //   return Image.asset(
                              //     'assets/images/mietstation.png',
                              //   );
                              // },
                              // placeholder: (a, b) {
                              //   return Image.asset(
                              //     'assets/images/mietstation.png',
                              //   );
                              // },
                            ),
                          ),
                          SizedBox(
                            height: Dimens.sixteen,
                          ),
                          Text(
                            data.open
                                ? AppLocalizations.of(context)
                                    .translate("Open")
                                    .toUpperCase()
                                : AppLocalizations.of(context)
                                    .translate("Close")
                                    .toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.0,
                                height: 1.5,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: data.open
                                    ? primaryGreenColor
                                    : Color(0xffF44336)),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: Dimens.sixteen,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data.category.toUpperCase(),
                              style: TextStyle(
                                  fontSize: Dimens.eleven,
                                  height: 1.5,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: lightGray_text),
                            ),
                            Text(
                              data.name,
                              style: TextStyle(
                                  fontSize: Dimens.eighteen,
                                  height: 1.5,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff28272C)),
                            ),
                            Text(
                              '${data.address}\n',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: Dimens.forteen,
                                  height: 1.2,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  color: lightGray_text),
                            ),
                            SizedBox(
                              height: Dimens.sixteen,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SvgPicture.asset(
                                    'assets/images/battery_small.svg'),
                                SizedBox(
                                  width: Dimens.seven,
                                ),
                                Text(
                                  '${data.availablePowerbanks}',
                                  style: TextStyle(
                                      fontSize: Dimens.twelve,
                                      height: 1,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: lightGray_text),
                                ),
                                SizedBox(
                                  width: Dimens.fifteen,
                                ),
                                SvgPicture.asset(
                                    'assets/images/star_small.svg',color: Color(0xFF54DF6C),),
                                SizedBox(
                                  width: Dimens.seven,
                                ),
                                Text(
                                  '${data.freeSlots}',
                                  style: TextStyle(
                                      fontSize: Dimens.twelve,
                                      height: 1,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: lightGray_text),
                                ),
                                SizedBox(
                                  width: Dimens.fifteen,
                                ),
                                SvgPicture.asset(
                                  'assets/images/location_small.svg',
                                  color: Color(0xff54DF6C),
                                ),
                                SizedBox(
                                  width: Dimens.seven,
                                ),
                                Text(
                                  '${data.distance}',
                                  style: TextStyle(
                                      fontSize: Dimens.twelve,
                                      height: 1,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: lightGray_text),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimens.twentySeven,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onNavigationPressed(data);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.1,
                          padding: EdgeInsets.only(
                              top: Dimens.twelve, bottom: Dimens.fifteen),
                          decoration: BoxDecoration(
                              color: Color(0xffF2F3F7),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.fifty))),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("Navigate")
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: Dimens.thrteen,
                                height: 1.5,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff848490)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onDetailPressed(data);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.1,
                          padding: EdgeInsets.only(
                              top: Dimens.twelve, bottom: Dimens.fifteen),
                          decoration: BoxDecoration(
                              color: primaryGreenColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.fifty))),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("Details")
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: Dimens.thrteen,
                                height: 1.5,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: Dimens.twoHundredFifty,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: Dimens.twentyOne,
                            right: Dimens.twentyOne,
                            bottom: Dimens.twentyOne),
                        child: SizedBox(
                            height: Dimens.twoHundredTwoFive,
                            width: Dimens.seventy,
                            child: SvgPicture.asset(
                                'assets/images/panelstation.svg')),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: Dimens.fortyTwo,
                          width: Dimens.fortyTwo,
                          alignment: Alignment.bottomRight,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryGreenColor.withOpacity(0.5),
                          ),
                          child: Container(
                            height: Dimens.fortyTwo,
                            width: Dimens.fortyTwo,
                            margin: EdgeInsets.all(Dimens.six),
                            alignment: Alignment.bottomRight,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryGreenColor.withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                '${data.totalStaions}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: Dimens.forteen,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
