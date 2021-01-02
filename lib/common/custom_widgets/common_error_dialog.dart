import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';

class CommonErrorDialog extends StatelessWidget{

  final String title, descriptions, text;
  final String img;
  final VoidCallback callback;
  final double;
  final isCrossIconShow;


  CommonErrorDialog({this.title, this.descriptions, this.text, this.img,
    this.callback, this.double, this.isCrossIconShow});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: 20, top: (double + 25), right: 20, bottom: 20),
          margin: EdgeInsets.only(top: double,),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 1), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 11,
              ),
              Text(
                descriptions,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 29,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: buttonView(
                      text: text,
                      callback: () {
                        Navigator.of(context).pop();

                      }),
                  margin: EdgeInsets.only(
                      left: 20, right: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: SvgPicture.asset(img),
        ),
      ],
    );
  }

  
}