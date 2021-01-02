import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/color_list.dart';

import 'near_by_stationlist_item.dart';

class MietStationDetailScreen extends StatefulWidget {
  NearbyLocation
      nearbyLocation; //map location and nearbylocation both pojo are same

  MietStationDetailScreen({this.nearbyLocation});

  @override
  State<StatefulWidget> createState() {
    return _MietStationState();
  }
}

class _MietStationState extends State<MietStationDetailScreen> {
  var today_Day = "";
  DateTime date;
  var daysHours = List<String>();
  var daysArray = [
    'Montag',
    'Dienstag',
    'Mittwoch',
    'Donnerstag',
    'Freitag',
    'Samstag',
    'Sonntag',
  ];

  @override
  void initState() {
    if (widget.nearbyLocation.mondayClosed == false) {
      daysHours.add(widget.nearbyLocation.mondayHours);
    } else {
      daysHours.add(AllString.closed);
    }
    if (widget.nearbyLocation.tuesdayClosed == false) {
      daysHours.add(widget.nearbyLocation.tuesdayHours);
    } else {
      daysHours.add(AllString.closed);
    }
    if (widget.nearbyLocation.wednesdayClosed == false) {
      daysHours.add(widget.nearbyLocation.wednesdayHours);
    } else {
      daysHours.add(AllString.closed);
    }
    if (widget.nearbyLocation.thursdayClosed == false) {
      daysHours.add(widget.nearbyLocation.thursdayHours);
    } else {
      daysHours.add(AllString.closed);
    }
    if (widget.nearbyLocation.fridayClosed == false) {
      daysHours.add(widget.nearbyLocation.fridayHours);
    } else {
      daysHours.add(AllString.closed);
    }

    if (widget.nearbyLocation.saturdayClosed == false) {
      daysHours.add(widget.nearbyLocation.saturdayHours);
    } else {
      daysHours.add(AllString.closed);
    }

    if (widget.nearbyLocation.sundayClosed == false) {
      daysHours.add(widget.nearbyLocation.sundayHours);
    } else {
      daysHours.add(AllString.closed);
    }

    date = DateTime.now();
    if (date.weekday == 1) {
      //today_Day="Monday";
      today_Day = daysArray[0];
    } else if (date.weekday == 2) {
      //today_Day="Tuesday";
      today_Day = daysArray[1];
    } else if (date.weekday == 3) {
      //today_Day="Wednesday";
      today_Day = daysArray[2];
    } else if (date.weekday == 4) {
      // today_Day="Thursday";
      today_Day = daysArray[3];
    } else if (date.weekday == 5) {
      // today_Day="Friday";
      today_Day = daysArray[4];
    } else if (date.weekday == 6) {
      // today_Day="Saturday";
      today_Day = daysArray[5];
    } else if (date.weekday == 7) {
      // today_Day="Sunday";
      today_Day = daysArray[6];
    }
    print("weekday is ${date.weekday}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: Dimens.thirty, right: Dimens.thirty),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: Dimens.fiftyThree,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: Dimens.fifteen),
                      child: SizedBox(
                        height: Dimens.thirty,
                        width: Dimens.forty,
                        child: SvgPicture.asset(
                          'assets/images/back.svg',
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width / 4.3),
                ),
                SizedBox(
                  height: Dimens.hundred,
                  width: Dimens.hundred,
                  child: Container(
                      height: Dimens.hundred,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xffEBEBEB),
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.twelve))),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: widget.nearbyLocation.imageFullPath,
                          height: Dimens.eighty,
                          width: Dimens.eighty,
                          errorWidget: (a, d, c) {
                            return Image.asset(
                              'assets/images/mietstation.png',
                            );
                          },
                          placeholder: (a, b) {
                            return Image.asset(
                              'assets/images/mietstation.png',
                            );
                          },
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: Dimens.sixteen,
            ),
            shopTitleTExt(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                shopNameTExt(),
                Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/location_small.svg',
                      color: Color(0xff54DF6C),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: Dimens.seven,
                    ),
                    Text(
                      widget.nearbyLocation.distance.toString(),
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimens.twelve,
                          color: Color(0xFF848490),
                          height: 2.2),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: Dimens.twelve,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: Dimens.thirty,
                        right: Dimens.thirty,
                        top: Dimens.twelve,
                        bottom: Dimens.fifteen),
                    decoration: BoxDecoration(
                      color: Color(0xffF2F3F7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.fifty),
                      ),
                    ),
                    child: roundBoxItem(
                        img: 'assets/images/battery_small.svg',
                        str:
                            AppLocalizations.of(context).translate("Available"),
                        value: widget.nearbyLocation.availablePowerbanks
                            .toString()),
                  ),
                ),
                SizedBox(
                  width: Dimens.fifteen,
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: Dimens.thirty,
                          right: Dimens.thirty,
                          top: Dimens.twelve,
                          bottom: Dimens.fifteen),
                      decoration: BoxDecoration(
                        color: Color(0xffF2F3F7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.fifty),
                        ),
                      ),
                      child: roundBoxItem(
                          img: 'assets/images/star_small.svg',
                          str: AppLocalizations.of(context).translate("Free"),
                          value: widget.nearbyLocation.freeSlots.toString())),
                )
              ],
            ),
            SizedBox(
              height: Dimens.seventeen,
            ),
            Divider(
              height: 1.0,
              thickness: 1.2,
              color: Color(0xffEBEBEB),
            ),
            SizedBox(
              height: Dimens.fifteen,
            ),
            informationText(
                AppLocalizations.of(context).translate("Information")),
            SizedBox(
              height: Dimens.six,
            ),
            discriptionText(widget.nearbyLocation.description.toString()),
            SizedBox(
              height: Dimens.seventeen,
            ),
            Divider(
              height: 1.0,
              thickness: 1.2,
              color: Color(0xffEBEBEB),
            ),
            SizedBox(
              height: Dimens.seventeen,
            ),
            informationText(AppLocalizations.of(context).translate("Location")),
            SizedBox(
              height: Dimens.six,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: Dimens.five),
                  child: SvgPicture.asset(
                    'assets/images/location_small.svg',
                    color: Color(0xff54DF6C),
                    height: Dimens.twenty,
                    width: Dimens.sixteen,
                  ),
                ),
                SizedBox(
                  width: Dimens.thrteen,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    widget.nearbyLocation.address.toString(),
                    style: TextStyle(
                        fontSize: Dimens.forteen,
                        height: 1.4,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        color: lightblack_text),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(Dimens.eight),
                      child: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: Dimens.eight,
                                  offset: Offset(0, 2),
                                  color: Colors.black.withOpacity(0.15))
                            ],
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.fiftyThree))),
                        child: SvgPicture.asset('assets/images/up_arrow.svg'),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: Dimens.fifteen,
            ),
            Divider(
              height: 1.0,
              thickness: 1.2,
              color: Color(0xffEBEBEB),
            ),
            SizedBox(
              height: Dimens.fifteen,
            ),
            informationText(
              AppLocalizations.of(context).translate("Opening hours"),
            ),
            SizedBox(
              height: Dimens.six,
            ),
            listViewDaysSelection()
          ],
        ),
      ),
    );
  }

  informationText(String str) {
    return Text(
      '$str',
      style: TextStyle(
          fontSize: Dimens.eighteen,
          height: 1.4,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: lightblack_text),
    );
  }

  discriptionText(String description) {
    return Text(
      '$description',
      style: TextStyle(
          fontSize: Dimens.forteen,
          height: 1.4,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          color: lightGray_text),
    );
  }

  roundBoxItem({String img, String str, String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          '$img',
          color: Color(0xff54DF6C),
        ),
        SizedBox(
          width: Dimens.seven,
        ),
        Text(
          '$value $str',
          style: TextStyle(
              fontSize: Dimens.twelve,
              height: 1.4,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: lightGray_text),
        )
      ],
    );
  }

  shopTitleTExt() {
    return Text(
      widget.nearbyLocation.category.toString().toUpperCase(),
      style: TextStyle(
          fontSize: Dimens.eleven,
          height: 1.5,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: lightGray_text),
    );
  }

  shopNameTExt() {
    return Text(
      widget.nearbyLocation.name.toString(),
      style: TextStyle(
          fontSize: Dimens.twenty,
          height: 1.3,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: text_black),
    );
  }

  listViewDaysSelection() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Dimens.threeHundurd),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: daysArray.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int position) {
            debugPrint(
                "WeekDaysSelection   today_Day  $today_Day  daysArray[position]  ${daysArray[position]}  position   $position");
            debugPrint(
                "WeekDaysSelection   text  ${AppLocalizations.of(context).translate("Today") + "!"}  isSelected  ${today_Day == daysArray[position] ? true : false}");
            return WeekDaysSelection(
              dayName: today_Day == daysArray[position]
                  ? AppLocalizations.of(context).translate("Today") + "!"
                  : daysArray[position],
              isSelected: today_Day == daysArray[position] ? true : false,
              isHighlighted: position % 2 != 0 ? false : false,
              timing: daysHours[position].toString(),
              pos: position,
            );
          }),
    );
  }
}

class WeekDaysSelection extends StatelessWidget {
  var isSelected;
  var isHighlighted;
  var dayName;
  var timing;
  int pos;

  WeekDaysSelection(
      {this.isSelected,
      this.dayName,
      this.isHighlighted,
      this.timing,
      this.pos});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        pos == 0
            ? SvgPicture.asset("assets/images/icon_timing.svg")
            : SizedBox(
                width: 18,
              ),
        SizedBox(
          width: 9,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                color: isSelected ? Color(0xff54DF83) : Color(0xffffffff),
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 11),
                  child: Text(
                    dayName,
                    style: TextStyle(
                        fontSize: 14.0,
                        height: 2,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        color: isSelected ? Colors.white : lightGray_text),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 11),
                  child: Text(
                    timing,
                    style: TextStyle(
                        fontSize: 14.0,
                        height: 2,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        color: timing == 'Closed' || timing == "Geschlossen"
                            ? Colors.red
                            : isSelected
                                ? Colors.white
                                : lightGray_text),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
