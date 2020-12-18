import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:recharge_now/app/mietstation/mietstation_detail.dart';
import 'package:recharge_now/app/mietstation/near_by_stationlist_item.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/models/station_list_model.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:recharge_now/utils/color_list.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetWidget extends StatefulWidget {
  MapLocation data;
  int type;
  bool isLongImage;
  String slotTypeFilePath;
  BottomSheetWidget(this. data, {this.type,this.isLongImage,this.slotTypeFilePath});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {

  onStartNavigationClicked(MapLocation data) async {
    String origin = "" +
        MyConstants.currentLat.toString() +
        "," +
        MyConstants.currentLong.toString(); // lat,long like 123.34,68.56

    print(origin);
    String destination = data.latitude + "," + data.longitude;
    if (Platform.isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data:
          Uri.encodeFull("https://www.google.com/maps/dir/?api=1&origin=" +
              /* origin +*/ "&destination=" +
              destination +
              "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    } else {
      String url =
          "https://www.google.com/maps/dir/?api=1&origin=" /*+ origin */ +
              "&destination=" +
              destination +
              "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: widget.isLongImage?80:60, left: 18, right: 18, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          child: Center(
            child: Wrap(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 12,
                        ),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child:  CachedNetworkImage(
                                  imageUrl: widget.data.imageFullPath,
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

                                )),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              widget.data.open?'Open':'Closed',
                              style: TextStyle(
                                  fontSize: 11.0,
                                  height: 1.5,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color:  widget.data.open?primaryGreenColor:Color(0xffF44336)),
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
                                widget.data.category,
                                style: TextStyle(
                                    fontSize: 11.0,
                                    height: 1.5,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: lightGray_text),
                              ),
                              Text(
                                  widget.data.name,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    height: 1.5,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff28272C)),
                              ),
                              Text(
                                '${widget.data.address}',
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
                                  SvgPicture.asset(
                                      'assets/images/battery_small.svg'),
                                  SizedBox(
                                    width: 7.0,
                                  ),
                                  Text(
                                    '${widget.data.availablePowerbanks}',
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
                                      'assets/images/star_small.svg'),
                                  SizedBox(
                                    width: 7.0,
                                  ),
                                  Text(
                                    '${widget.data.freeSlots}',
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
                                    '${widget.data.distance}',
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
                Padding(
                  padding: EdgeInsets.only(top: 23, left: 14, right: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          onStartNavigationClicked(widget.data);
                        },
                        child: Container(
                          height: 46,
                          width: 137,
                          decoration: BoxDecoration(
                              color: Color(0xffF2F3F7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          alignment: Alignment.center,
                          child: Text(
                            'Navigate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13.0,
                                height: 1.5,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff848490)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                          NearbyLocation data=NearbyLocation(
                            id: widget.data.id,
                            name: widget.data.name,
                            address:  widget.data.address,
                            availablePowerbanks:  widget.data.availablePowerbanks,
                            status:  widget.data.status,
                            description:  widget.data.description,
                            category:  widget.data.category,
                            city:  widget.data.city,
                            country:  widget.data.country,
                            distance:  widget.data.distance,
                            freeSlots:  widget.data.freeSlots,
                            fridayClosed:  widget.data.fridayClosed,
                            fridayHours:  widget.data.fridayHours,
                            houseNumber:  widget.data.houseNumber,
                            imageAvatarPath:  widget.data.imageAvatarPath,
                            imageFullPath:  widget.data.imageFullPath,
                            latitude:  widget.data.latitude,
                            longitude:  widget.data.longitude,
                            mondayClosed:  widget.data.mondayClosed,
                            mondayHours:  widget.data.mondayHours,
                            pincode:  widget.data.pincode,
                            saturdayClosed:  widget.data.saturdayClosed,
                            saturdayHours:  widget.data.saturdayHours,
                            sundayClosed:  widget.data.sundayClosed,
                            sundayHours:  widget.data.sundayHours,
                            thursdayClosed:  widget.data.thursdayClosed,
                            thursdayHours:  widget.data.thursdayHours,
                            tuesdayClosed:  widget.data.tuesdayClosed,
                            tuesdayHours:  widget.data.tuesdayHours,
                            wednesdayClosed:  widget.data.wednesdayClosed,
                            wednesdayHours:  widget.data.wednesdayHours,

                          );
                          Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext
                                  context) =>
                                      MietStationDetailScreen(nearbyLocation: data,)));
                        },
                        child: Container(
                          height: 46,
                          width: 137,
                          decoration: BoxDecoration(
                              color: primaryGreenColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          alignment: Alignment.center,
                          child: Text(
                            'Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13.0,
                                height: 1.5,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
            height: widget.isLongImage?200:120,
            color: Colors.transparent,
            width: widget.isLongImage?50:120,
            padding: EdgeInsets.only(bottom:widget.isLongImage?78:0,),
            child:Image.asset(
              widget.slotTypeFilePath,
              height: widget.isLongImage?200:120,
              width:  widget.isLongImage?50:120,
              fit: BoxFit.fill,

            )),
        Container(
          height: 42.0,
          width: 42.0,
          margin: EdgeInsets.only(top:  widget.isLongImage?75:103,left:  widget.isLongImage?50:97),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryGreenColor.withOpacity(0.5),
          ),
          child: Container(
            height: 42.0,
            width: 42.0,
            margin: EdgeInsets.all(6.0),
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryGreenColor.withOpacity(0.5),
            ),
            child: Center(
              child: Text('${widget.data.availablePowerbanks}',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.5

              ),),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top:  widget.isLongImage?90:60),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 18,
                        top: 10,
                        right: screenPadding,
                        bottom: screenPadding),
                    child: Icon(Icons.close),
                  )
                ],
              ),
              height: 50,
            ),
          ),
        ),
      ],
    );
  }
}
placeHolderImage({String imagePath, double height, double width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(98)),
      child: Image.asset(
        'assets/images/profile.png',
        height: height,
        width: width,
        fit: BoxFit.fill,
      ),
    ),
  );
}
