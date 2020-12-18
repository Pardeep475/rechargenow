import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/color_list.dart';

import 'near_by_stationlist_item.dart';


class MietStationDetailScreen extends StatefulWidget {

  NearbyLocation nearbyLocation;     //map location and nearbylocation both pojo are same

  MietStationDetailScreen({this.nearbyLocation});
  @override
  State<StatefulWidget> createState() {
    return _MietStationState();
  }
}

class _MietStationState extends State<MietStationDetailScreen> {

  var today_Day="";
  DateTime date;
  var daysHours=List<String>();
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

    if(widget.nearbyLocation.mondayClosed==false) {
      daysHours.add(widget.nearbyLocation.mondayHours);
    }else{
      daysHours.add(AllString.closed);
    }
    if(widget.nearbyLocation.tuesdayClosed==false) {
      daysHours.add(widget.nearbyLocation.tuesdayHours);
    }else{
      daysHours.add(AllString.closed);
    }
    if(widget.nearbyLocation.wednesdayClosed==false) {
      daysHours.add(widget.nearbyLocation.wednesdayHours);
    }else{
      daysHours.add(AllString.closed);
    }
    if(widget.nearbyLocation.thursdayClosed==false) {
      daysHours.add(widget.nearbyLocation.thursdayHours);
    }else{
      daysHours.add(AllString.closed);
    }
    if(widget.nearbyLocation.fridayClosed==false) {
      daysHours.add(widget.nearbyLocation.fridayHours);
    }else{
      daysHours.add(AllString.closed);
    }

    if(widget.nearbyLocation.saturdayClosed==false) {
      daysHours.add(widget.nearbyLocation.saturdayHours);
    }else{
      daysHours.add(AllString.closed);
    }

    if(widget.nearbyLocation.sundayClosed==false) {
      daysHours.add(widget.nearbyLocation.sundayHours);
    }else{
      daysHours.add(AllString.closed);
    }


    date = DateTime.now();
    if(date.weekday==1){
      //today_Day="Monday";
      today_Day=daysArray[0];
    }else if(date.weekday==2){
      //today_Day="Tuesday";
      today_Day=daysArray[1];

    }else if(date.weekday==3){
      //today_Day="Wednesday";
      today_Day=daysArray[2];

    }else if(date.weekday==4){
      // today_Day="Thursday";
      today_Day=daysArray[3];

    }else if(date.weekday==5){
      // today_Day="Friday";
      today_Day=daysArray[4];

    }else if(date.weekday==6){
      // today_Day="Saturday";
      today_Day=daysArray[5];

    }else if(date.weekday==7){
      // today_Day="Sunday";
      today_Day=daysArray[6];

    }
    print("weekday is ${date.weekday}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: ListView(

          children: <Widget>[
            SizedBox(
              height: 53,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset('assets/images/back.svg')),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5 - 117.5,
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: Container(
                      height: 70.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xffEBEBEB),
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius:
                          BorderRadius.all(Radius.circular(12.0))),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: widget.nearbyLocation.imageFullPath,
                          height: 70.0,
                          width: 70.0,
                          errorWidget:(a,d,c){
                            return Image.asset(
                              'assets/images/mietstation.png',
                            );
                          } ,
                          placeholder: (a,b){
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
              height: 19.0,
            ),
            shopTitleTExt(),
            SizedBox(
              height: 19.0,
            ),
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
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      widget.nearbyLocation.distance.toString(),
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
            SizedBox(
              height: 13.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                        color: Color(0xffF2F3F7),
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    child: roundBoxItem(
                        img: 'assets/images/battery_small.svg',
                        str: AppLocalizations.of(context).translate("Available"),
                        value:widget.nearbyLocation.availablePowerbanks.toString()),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                          color: Color(0xffF2F3F7),
                          borderRadius:
                          BorderRadius.all(Radius.circular(50.0))),
                      child: roundBoxItem(
                          img: 'assets/images/star_small.svg',
                          str: AppLocalizations.of(context).translate("Free"),
                          value: widget.nearbyLocation.freeSlots.toString())),
                )
              ],
            ),
            SizedBox(
              height: 17.0,
            ),
            Divider(
              height: 1.0,
              thickness: 1.2,
              color: Color(0xffEBEBEB),
            ),
            SizedBox(
              height: 17.0,
            ),
            informationText(AppLocalizations.of(context).translate("Information")),
            SizedBox(
              height: 6.0,
            ),
            discriptionText(widget.nearbyLocation.description.toString()),
            SizedBox(
              height: 17.0,
            ),
            Divider(
              height: 1.0,
              thickness: 1.2,
              color: Color(0xffEBEBEB),
            ),
            SizedBox(
              height: 17.0,
            ),
            informationText(AppLocalizations.of(context).translate("Location")),
            SizedBox(
              height: 6.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    'assets/images/location_small.svg',
                    color: Color(0xff54DF6C),
                  ),
                ),
                SizedBox(
                  width: 18.0,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    widget.nearbyLocation.address.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.0,
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 50,

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                  color: Colors.black.withOpacity(0.15))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(53))),
                        child: SvgPicture.asset('assets/images/up_arrow.svg'),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Divider(
              height: 1.0,
              thickness: 1.2,
              color: Color(0xffEBEBEB),
            ),
            SizedBox(
              height: 15.0,
            ),
            informationText(AppLocalizations.of(context).translate("Opening hours"),),
            SizedBox(
              height: 6.0,
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
          fontSize: 18.0,
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
          fontSize: 14.0,
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
          width: 7.0,
        ),
        Text(
          '$value $str',
          style: TextStyle(
              fontSize: 12.0,
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
      widget.nearbyLocation.category.toString(),
      style: TextStyle(
          fontSize: 11.0,
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
          fontSize: 20.0,
          height: 1.3,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: text_black),
    );
  }

  listViewDaysSelection() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 300),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: daysArray.length,
          itemBuilder: (BuildContext context, int position) {

            return WeekDaysSelection(

              dayName: today_Day==daysArray[position]?AppLocalizations.of(context).translate("Today")+"!":daysArray[position],
              isSelected: today_Day==daysArray[position]?true:false,
              isHighlighted:position %2!=0? false:false,
              timing: daysHours[position].toString(),
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

  WeekDaysSelection(
      {this.isSelected, this.dayName, this.isHighlighted, this.timing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, ),
      decoration: BoxDecoration(
          color: timing=='Closed'?Colors.white: isSelected
              ? Color(0xff54DF83)
              : isHighlighted ? Color(0xffF2F3F7) : Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8,top: 8,left: 8),
            child: Text(dayName,style: TextStyle(
                fontSize: 14.0,
                height: 2,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                color: isSelected?Colors.white:lightGray_text
            ),),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8,top: 8,right: 12),
            child: Text(timing,style: TextStyle(
                fontSize: 14.0,
                height: 2,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                color: timing=='Closed'?Colors.red:isSelected?Colors.white:lightGray_text
            ),),
          )
        ],
      ),
    );
  }
}
