import 'dart:io';

import 'package:flashlight/flashlight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/Dimens.dart';
import 'package:recharge_now/utils/MyConstants.dart';

class ScanQrBarCodeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScanQrBarState();
  }
}

class _ScanQrBarState extends State<ScanQrBarCodeScreen> {
  var _qrInfo = "";
  var _hasFlashlight = false;
  var isturnon = false;
  String _qrCode = "";

  @override
  initState() {
    super.initState();
    initFlashlight();
  }

  @override
  Widget build(BuildContext context) {
//scanQr.svg
    return Scaffold(
      backgroundColor: Color(0xff666666),
      body: Column(
        children: [
          SizedBox(
            height: Dimens.twentyFive,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: Dimens.fiftyFive,
              width: Dimens.fiftyFive,
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.fiftyFive))),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  padding: EdgeInsets.all(Dimens.fifteen),
                  child: Center(
                      child: Image.asset(
                    'assets/images/close_black.png',
                    color: Colors.white,
                    height: Dimens.eighteen,
                    width: Dimens.eighteen,
                  )),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimens.ten),
            child: Text(
              AppLocalizations.of(context).translate('Scan the QR-Code'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.4,
                  fontSize: Dimens.twentyThree,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamily,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimens.eighteen),
            child: Text(
              AppLocalizations.of(context)
                  .translate('scan code to activate location'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.4,
                  fontSize: Dimens.sixteen,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: Dimens.six,
          ),
          Image.asset('assets/images/slot8station.png'),
          SizedBox(
            height: Dimens.forty,
          ),
          Container(
              decoration: BoxDecoration(
                  color: Color(0xff666666),
                  image: DecorationImage(
                      image: AssetImage('assets/images/Subtract.png'))),
              padding: EdgeInsets.all(Dimens.thrteen),
              child: Builder(
                builder: (context) {
                  return Container(
                    width: Dimens.twoEighty,
                    height: Dimens.twoEighty,
                    child: QRBarScannerCamera(
                      fit: Platform.isIOS ? BoxFit.fill : BoxFit.cover,
                      onError: (context, error) => Text(
                        error.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                      qrCodeCallback: (code) async {
                        await _qrCallback(context, code);
                      },
                    ),
                  );
                },
              )),
          SizedBox(
            height: Dimens.twentyThree,
          ),
          GestureDetector(
            onTap: () {
              if (isturnon) {
                debugPrint("debugPrint      IsturnOn");
                //if light is on, then turn off
                Flashlight.lightOff();
                setState(() {
                  isturnon = false;
                  //flashicon = Icons.flash_off;
                  //flashbtncolor = Colors.deepOrangeAccent;
                });
              } else {
                //if light is off, then turn on.
                debugPrint("debugPrint      IsturnOff");
                Flashlight.lightOn();
                setState(() {
                  isturnon = true;
                  //  flashicon = Icons.flash_on;
                  //flashbtncolor = Colors.greenAccent;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.all(Dimens.fifteen),
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: SvgPicture.asset('assets/images/Frame.svg'),
            ),
          )
        ],
      ),
    );
  }

  initFlashlight() async {
    bool hasFlash = await Flashlight.hasFlashlight;
    print("Device has flash ? $hasFlash");
    setState(() {
      _hasFlashlight = hasFlash;
    });
  }

  _qrCallback(BuildContext context, String code) {
    if (_qrCode.isEmpty) {
      _qrCode = code;
      debugPrint("barcode_is_scanner   $code");
      Navigator.pop(context, code);
    }
  }
}
