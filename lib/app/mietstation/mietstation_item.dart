import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/color_list.dart';

import 'near_by_stationlist_item.dart';

class MietStationItem extends StatelessWidget {
  NearbyLocation nearbyLocation;

  MietStationItem({this.nearbyLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 15, left: 30, right: 30),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffEBEBEB),
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        child: Image.asset(
                          'assets/images/mietstation.png',
                        )),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      nearbyLocation.open
                          ? AppLocalizations.of(context).translate("Open")
                          : AppLocalizations.of(context).translate("Close"),
                      style: TextStyle(
                          fontSize: 11.0,
                          height: 1.5,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color:
                              nearbyLocation.open ? Colors.green : Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        nearbyLocation.category,
                        style: TextStyle(
                            fontSize: 11.0,
                            height: 1.5,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: lightGray_text),
                      ),
                      Text(
                        nearbyLocation.name,
                        style: TextStyle(
                            fontSize: 18.0,
                            height: 1.5,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Color(0xff28272C)),
                      ),
                      Text(
                        nearbyLocation.address,
                        style: TextStyle(
                            fontSize: 14.0,
                            height: 1.2,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: lightGray_text),
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset('assets/images/battery_small.svg'),
                          SizedBox(
                            width: 7.0,
                          ),
                          Text(
                            nearbyLocation.availablePowerbanks.toString(),
                            style: TextStyle(
                                fontSize: 12.0,
                                height: 1,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: lightGray_text),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          SvgPicture.asset('assets/images/star_small.svg'),
                          SizedBox(
                            width: 7.0,
                          ),
                          Text(
                            nearbyLocation.freeSlots.toString(),
                            style: TextStyle(
                                fontSize: 12.0,
                                height: 1,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: lightGray_text),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          SvgPicture.asset(
                            'assets/images/location_small.svg',
                            color: Color(0xff54DF6C),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          Text(
                            nearbyLocation.distance.toString(),
                            style: TextStyle(
                                fontSize: 12.0,
                                height: 1,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: lightGray_text),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              height: 1.0,
              color: Color(0xffEBEBEB),
            )
          ],
        ),
      ),
    );
  }
}
