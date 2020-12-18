
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/notification_list_item.dart';
import 'package:recharge_now/utils/color_list.dart';

class NotificationItem extends StatelessWidget {

  Notifications item;
  NotificationItem(this. item);

  @override
  Widget build(BuildContext context) {
    return
        Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                dateText(),
                title(),
                SizedBox(
                  height: 2,
                ),
                content(),
                SizedBox(
                  height: 18,
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffEBEBEB),
                )
              ],
            ),
          );
  }

  dateText() {
    return Text(
      item.createdOnStr,
      style: TextStyle(
          fontSize: 11.0,
          height: 1.5,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: lightGray_text),
    );
  }

  content() {
    return Text(
      item.message,
      style: TextStyle(
          fontSize: 14.0,
          height: 1.5,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          color: lightGray_text),
    );
  }

  title() {
    return Text(
      item.title,
      style: TextStyle(
          fontSize: 18.0,
          height: 1.7,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: text_black),
    );
  }
}

emptyNotification(BuildContext context) {
  return Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset('assets/images/emptyNotification.svg'),
        SizedBox(
          height: 57,
        ),
        emptyNotificationText(context)
      ],
    ),
  );
}

emptyNotificationText(BuildContext context) {
  return Text(
    AppLocalizations.of(context).translate('Nonotificationsyet'),
    textAlign: TextAlign.center,
    style: TextStyle(
        fontSize: 20.0,
        height: 1.7,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        color: text_black),
  );
}
