import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:recharge_now/common/custom_widgets/common_error_dialog.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyConstants.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';

class ScanQrBarCodeScreenTwo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScanQrBarStateTwo();
  }
}

class _ScanQrBarStateTwo extends State<ScanQrBarCodeScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//
//   // Barcode result;
//   // QRViewController controller;
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     // if (Platform.isAndroid) {
//     //   controller.pauseCamera();
//     // } else if (Platform.isIOS) {
//     //   controller.resumeCamera();
//     // }
//   }
//
//   // void _onQRViewCreated(QRViewController controller) {
//   //   this.controller = controller;
//   //   controller.scannedDataStream.listen((scanData) {
//   //     debugPrint("qr_code_stream:-       $scanData");
//   //     _qrCallback(context, scanData.code);
//   //     // setState(() {
//   //     //   result = scanData;
//   //     // });
//   //   });
//   // }
//   bool camState = false;
//
//   @override
//   void dispose() {
//     // controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         camState = true;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
// //scanQr.svg
//     return Scaffold(
//       backgroundColor: Color(0xff666666),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: SizedBox(
//               height: 50,
//               width: 50,
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: FlatButton(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(50))),
//                   onPressed: () {
//                     Navigator.pop(context, null);
//                   },
//                   padding: EdgeInsets.all(12),
//                   child: Center(
//                       child: Image.asset(
//                     'assets/images/close_black.png',
//                     color: Colors.white,
//                     height: 15,
//                     width: 15,
//                   )),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               AppLocalizations.of(context).translate('Scan the QR-Code'),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   height: 1.4,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: fontFamily,
//                   color: Colors.white),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Text(
//               AppLocalizations.of(context)
//                   .translate('scan code to activate location'),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   height: 1.4,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: fontFamily,
//                   color: Colors.white),
//             ),
//           ),
//           SizedBox(
//             height: 4,
//           ),
//           Image.asset('assets/images/slot8station.png'),
//           SizedBox(
//             height: 35,
//           ),
//           Container(
//             decoration: BoxDecoration(
//                 color: Color(0xff666666),
//                 image: DecorationImage(
//                     image: AssetImage('assets/images/Subtract.png'))),
//             padding: const EdgeInsets.all(10.0),
//             child: Container(
//               width: 290,
//               height: 290,
//               child: Container(
//                 height: 290,
//                 width: 290,
//                 child: camState
//                     ? QrCamera(
//                         fit: BoxFit.cover,
//                         onError: (context, error) {
//                           return openDialogWithSlideInAnimation(
//                             context: context,
//                             itemWidget: CommonErrorDialog(
//                               title: AppLocalizations.of(context)
//                                   .translate("ERROR OCCURRED"),
//                               descriptions: error.toString(),
//                               text:
//                                   AppLocalizations.of(context).translate("Ok"),
//                               img: "assets/images/something_went_wrong.svg",
//                               double: 37.0,
//                               isCrossIconShow: true,
//                               callback: () {},
//                             ),
//                           );
//                         },
//                         qrCodeCallback: (code) {
//                           debugPrint("barcode_scan_is_running    $code");
//                           // return openDialogWithSlideInAnimation(
//                           //   context: context,
//                           //   itemWidget: CommonErrorDialog(
//                           //     title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
//                           //     descriptions: code.toString(),
//                           //     text: AppLocalizations.of(context).translate("Ok"),
//                           //     img: "assets/images/something_went_wrong.svg",
//                           //     double: 37.0,
//                           //     isCrossIconShow: true,
//                           //     callback: () {},
//                           //   ),
//                           // );
//                           _qrCallback(context, code);
//                         },
//                         // child: new Container(
//                         //   decoration: new BoxDecoration(
//                         //     color: Colors.transparent,
//                         //     border: Border.all(color: Colors.orange, width: 10.0, style: BorderStyle.solid),
//                         //   ),
//                         // ),
//                       )
//                     : SizedBox(),
//
//                 // child: QRBarScannerCamera(
//                 //   onError: (context, error) => Text(
//                 //     error.toString(),
//                 //     style: TextStyle(color: Colors.red),
//                 //   ),
//                 //   qrCodeCallback: (code) async {
//                 //     await _qrCallback(context, code);
//                 //   },
//                 // ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 23,
//           ),
//           InkWell(
//             onTap: () {
//               // try {
//               //   debugPrint("status_of_flash_light   ---   ");
//               //   controller.getFlashStatus().then((value) {
//               //     debugPrint("status_of_flash_light   ---   $value");
//               //     // if(value){
//               //       controller.toggleFlash();
//               //     // }
//               //   });
//               // } catch (e) {
//               //   debugPrint("Invalid Type");
//               // }
//             },
//             child: Container(
//               padding: EdgeInsets.all(13),
//               decoration:
//                   BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//               child: SvgPicture.asset('assets/images/Frame.svg'),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   _qrCallback(BuildContext context, String code) {
//     debugPrint("barcode_is_scanner   $code");
//     if (code.isNotEmpty) {
//       debugPrint("barcode_is_scanner   $code");
//       Navigator.pop(context, code);
//     }
//   }
}
