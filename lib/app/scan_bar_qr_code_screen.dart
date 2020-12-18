import 'package:flashlight/flashlight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  padding: EdgeInsets.all(12),
                  child: Center(
                      child: Image.asset(
                    'assets/images/close_black.png',
                    color: Colors.white,
                    height: 15,
                    width: 15,
                  )),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Scan the QR-Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.4,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamily,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Scan the QR Code at the station to release a Powerban',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.4,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Image.asset('assets/images/slot8station.png'),
          SizedBox(
            height: 35,
          ),
          Container(
              decoration: BoxDecoration(
                  color: Color(0xff666666),
                  image: DecorationImage(
                      image: AssetImage('assets/images/Subtract.png'))),
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 290,
                height: 290,
                child: Container(
                  height: 290,
                  width: 290,
                  child: QRBarScannerCamera(
                    onError: (context, error) => Text(
                      error.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                    qrCodeCallback: (code) async {
                      await _qrCallback(code);
                    },
                  ),
                ),
              )),
          SizedBox(
            height: 23,
          ),
          InkWell(
            onTap: () {
              if(isturnon){
                //if light is on, then turn off
                Flashlight.lightOff();
                setState(() {
                  isturnon = false;
                  //flashicon = Icons.flash_off;
                  //flashbtncolor = Colors.deepOrangeAccent;
                });
              }else{
                //if light is off, then turn on.
                Flashlight.lightOn();
                setState(() {
                  isturnon = true;
                //  flashicon = Icons.flash_on;
                  //flashbtncolor = Colors.greenAccent;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.all(13),
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

  _qrCallback(String code) {
    Navigator.pop(context, code);
  }
}
