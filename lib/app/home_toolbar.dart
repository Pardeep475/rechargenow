import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenToolbar extends StatelessWidget {
  Function(int) callBack;

  HomeScreenToolbar({this.callBack});

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.only(top: 47.0, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            humbBar(),
            Expanded(
              child: logo(),
            ),
            notification(),

          ],
        ),
      ),
    );
  }

  humbBar() {
    return SizedBox(
      height: 52,
      width: 52,
      child: FlatButton(
          child: SvgPicture.asset('assets/images/humbar.svg'),
          padding: EdgeInsets.all(16),
          onPressed: () {
            callBack(1);
          }),
    );
  }

  notification() {
    return SizedBox(
      height: 52,
      width: 60,
      child: FlatButton(
          child: SvgPicture.asset('assets/images/notification.svg'),
          padding: EdgeInsets.all(12),
          onPressed: () {
            callBack(2);
          }),
    );
  }

  logo() {
    return Center(
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        height: 41,
        width: 164,
      ),
    );
  }
}
