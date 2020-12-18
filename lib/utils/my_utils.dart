import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:url_launcher/url_launcher.dart';


class MyUtils {
  static showtoast(value) {
    Fluttertoast.showToast(
        msg: value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,

        backgroundColor: color_blackChat,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showLoaderDialog(BuildContext context) {
    Dialog alert = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: new Container(
        width: 300.0,
        height: 150.0,
        alignment: AlignmentDirectional.center,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: new SizedBox(
                height: 50.0,
                width: 50.0,
                child: new CircularProgressIndicator(
                  value: null,
                  strokeWidth: 7.0,
                ),
              ),
            ),
            /*new Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: new Center(
                child: new Text(
                  "loading.. wait...",
                  style: new TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Decoration showRoundCornerDecoration() {
    return new BoxDecoration(
      color: Colors.white,
      border: new Border.all(color: Colors.grey, width: .5),
      borderRadius: const BorderRadius.all(
        const Radius.circular(5.0),
      ),
    );
  }

  static LinearGradient gradientColor(Color c1, Color c2) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        c1,
        c2
      ],



    );
  }

  /* Created By Jawed aKHTAR 25 april 2020
  @showAlertDialog this method is used for show dialog something went wrong
  * */
  static showAlertDialog(message, context) {
    Dialog myDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 300.0,
        // width: 600.0,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 80.0,
                width: 80.0,
                child: Image.asset(
                  'assets/images/failure_occured.png',
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              AppLocalizations.of(context).translate("Error"),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                // margin: new EdgeInsets.fromLTRB(0,0,0,0),
                height: 45,
                width: 250,
                child: new Center(
                  child: new Text( AppLocalizations.of(context).translate("Ok"),
                      style: new TextStyle(
                          color: Colors.white,
                          //fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold)),
                ),

                decoration: new BoxDecoration(
                  color: primaryGreenColor,
                  /* border: new Border.all(
              width: .5,
              color:Colors.grey),*/
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => myDialog);
  }

  /* Created By Jawed aKHTAR 25 april 2020
  @showRentalRefusedDialog this method is used for show dialog when user already taken powerbank
  * */
  static showRentalRefusedDialog(message, context) {
    Dialog myDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 300.0,
        // width: 600.0,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 100.0,
                //width: 80.0,
                child: Image.asset(
                  'assets/images/rental_refused.png',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context).translate("Rental refused"),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                // margin: new EdgeInsets.fromLTRB(0,0,0,0),
                height: 45,
                width: 250,
                child: new Center(
                  child: new Text( AppLocalizations.of(context).translate("Ok"),
                      style: new TextStyle(
                          color: Colors.white,
                          //fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold)),
                ),

                decoration: new BoxDecoration(
                  color: primaryGreenColor,
                  /* border: new Border.all(
              width: .5,
              color:Colors.grey),*/
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => myDialog);
  }

  /* Created By Jawed aKHTAR 25 april 2020
  @launchURL this method is used for open url in browser
  * */
  static launchURL(finalUrl) async {
    var url = finalUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
