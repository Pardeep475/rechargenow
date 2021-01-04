import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/notification_list_item.dart';
import 'package:recharge_now/utils/color_list.dart';

class NotificationItem extends StatelessWidget {
  Notifications item;

  NotificationItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dateText(),
          title(context),
          SizedBox(
            height: 2,
          ),
          content(context),
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

  content(BuildContext context) {
    return Text(
      _errorMsg(context, item.message),
      style: TextStyle(
          fontSize: 14.0,
          height: 1.5,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          color: lightGray_text),
    );
  }

  title(BuildContext context) {
    return Text(
      _errorTitle(context, item.title),
      style: TextStyle(
          fontSize: 18.0,
          height: 1.7,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: text_black),
    );
  }
}

String _errorTitle(BuildContext context, String msg) {
  String message = "";
  switch (msg) {
    case "POWERBANK_RETURNED":
      {
        message = AppLocalizations.of(context).translate("THANK YOU");
      }
      break;
    case "RENTAL_PERIOD_EXCEEDED":
      {
        message =
            AppLocalizations.of(context).translate("RENTAL PERIOD EXCEEDED");
      }
      break;
    case "Battery_Alarm":
      {
        message = AppLocalizations.of(context).translate("Battery_Alarm");
      }
      break;
    case "FRIEND_INVITE":
      {
        message = AppLocalizations.of(context).translate("FRIEND_INVITE");
      }
      break;
    case "USER_VIP":
      {
        message = AppLocalizations.of(context).translate("USER_VIP");
      }
      break;
    default:
      {
        message = AppLocalizations.of(context).translate("Battery_Alarm");
      }
  }
  return message;
}

// POWERBANK_RETURNED
// POWERBANK_RETURNED_MSG
String _errorMsg(BuildContext context, String msg) {
  String message = "";
  switch (msg) {
    case "POWERBANK_RETURNED_MSG":
      {
        message = AppLocalizations.of(context)
            .translate("You have successfully brought back the Powerbank");
      }
      break;
    case "POWERBANK_SOLD_MSG":
      {
        message = AppLocalizations.of(context)
            .translate("RENTAL PERIOD EXCEEDED DES");
      }
      break;
    case "Battery_Alarm_MSG":
      {
        message = AppLocalizations.of(context).translate("Battery_Alarm_MSG");
      }
      break;
    case "FRIEND_INVITE_MSG":
      {
        message = AppLocalizations.of(context).translate("FRIEND_INVITE_MSG");
      }
      break;
    case "USER_VIP_MSG":
      {
        message = AppLocalizations.of(context).translate("USER_VIP_MSG");
      }
      break;
    default:
      {
        message = AppLocalizations.of(context).translate("Battery_Alarm_MSG");
      }
  }
  return message;
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
