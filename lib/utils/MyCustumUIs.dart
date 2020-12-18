import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';

dropDown() {
  return DropdownButton<String>(
    items: <String>['+91', '+1', '+87', '+76'].map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList(),
    onChanged: (_) {},
  );
}

custumTextview(text, fontsize) {
  return Text(text,
      style: TextStyle(color: Colors.grey, fontSize: fontsize),
      textAlign: TextAlign.center);
}

custumTextviewRegular(text, fontsize) {
  return Text(
    text,
    style: TextStyle(
        color: Colors.black,
        fontSize: fontsize,
        fontFamily: 'Roboto-Regular',
        fontWeight: FontWeight.normal),
    textAlign: TextAlign.center,
  );
}

custumTextviewBold(text, fontsize) {
  return Text(
    text,
    style: TextStyle(
        color: Colors.black,
        fontSize: fontsize,
        fontFamily: 'Roboto-Bold',
        fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
  );
}

Widget custumButtonWithShape(text, color) {
  return Container(
      height: 50,
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: color,
        textColor: Colors.white,
        disabledColor: color,
        disabledTextColor: Colors.white,
        //because without onpressed fat button not show color and text color properly

        child: Text(
          text,
          style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Roboto-Regular',
              fontWeight: FontWeight.bold),
        ),
      ));
}

Widget textFieldBackgroundUI(widget, textField) {
  return Container(
    height: 45,
    decoration: new BoxDecoration(
      color: Colors.white,
      border: new Border.all(color: Colors.grey),
      borderRadius: const BorderRadius.all(
        const Radius.circular(30.0),
      ),
    ),
    child: Row(
      children: <Widget>[
        Container(
            margin:
                const EdgeInsets.only(left: 12, top: 10, right: 10, bottom: 10),
            child: widget),
        Container(
          child: Flexible(
            child: textField,
          ), //flexible
        ), //container
      ], //widget
    ),
  );
}

Widget textFieldBackgroundUI2(text, textField) {
  return Container(
    height: 55,
    margin: const EdgeInsets.only(left: 0, top: 15, right: 0),
    // padding: const EdgeInsets.all(3.0),

    child: Column(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(left: 0, right: 0, bottom: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: text,
            )
            //flexible
            ),
        Container(
          child: Flexible(
            child: textField,
          ), //flexible
        ), //container
      ], //widget
    ),
  );
}

Widget textFieldBackgroundUI1(icon, textField) {
  return Container(
    height: 45,
    margin: const EdgeInsets.only(left: 0, top: 15, right: 0),
    // padding: const EdgeInsets.all(3.0),
    decoration: new BoxDecoration(
      border: new Border.all(color: Colors.pink),
      borderRadius: const BorderRadius.all(
        const Radius.circular(30.0),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin:
                const EdgeInsets.only(left: 12, top: 10, right: 10, bottom: 10),
            child: icon),
        Container(
          child: Flexible(
            child: textField,
          ), //flexible
        ), //container
      ], //widget
    ),
  );
}

