

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebviewScreen extends StatefulWidget {
  var finalUrl;
  PaymentWebviewScreen({this.finalUrl});
  // final url=MyConstants.TERMS_OF_USE_URL;
  @override
  createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State < PaymentWebviewScreen > {
  // var _url;
  final _key = UniqueKey();
  _PaymentWebviewScreenState();
  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              IndexedStack(
                index: _stackToView,
                children: [
                  Column(
                    children: < Widget > [
                      Expanded(
                          child: WebView(
                            //key: _key,
                            javascriptMode: JavascriptMode.unrestricted,
                            initialUrl: widget.finalUrl,
                            onPageFinished: _handleLoad,
                          )
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),



              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SizedBox.fromSize(
                    child: SvgPicture.asset(
                      'assets/images/close-black.svg',
                    ),
                    // size: Size(300.0, 400.0),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

            ],
          ),
        )
    );
  }
}

