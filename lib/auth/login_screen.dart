import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/auth/code_verification_screen.dart';
import 'package:recharge_now/common/custom_dialog_box_error.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/my_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class Item {
  const Item(this.name, this.icon);

  final String name;
  final Icon icon;
}

class _LoginState extends State<LoginScreen> {
  SharedPreferences prefs;
  Item selectedUser;
  var countryName = "Code";
  var mobileNumberWithCountryCode;
  var fcmtoken = "";
  bool _saving = false;
  String mobileNumber = "", countryCode = "+49";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _setUpFirebase() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      debugPrint("firebase_token    $token");
      prefs.setString('fcmtoken', token);
    });
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
      debugPrint("firebase_token    ${settings.alert}");
      // if (settings.alert) {
      _firebaseMessaging.getToken().then((token) {
        debugPrint("firebase_token    $token");
        prefs.setString('fcmtoken', token);
      });
      // }
    });
  }

  List<Item> users = <Item>[
    const Item(
        'Android',
        Icon(
          Icons.android,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'Flutter',
        Icon(
          Icons.flag,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'Dart',
        Icon(
          Icons.format_indent_decrease,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'iOS',
        Icon(
          Icons.mobile_screen_share,
          color: const Color(0xFF167F67),
        )),
  ];

  bool _serviceEnabled = false;
  var location = new Location();

  @override
  void initState() {
    initPrefs();
    super.initState();
    Future.delayed(Duration(milliseconds: 400),(){
      checkLocationServiceEnableOrDisable();
      _setUpFirebase();
    });
  }

  checkLocationServiceEnableOrDisable() async {
    _serviceEnabled = await location.serviceEnabled();
    print("serviceEnabled" + _serviceEnabled.toString());
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    } else if (_serviceEnabled) {
      print("_serviceEnabled.toString()--- " + _serviceEnabled.toString());
    }
    print("_serviceEnabled.toString()--- " + _serviceEnabled.toString());
  }

  void convertSectoDay(int n) {
    var day = n / (24 * 3600);
    var arr = "10.296527777777778".split('.');
    String hours = "0" + int.parse(arr[1]).toString();
    int hours2 = int.parse(hours);
    debugPrint("hours1    $hours2");
    int min = hours2 * 60;
    debugPrint("hours    $min");

    n = n % (24 * 3600);
    var hour = n / 3600;

    n %= 3600;
    var minutes = n / 60;

    n %= 60;
    var seconds = n;

    debugPrint("day  $day hour $hour minutes $minutes  second $seconds");

    // final d4 = Duration(days:day,seconds: seconds);
    // print(d4);
    // print(format(d4));
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color_white,
        body: Container(
            height: double.infinity,
            child: ModalProgressHUD(
              child: SingleChildScrollView(child: _buildUIComposer()),
              inAsyncCall: _saving,
            )));
  }

  codes_mobileNumberEditFieldUI() {
    return Container(
      height: 45,
      decoration: MyUtils.showRoundCornerDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              // onCountryCodeButtonClick();
              /* Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => SelectCountryScreen()));
*/
            },
            child: CountryCodePicker(
              onChanged: (country_Code) {
                print(countryCode.toString());
                countryCode = country_Code.toString();
              },
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: 'DE',
              favorite: ['+49', 'FR'],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
          ),

          Container(
            color: Colors.grey,
            width: .5,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          ),

          Expanded(
            child: TextField(
              style: editTextStyle,
              onChanged: (text) {
                mobileNumber = text;
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: AppLocalizations.of(context)
                    .translate('Enter phone number'),
                hintStyle: hintTextStyle,
              ),
            ),
          ), //container
        ], //widget
      ),
    );
  }

  Widget _buildUIComposer() {
    return SafeArea(
      child: Container(
        margin:
            EdgeInsets.only(left: screenPadding, top: 0, right: screenPadding),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 5),
              height: MediaQuery.of(context).size.height * .15,
              child: SvgPicture.asset(
                'assets/images/app_logo.svg',
                allowDrawingOutsideViewBox: true,
                //height: 80,
                // width: double.infinity,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.width * .60,
              width: MediaQuery.of(context).size.width * .60,
              child: Image.asset(
                'assets/images/loginimage.png',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin:
                  EdgeInsets.only(left: screenPadding, right: screenPadding),
              child: Text(
                AppLocalizations.of(context).translate('Verify Your Number'),
                textAlign: TextAlign.center,
                style: sliderTitleTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 13, left: screenPadding, right: screenPadding),
              child: Text(
                AppLocalizations.of(context)
                    .translate('Please enter your Country your Phone Number'),
                textAlign: TextAlign.center,
                style: locationTitleStyle,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            codes_mobileNumberEditFieldUI(),
            SizedBox(
              height: 25,
            ),
            new InkWell(
                onTap: () {
                  LoginWithMobileNumberButtonClick();
                },
                child: buttonView(
                  text: AppLocalizations.of(context)
                      .translate('LOGIN')
                      .toUpperCase(),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: 13, left: screenPadding, right: screenPadding),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '',
                  style: termsBoldText,
                  children: <TextSpan>[
                    TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('By clicking LOGIN you agree our'),
                        style: termsText),
                    TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('Terms of Use'),
                        style: termsBoldText),
                    TextSpan(
                        text: AppLocalizations.of(context).translate('and'),
                        style: termsText),
                    TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('Privacy policy'),
                        style: termsBoldText),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void LoginWithMobileNumberButtonClick() async {
    if (mobileNumber.trim().length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBoxError(
              title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions: "Please enter a valid mobile number",
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            );
          });
    } else if (mobileNumber.trim().length < 10) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBoxError(
              title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions: "Please enter a valid mobile number",
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            );
          });
    } else {
      await FirebaseAuth.instance.signOut();
      verfiyPhone();
      // callLoginAPI();
    }
  }

  String verificationId;

  Future<void> verfiyPhone() async {
    _saving = true;
    setState(() {});
    mobileNumberWithCountryCode = countryCode + mobileNumber;
    print("phoneNo$mobileNumberWithCountryCode");
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      this.verificationId = verId;
      print("verificationId$verificationId");
      dismissProgressDialog();
      /*Utils.nextScreen(
          OtpScreen(
            verificationId: this.verificationId,
            phoneNumber: mobileNumberWithCountryCode,
          ),
          context);*/
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => CodeVerificationScreen(
              authyId: this.verificationId,
              mobileNumber: mobileNumber,
              countryCode: countryCode,
              fcmtoken: fcmtoken)));
    };
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      print("verifiedSuccess");
    };
    final PhoneVerificationFailed verifyFailed = (FirebaseAuthException e) {
      print('${e.message}');
      dismissProgressDialog();
      if (e.code == 'invalid-phone-number') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBoxError(
                title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
                descriptions: "The provided phone number is not valid.",
                text: AppLocalizations.of(context).translate("Ok"),
                img: "assets/images/something_went_wrong.svg",
                double: 37.0,
                isCrossIconShow: true,
                callback: () {},
              );
            });

        print('The provided phone number is not valid.');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBoxError(
                title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
                descriptions: AppLocalizations.of(context)
                    .translate("something_went_wrong"),
                text: AppLocalizations.of(context).translate("Ok"),
                img: "assets/images/something_went_wrong.svg",
                double: 37.0,
                isCrossIconShow: true,
                callback: () {},
              );
            });
      }
    };

    await FirebaseAuth.instance
        .verifyPhoneNumber(
          phoneNumber: mobileNumberWithCountryCode,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verifiedSuccess,
          verificationFailed: verifyFailed,
          codeSent: smsCodeSent,
          codeAutoRetrievalTimeout: autoRetrieve,
        )
        .then((value) {})
        .catchError((onError) {
      dismissProgressDialog();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBoxError(
              title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions: AppLocalizations.of(context)
                  .translate("something_went_wrong"),
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            );
          });
    });
  }

  callLoginAPI() {
    setState(() {
      _saving = true;
    });
    //MyUtils.showLoaderDialog(context);
    mobileNumberWithCountryCode = countryCode + mobileNumber;

    var req = {
      "countryCode": countryCode,
      "phoneNumber": mobileNumber,
      "contactMethod": "PhoneNumber"
    };

    print(req);
    var jsonReqString = json.encode(req);
    var apicall;
    apicall = createLoginRequestApi(jsonReqString);
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        //progressDialog.hide();
        setState(() {
          _saving = false;
        });
        //Navigator.pop(context);
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'].toString() == "1") {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => CodeVerificationScreen(
                  authyId: jsonResponse['authyId'],
                  mobileNumber: mobileNumber,
                  countryCode: countryCode,
                  fcmtoken: fcmtoken)));
        } else if (jsonResponse['status'].toString() == "0") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBoxError(
                  title:
                      AppLocalizations.of(context).translate("ERROR OCCURRED"),
                  descriptions: jsonResponse['message'].toString(),
                  text: AppLocalizations.of(context).translate("Ok"),
                  img: "assets/images/something_went_wrong.svg",
                  double: 37.0,
                  isCrossIconShow: true,
                  callback: () {},
                );
              });
        } else if (jsonResponse['status'].toString() == "2") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBoxError(
                  title:
                      AppLocalizations.of(context).translate("ERROR OCCURRED"),
                  descriptions: jsonResponse['message'].toString(),
                  text: AppLocalizations.of(context).translate("Ok"),
                  img: "assets/images/something_went_wrong.svg",
                  double: 37.0,
                  isCrossIconShow: true,
                  callback: () {},
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBoxError(
                  title:
                      AppLocalizations.of(context).translate("ERROR OCCURRED"),
                  descriptions: jsonResponse['message'].toString(),
                  text: AppLocalizations.of(context).translate("Ok"),
                  img: "assets/images/something_went_wrong.svg",
                  double: 37.0,
                  isCrossIconShow: true,
                  callback: () {},
                );
              });
        }
      } else {
        // progressDialog.hide();
        setState(() {
          _saving = false;
        });
        // Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBoxError(
                title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
                descriptions: AppLocalizations.of(context)
                    .translate("something_went_wrong"),
                text: AppLocalizations.of(context).translate("Ok"),
                img: "assets/images/something_went_wrong.svg",
                double: 37.0,
                isCrossIconShow: true,
                callback: () {},
              );
            });
      }
    }).catchError((error) {
      print('error : $error');
      setState(() {
        _saving = false;
      });
      //Navigator.pop(context);
    });
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void dismissProgressDialog() {
    _saving = false;
    setState(() {});
  }
}
