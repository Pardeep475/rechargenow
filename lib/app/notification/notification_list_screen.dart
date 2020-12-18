import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/notification_list_item.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'notification_item.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationState();
  }
}

class _NotificationState extends State<NotificationScreen> {
  var showEmpty=false;
  SharedPreferences prefs;
  @override
  void initState() {
    loadShredPref();
    showEmpty==false;

    super.initState();
  }
  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    print("prefsuserId ${prefs.get('userId')}");
    await getNotificationApi();



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          appBarView(
              name:   AppLocalizations.of(context).translate('notifications'),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          Expanded(
            child: notifications==null?Center(child: CircularProgressIndicator()):notifications.length==0?
             emptyNotification(context): ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int position) {
                  Notifications item=notifications[position];
                  return InkWell(
                      onTap: (){

                      },
                      child:  NotificationItem(item));
                }),
          )
        ],
      ),
    );
  }
  List<Notifications> notifications;
  getNotificationApi() {
    var apicall=getUserNotificationApi( prefs.get('userId').toString(), prefs.get('accessToken').toString()).then((response) {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        NotificationResponse stationsListPojo =
        NotificationResponse.fromJson(jsonResponse);
        notifications = stationsListPojo.notifications;

        if(notifications.length==0){
          // var json= {
          //   "message": "Erfolgreich",
          //   "notifications": [
          //     {
          //       "readMessage": false,
          //       "createdOnStr": "14.11.2020",
          //       "id": 1,
          //       "title": "Battery Alarm",
          //       "message": "Your battery is in critical condition, look for a rental station nearby",
          //       "createdOn": "2020-11-14T06:45:06",
          //       "userId": 1
          //     },
          //     {
          //       "readMessage": false,
          //       "createdOnStr": "14.11.2020",
          //       "id": 1,
          //       "title": "Battery Alarm",
          //       "message": "Your battery is in critical condition, look for a rental station nearby",
          //       "createdOn": "2020-11-14T06:45:06",
          //       "userId": 1
          //     },
          //   ],
          //   "status": 1
          // };
          // stationsListPojo =
          //     NotificationResponse.fromJson(json);
          // notifications = stationsListPojo.notifications;

        }
        setState(() {});
      } else {
        final jsonResponse = json.decode(response.body);
        MyUtils.showAlertDialog(jsonResponse['message'], context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

}
// }
// emptyNotification(),
