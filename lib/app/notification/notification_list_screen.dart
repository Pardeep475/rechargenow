import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/common/custom_widgets/common_error_dialog.dart';
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
  var showEmpty = false;
  SharedPreferences prefs;

  @override
  void initState() {
    loadShredPref();
    showEmpty == false;

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
              name: AppLocalizations.of(context).translate('notifications'),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          Expanded(
            child: notifications == null
                ? Center(child: CircularProgressIndicator())
                : notifications.length == 0
                    ? emptyNotification(context)
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int position) {
                          Notifications item = notifications[position];
                          return InkWell(
                              onTap: () {}, child: NotificationItem(item));
                        }),
          )
        ],
      ),
    );
  }

  List<Notifications> notifications;

  getNotificationApi() async {
    await getUserNotificationApi(
            prefs.get('userId').toString(), prefs.get('accessToken').toString())
        .then((response) {
          debugPrint("notification_response --->  ${response.body}");
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        NotificationResponse stationsListPojo =
            NotificationResponse.fromJson(jsonResponse);
        notifications = stationsListPojo.notifications;
        if (notifications.length == 0) {}
        setState(() {});

        _showErrorDialog(AppLocalizations.of(context).translate("INVALID_INPUT"),
            AppLocalizations.of(context).translate("INVALID_INPUT_MSG"));

      } else {
        _showErrorDialog(AppLocalizations.of(context).translate("ERROR OCCURRED"),
            AppLocalizations.of(context).translate("something_went_wrong"));
      }
    }).catchError((error) {
      _showErrorDialog(AppLocalizations.of(context).translate("ERROR OCCURRED"),
          AppLocalizations.of(context).translate("something_went_wrong"));
    });
  }

  // AppLocalizations.of(context).translate("ERROR OCCURRED")
  // AppLocalizations.of(context)
  //                   .translate("something_went_wrong")
  _showErrorDialog(String title, String message) {
    openDialogWithSlideInAnimation(
      context: context,
      itemWidget: CommonErrorDialog(
        title: title,
        descriptions: message,
        text: AppLocalizations.of(context).translate("Ok"),
        img: "assets/images/something_went_wrong.svg",
        double: 37.0,
        isCrossIconShow: true,
        callback: () {},
      ),
    );
  }
}
// }
// emptyNotification(),
