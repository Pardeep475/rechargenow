import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTimerBottomSheeet extends StatefulWidget {
  String rentalTime;
  String walletAmount;
  String rentalPrice;
  HomeTimerBottomSheeet({this.rentalPrice,this.rentalTime,this.walletAmount});

  @override
  State<StatefulWidget> createState() {

    return _HomeTimerState();

  }

}

class _HomeTimerState extends State<HomeTimerBottomSheeet> with SingleTickerProviderStateMixin {
  int hours=0;
  int minutes=0;
  int days=0;
  AnimationController _controller;

  var arr=[];
  @override
  void initState() {
    arr= widget.rentalTime.split(':');
    if(arr.length==2) {
      hours = int.parse(arr[0]);
      minutes = int.parse(arr[1]);
      hours = hours * 60;
      minutes = minutes + hours;
      _controller =
          AnimationController(vsync: this, duration: Duration(minutes: minutes));
      _controller.forward();
    }else{
      days = int.parse(arr[0]);
      hours = int.parse(arr[1]);
      minutes = int.parse(arr[2]);
      days=days*24*60;
      hours = hours * 60;
      minutes = minutes + hours+days;
      _controller =
          AnimationController(vsync: this, duration: Duration(minutes: minutes));
      _controller.forward();
    }
    setState(() {

    });



    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      height: 265,
      margin: EdgeInsets.only(
        left: 18,
        right: 18,

      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Center(
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 18, left: 12, right: 12, bottom: 2),
              child: Center(
                child: Text(
                  'Current Rental Time',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      height: 1.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Color(0xff2F2F2F)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1, left: 12, right: 12, bottom: 2),
              child: Center(
                child: Countdown(
                  arr: arr,
                  animation: StepTween(
                    begin:   minutes* 60,
                    end: 0,
                  ).animate(_controller),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                arr.length==2?Container(): Padding(
                  padding: EdgeInsets.only(
                    top: 2,
                    right: 32,
                  ),
                  child: Center(
                    child: Text(
                      'Days',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11.0,
                          height: 1.4,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Color(0xff686868)),
                    ),
                  ),
                ), Padding(
                  padding: EdgeInsets.only(
                    top: 2,
                    right: 7,
                  ),
                  child: Center(
                    child: Text(
                      'Hours',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11.0,
                          height: 1.4,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Color(0xff686868)),
                    ),

                  ),

                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 1,
                    left: 25,
                  ),
                  child: Center(
                    child: Text(
                      'Minutes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11.0,
                          height: 1.4,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Color(0xff686868)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: 40,
                  left: 40,
                  top: 12,
                  bottom: 12
              ),
              child: Divider(
                color: Color(0xffEBEBEB),
                height: 1,
                thickness: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(

                    right: 34,
                  ),
                  child: Center(
                    child: Text(
                      'Rental Price',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1.4,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Color(0xff828282)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left:34,
                  ),
                  child: Center(
                    child: Text(
                      widget.rentalPrice,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1.4,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Color(0xff2F2F2F)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: 40,
                  left: 40,
                  top: 12,
                  bottom: 12
              ),
              child: Divider(
                color: Color(0xffEBEBEB),
                height: 1,
                thickness: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(

                    right: 34,
                  ),
                  child: Center(
                    child: Text(
                      'Wallet Credit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1.4,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Color(0xff828282)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left:34,
                  ),
                  child: Center(
                    child: Text(
                      widget.walletAmount,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1.4,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Color(0xff2F2F2F)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation,this.arr}) : super(key: key, listenable: animation);
  Animation<int> animation;
var arr;
  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    String timerText="";
    if(arr.length==2) {
       timerText =
          '${clockTimer.inHours.remainder(60).toString().padLeft(
          2, '0')} : ${(clockTimer.inMinutes.remainder(60) % 60)
          .toString()
          .padLeft(2, '0')}';
    }else{
      timerText =
      '${clockTimer.inDays.remainder(24).toString().padLeft(
          2, '0')} : ${clockTimer.inHours.remainder(60).toString().padLeft(
          2, '0')} : ${(clockTimer.inMinutes.remainder(60) % 60)
          .toString()
          .padLeft(2, '0')}';
    }
    return Text(
      "$timerText",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 42.0,
          height: 1.2,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w800,
          color: Color(0xff2F2F2F)),
    );
  }
}