Widget toolbarLayoutTransparentBackground(context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.1,
    leading: new IconButton(
      icon: SizedBox.fromSize(
        child: SvgPicture.asset(
          'assets/images/arrow-back-black.svg',
        ),
        // size: Size(300.0, 400.0),
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    // title: Text(name,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
    //centerTitle: true,
  );
}

Widget toolbarLayout(name, context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.9,
    leading: new IconButton(
      icon: SizedBox.fromSize(
        child: SvgPicture.asset(
          'assets/images/arrow-back-black.svg',
        ),
        // size: Size(300.0, 400.0),
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      name,
      style: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
  );
}

Widget toolbarLayoutWithCrossBackButton(name, context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.9,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
    ),
    leading: new IconButton(
      icon: Container(
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
        child: Image.asset(
          'assets/images/back.png',
          height: 24,
          width: 24,
        ),
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      name,
      style: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
  );
}

Widget drawerItem(name) {
  return Container(
    width: 200,
    padding: EdgeInsets.all(5),
    margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
    child: Row(
      children: <Widget>[
        Icon(Icons.home),
        SizedBox(
          width: 20,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}

showProgressDialog(context, progressDialog) {
  progressDialog = new ProgressDialog(context, type: ProgressDialogType.Normal);
  progressDialog.update(
    progress: 50.0,
    message: AllString.please_wait,
    progressWidget: Container(
        padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
    maxProgress: 100.0,
    progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    messageTextStyle: TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
  );

  progressDialog.show();
}

//add colorCode
Color colorCode(var number) {
  String string = "0xFF${number.toString()}";
  return Color(int.parse(string));
}

Widget appBarView(
    {String name,
    VoidCallback callback,
    bool isEnableBack = false,
    BuildContext context}) {
  return Container(
    height: 110,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 8.0)
      ],
    ),
    child: Stack(
      children: <Widget>[
        Positioned(
          left: 12,
          top: 53,
          child: SizedBox(
            height: 50,
            width: 50,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 12, right: 12),
              child: Image.asset(
                'assets/images/back.png',
                height: 15,
                width: 16,
              ),
              onPressed: callback,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width - 125,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                top: 59,
                bottom: 23,
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: appBarTitleStyle,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget crossAppBarView(
    {String name,
    VoidCallback callback,
    bool isEnableBack = false,
    BuildContext context}) {
  return Container(
    height: 110,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 8.0)
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: callback,
          child: Container(
            padding: EdgeInsets.only(
              left: 32.0,
              top: 69,
              bottom: 31,
            ),
            child: Image.asset('assets/images/close_black.png'),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 80,
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              top: 59,
              bottom: 23,
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: appBarTitleStyle,
            ),
          ),
        )
      ],
    ),
  );
}

Widget appBarViewEndBtn(
    {String name,
    VoidCallback callback,
    bool isEnableBack = false,
    BuildContext context}) {
  return Container(
    height: 110,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 8.0)
      ],
    ),
    child: Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          left: 0,
          top: 59,
          bottom: 23,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: appBarTitleStyle,
          ),
        ),
        Positioned(
          right: 8,
          top: 40,
          bottom: 2,
          child: SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                onPressed: callback,
                padding: EdgeInsets.all(12),
                child: Center(
                    child: Image.asset(
                  'assets/images/close_black.png',
                  height: 15,
                  width: 15,
                )),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/*
//appBar
Widget appBar({String name, VoidCallback callback, bool isEnableBack = false}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.9,
    toolbarHeight: 110,
    automaticallyImplyLeading: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
    ),
    leading: new IconButton(
      icon: Container(
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
        child: Image.asset(
          'assets/images/back.png',
          height: 24,
          width: 24,
        ),
      ),
      onPressed: callback,
    ),
    title: Text(
      name,
      style: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
  );
}
*/

//slider button
Widget buttonView({String text = "NEXT", GestureTapCallback callback}) {
  return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(0),
        alignment: Alignment.center,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF54DF6C),
              Color(0xFF54DF83),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        child: Text(
          text.toUpperCase(),
          style: sliderButtonTextStyle,
        ),
        width: double.infinity,
      ),
      onTap: callback);
}

//slider button
Widget buttonBlueView(
    {String text = "NEXT",
    double marginTop = 10,
    GestureTapCallback callback}) {
  return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(0),
        alignment: Alignment.center,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF3497EA),
              Color(0xFF1152A4),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        child: Text(
          text,
          style: sliderButtonTextStyle,
        ),
        width: double.infinity,
      ),
      onTap: callback);
}

//
//slider button
Widget buttonGreyView(
    {String text = "NEXT",
    GestureTapCallback callback,
    double width = 90,
    double height = 36}) {
  return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFF2F3F7),
              Color(0xFFF2F3F7),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        child: Text(
          text,
          style: skipTextStyle,
        ),
      ),
      onTap: callback);
}
