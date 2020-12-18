  import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/station_list_model.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:platform/platform.dart';

class StationDetailsMarkerClickScreen extends StatefulWidget {
     //map location and nearbylocation both pojo are same
  MapLocation nearbyLocation;

  StationDetailsMarkerClickScreen({this.nearbyLocation});

  @override
  _StationDetailsMarkerClickScreenState createState() => _StationDetailsMarkerClickScreenState();
}

class _StationDetailsMarkerClickScreenState extends State<StationDetailsMarkerClickScreen> {

  var today_Day="";
  DateTime date;
  var daysHours=List<String>();

  /*  var daysArray = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];*/

  /*"Monday": "Montag",
  "Tuesday": "Dienstag",
  "Wednesday": "Mittwoch",
  "Thursday": "Donnerstag",
  "Friday": "Freitag",
  "Saturday": "Samstag",
  "Sunday": "Sonntag",*/

  //during multiple language i have to write days array based on laguages
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: toolbarLayoutTransparentBackground(context),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: color_white,
          child: SingleChildScrollView(child: buildBodyUI())),
    );
  }

  buildBodyUI(){
    return Container(
      margin: EdgeInsets.only(top: 33),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Container(
            width: double.infinity,
            child: Stack(fit: StackFit.passthrough,
              children: <Widget>[
                /*SizedBox(
                    height:250,
                    child: Image.network(IMAGE_BASE_URL+widget.nearbyLocation.imageFullPath.toString(),fit: BoxFit.fill,)),
*/
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SizedBox.fromSize(
                    child:  SvgPicture.asset(
                      'assets/images/arrow-back-black.svg',
                    ),
                    // size: Size(300.0, 400.0),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

                stationLogoUI()

            ],),
          ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.nearbyLocation.name.toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
                        
                        SizedBox(height: 5,),

                        Text(widget.nearbyLocation.category.toString(), style: TextStyle(fontSize: 12,color: primaryGreenColor,fontWeight: FontWeight.bold)),

                      ],),

                    Column(children: <Widget>[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          'assets/images/placeholder-small.svg',
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(widget.nearbyLocation.distance.toString(),
                          style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold))
                    ],)

                  ],


                ),

                SizedBox(height: 10,),

                Row(
                  children: <Widget>[
                  availableButtonUi(),
                  SizedBox(width: 10,),
                  freeButtonUi()
                ],),


                SizedBox(height: 15,),

                Divider(height: 1,
                thickness: 1,),

                SizedBox(height: 15,),

                Text(AppLocalizations.of(context).translate("Information"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),


                Text(widget.nearbyLocation.description.toString(), style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.normal)),
            SizedBox(height: 15,),

            Divider(height: 1,
              thickness: 1,),

                SizedBox(height: 15,),

                Text(AppLocalizations.of(context).translate("Location"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                    //    mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            'assets/images/placeholder.svg',
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: Text(widget.nearbyLocation.address.toString(),textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.normal)),
                        )
                      ],),
                    ),

                    buttonNavigationUI()



                ],),


                SizedBox(height: 15,),

                Divider(height: 1,
                  thickness: 1,),





                SizedBox(height: 15,),

                Text(AppLocalizations.of(context).translate("Opening hours"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),

                Stack(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0,5,0,0),

                    child: SvgPicture.asset(
                      'assets/images/time.svg',
                    ),
                  ),

                //  SizedBox(height: 10,),

                 DaysUI_listView()
                ],)


              ],
            ),
          ),



        ],
      ),
    );
  }

  availableButtonUi(){
    return Expanded(
      child: Container(
        //margin: new EdgeInsets.fromLTRB(0,0,0,10),
        decoration: new BoxDecoration(
          color: color_light_grey,
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          SvgPicture.asset(
            'assets/images/battery-powerbank.svg',
          ),

          SizedBox(width: 10,),

          Text(widget.nearbyLocation.availablePowerbanks.toString()+" "+AppLocalizations.of(context).translate("Available"),
              style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold))
        ],),


      ),
    );
  }


  freeButtonUi(){
    return Expanded(
      child: Container(
        //margin: new EdgeInsets.fromLTRB(0,0,0,10),
        decoration: new BoxDecoration(
          color: color_light_grey,
         /* border: new Border.all(
            *//*width: .5,
              color: Colors.grey*//*),*/
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/Star.svg',
            ),

            SizedBox(width: 10,),

            Text(widget.nearbyLocation.freeSlots.toString()+" "+AppLocalizations.of(context).translate("Free"),
                style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold))
          ],),


      ),
    );
  }

  buttonNavigationUI(){
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
         // side: BorderSide(width: 1, color: Colors.grey)
      ),
      child: Container(
        //margin: EdgeInsets.fromLTRB(20,0,0,0),
        width: 60.0,
        height: 60.0,
        // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
        decoration: new BoxDecoration(
          shape: BoxShape.circle,// You can use like this way or like the below line
          color: Colors.white,


        ),

      child: IconButton(
          icon:  SvgPicture.asset(
            'assets/images/navigation.svg',
          ),
          // size: Size(300.0, 400.0),
          onPressed: () {
            onStartNavigationClicked();
          },
        ),// You can add a Icon instead of text also, like below.
        //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
      ),
    );
  }


  stationLogoUI(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            // side: BorderSide(width: 1, color: Colors.grey)
          ),
          child: Container(
            //margin: EdgeInsets.fromLTRB(20,0,0,0),
            width: 100.0,
            height: 100.0,
            // padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height

            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(widget.nearbyLocation.imageFullPath.toString())))
            /*child: IconButton(
              icon:  Image.network(
                IMAGE_BASE_URL+widget.nearbyLocation.imageAvatarPath.toString(),
              ),
              // size: Size(300.0, 400.0),
              onPressed: () {

              },
            )*/,// You can add a Icon instead of text also, like below.
            //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
          ),
        ),
      ),
    );
  }



  Widget DaysUI_listView() {
    return /*eventList == null
        ? Center(
      child: CircularProgressIndicator(),
    )
        :*/ ListView.builder(

        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: daysArray.length,
        itemBuilder: (context, index) {
          //Datum datum = eventList.data[index];
          return list_row_ui(index);
        });
  }


  list_row_ui(index){
    return InkWell(
      onTap:(){

      },
      child: Container(
          margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
          padding: EdgeInsets.all(0),
          child: Container(
            color: index%2!=0?color_light_grey:color_white,
            padding: EdgeInsets.all(8),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(today_Day==daysArray[index]?AppLocalizations.of(context).translate("Today")+"!":daysArray[index],
                    style: TextStyle(fontSize: 14,
                        color: today_Day==daysArray[index]?primaryGreenColor:Colors.grey,fontWeight: FontWeight.bold)),

                /*SizedBox(
                  width: 50,
                ),*/

                Text(daysHours[index].toString(),textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14,
                        color: today_Day==daysArray[index]?primaryGreenColor:Colors.grey, fontWeight: FontWeight.bold)),


              ],
            ),
          )
      ),
    );
  }


  onStartNavigationClicked() async {
    String origin=""+MyConstants.currentLat.toString()+","+MyConstants.currentLong.toString();  // lat,long like 123.34,68.56

    print(origin);
    String destination=widget.nearbyLocation.latitude+","+widget.nearbyLocation.longitude;
    if ( LocalPlatform().isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                 /* origin +*/ "&destination=" + destination + "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    }
    else {
      String url = "https://www.google.com/maps/dir/?api=1&origin=" /*+ origin */+ "&destination=" + destination + "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

}
