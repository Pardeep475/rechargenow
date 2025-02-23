import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/auth/release_location.dart';
import 'package:recharge_now/common/custom_dialog_box_error.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeVerificationScreen extends StatefulWidget {
  var authyId, mobileNumber, countryCode, otp, email, fcmtoken, purpose;

  CodeVerificationScreen(
      {this.otp,
      this.email,
      this.authyId,
      this.mobileNumber,
      this.countryCode,
      this.fcmtoken,
      this.purpose});

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  var otp = "";

  SharedPreferences prefs;
  var digitComplete = false;
  bool _saving = false;
  var verificationId = "";

  @override
  void initState() {
    // _getCurrentLocation();
    initSession();
    permissionCode();
    super.initState();
  }

  initSession() async {
    prefs = await SharedPreferences.getInstance();
    verificationId = widget.authyId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: color_white,
          child: ModalProgressHUD(
            child: SingleChildScrollView(child: buildBodyUI()),
            inAsyncCall: _saving,
          )),
    );
  }

  buildBodyUI() {
    return Container(
      child: Column(
        children: <Widget>[
          appBarView(
              name: AppLocalizations.of(context).translate('Security code'),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          SizedBox(
            height: 18,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: screenPadding, right: screenPadding),
            child: Text(
              AppLocalizations.of(context).translate('Enter the 6 digit code'),
              style: sliderTitleTextStyle,
            ),
          ),
          SizedBox(
            height: 55,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: screenPadding, top: 10, right: screenPadding),
            child: Text(
              AppLocalizations.of(context).translate('Security code'),
              textAlign: TextAlign.left,
              style: loginDetailText,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: screenPadding, top: 10, right: screenPadding),
            child: PinInputTextField(
              pinLength: 6,
              decoration: BoxLooseDecoration(
                  radius: Radius.circular(5),
                  strokeWidth: 1,
                  strokeColorBuilder: FixedColorListBuilder([
                    Color(0xFFEBEBEB),
                    Color(0xFFEBEBEB),
                    Color(0xFFEBEBEB),
                    Color(0xFFEBEBEB),
                    Color(0xFFEBEBEB),
                    Color(0xFFEBEBEB),
                  ]),
                  // strokeColor: Color(0xFFEBEBEB),
                  gapSpace: 8),
              onSubmit: (pin) {},
              onChanged: (pin) {
                otp = pin;
                if (otp.trim().length == 6) {
                  digitComplete = true;
                } else {
                  digitComplete = false;
                }
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 45,
          ),
          Container(
            child: buttonView(
                text: AppLocalizations.of(context).translate('Next'),
                callback: () {
                  nextButtonClick();
                }),
            margin: EdgeInsets.only(left: screenPadding, right: screenPadding),
          ),
          SizedBox(
            height: 18,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: screenPadding, top: 10, right: screenPadding),
            child: buttonGreyView(
                height: 48,
                text: AppLocalizations.of(context).translate('RESEND CODE'),
                width: double.infinity,
                callback: () {
                  //resendOtp();
                  resendVerificationCode();
                }),
          ),
        ],
      ),
    );
  }

  void nextButtonClick() {
    if (otp.trim().length < 6) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBoxError(
              title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions: "Please enter otp sent to your mobile",
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            );
          });
    } else {
      if (widget.purpose == "updateMobile") {
        updatePhoneNumberApiAPI();
      } else {
        signIn(otp);
        //verify_app_userApiAPI();
      }
    }
  }

  permissionCode() async {}

  callLoginAPI() async {
    var mobileNumberWithCountryCode = "";
    showProgress();
    //MyUtils.showLoaderDialog(context);
    mobileNumberWithCountryCode = widget.countryCode + widget.mobileNumber;

    String deviceToken = await prefs.getString('fcmtoken');
    debugPrint("firebase_token    $deviceToken");
    var req = {
      "countryCode": widget.countryCode,
      "phoneNumber": widget.mobileNumber,
      "deviceToken": deviceToken
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
          debugPrint(
              "user_id_is   ---->   ${jsonResponse['userDetails']['id']}");
          prefs.setBool('is_login', true);
          prefs.setInt('userId', jsonResponse['userDetails']['id']);
          prefs.setString(
              'accessToken', jsonResponse['userDetails']['accessToken']);
          prefs.setString('usercode', jsonResponse['userDetails']['usercode']);
          prefs.setString('walletAmount',
              jsonResponse['userDetails']['walletAmount'].toString());
          prefs.setBool('isRental', jsonResponse['isRental']);
          navigateToReleaseLocationScreen();
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

  Future<void> signIn(String smsCode) async {
    print("verificationId$verificationId");
    showProgress();
    if (smsCode != null && smsCode != '') {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      FirebaseAuth auth = FirebaseAuth.instance;

      // Wait for the user to complete the reCAPTCHA & for a SMS code to be sent.
      //  ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(widget.phoneNumber);
      // UserCredential userCredential = await confirmationResult.confirm('123456');
      await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        print("userRegisteruid${user.user.uid}");
        dismissProgressDialog();
        callLoginAPI();
        //checkUserExistedOrNot(user.user.uid);
      }).catchError((signUpError) {
        print("Exceptiom ${signUpError}");

        if (signUpError is FirebaseAuthException) {
          print("CheckErrorCode${signUpError.code}");
          if (signUpError.code.trim() == 'invalid-verification-code'.trim()) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBoxError(
                    title: AppLocalizations.of(context)
                        .translate("ERROR OCCURRED"),
                    descriptions:
                        'The entered OTP is incorrect. Please try again.',
                    text: AppLocalizations.of(context).translate("Ok"),
                    img: "assets/images/something_went_wrong.svg",
                    double: 37.0,
                    isCrossIconShow: true,
                    callback: () {},
                  );
                });
          } else if (signUpError.code.trim() == 'session-expired'.trim()) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBoxError(
                    title: AppLocalizations.of(context)
                        .translate("ERROR OCCURRED"),
                    descriptions:
                        'The SMS code has expired. Please re-send the verification code to try again.',
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
                    title: AppLocalizations.of(context)
                        .translate("ERROR OCCURRED"),
                    descriptions: signUpError.toString(),
                    text: AppLocalizations.of(context).translate("Ok"),
                    img: "assets/images/something_went_wrong.svg",
                    double: 37.0,
                    isCrossIconShow: true,
                    callback: () {},
                  );
                });
          }
          //Utils.showSnackBar(signUpError.toString(), context);
        }
        dismissProgressDialog();
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBoxError(
              title: AppLocalizations.of(context).translate("ERROR OCCURRED"),
              descriptions: "Please enter otp.",
              text: AppLocalizations.of(context).translate("Ok"),
              img: "assets/images/something_went_wrong.svg",
              double: 37.0,
              isCrossIconShow: true,
              callback: () {},
            );
          });
    }
  }

  Future<void> resendVerificationCode() async {
    showProgress();
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
            phoneNumber: widget.phoneNumber,
          ),
          context);*/
    };
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      print("verifiedSuccess");
    };
    final PhoneVerificationFailed verifyFailed = (FirebaseAuthException e) {
      print('${e.message}');
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
    };

    await FirebaseAuth.instance
        .verifyPhoneNumber(
          phoneNumber: widget.countryCode + widget.mobileNumber,
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

  verify_app_userApiAPI() {
    setState(() {
      _saving = true;
    });
    //MyUtils.showLoaderDialog(context);
    var req = {
      "countryCode": widget.countryCode,
      "phoneNumber": widget.mobileNumber,
      "contactMethod": "PhoneNumber",
      "authyId": widget.authyId,
      "otp": otp,
      "deviceToken": widget.fcmtoken
    };

    print(req);
    var jsonReqString = json.encode(req);
    var apicall;
    apicall = verify_app_userApi(jsonReqString);
    apicall.then((response) {
      setState(() {
        _saving = false;
      });
      print(response.body);
      //Navigator.pop(context);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // print(jsonResponse);

        if (jsonResponse['status'].toString() == "1") {
          debugPrint(
              "user_id_is   ---->   ${jsonResponse['userDetails']['id']}");
          prefs.setBool('is_login', true);
          prefs.setInt('userId', jsonResponse['userDetails']['id']);
          prefs.setString(
              'accessToken', jsonResponse['userDetails']['accessToken']);
          prefs.setString('usercode', jsonResponse['userDetails']['usercode']);
          prefs.setString('walletAmount',
              jsonResponse['userDetails']['walletAmount'].toString());
          prefs.setBool('isRental', jsonResponse['isRental']);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ReleaseLocationScreen()),
              (Route<dynamic> route) => false);
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
      setState(() {
        _saving = false;
      });
      //Navigator.pop(context);
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
      // print('error : $error');
    });
  }

  updatePhoneNumberApiAPI() {
    setState(() {
      _saving = true;
    });
    //MyUtils.showLoaderDialog(context);
    var req = {
      "id": prefs.get('userId').toString(),
      "countryCode": widget.countryCode,
      "phoneNumber": widget.mobileNumber,
      "authyId": widget.authyId,
      "otp": otp,
    };

    print(req);
    var jsonReqString = json.encode(req);
    var apicall;
    apicall = updatePhoneNumberApi(
        jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      setState(() {
        _saving = false;
      });
      //Navigator.pop(context);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // print(jsonResponse);

        if (jsonResponse['status'].toString() == "1") {
          prefs.setBool('is_login', true);
          /* prefs.setInt('userId', jsonResponse['userDetails']['id']);
          prefs.setString('accessToken', jsonResponse['userDetails']['accessToken']);
          prefs.setString('usercode', jsonResponse['userDetails']['usercode']);
          prefs.setDouble('walletAmount', jsonResponse['userDetails']['walletAmount']);
          prefs.setBool('isRental', jsonResponse['isRental']);
*/

          /*     Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => SettingsScreen()));
*/

          /* var results =    Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>SettingsScreen(authyId:jsonResponse['authyId'],mobileNumber:widget.mobile,countryCode: widget.countryCode,purpose:"updateMobile")));
          if (results != null ) {
            print("email "+results['email']);*/
          //navigateToLoginScreen();
          Navigator.of(context).pop({'update': true});
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
      setState(() {
        _saving = false;
      });
      //Navigator.pop(context);
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

  resendOtp() {
    setState(() {
      _saving = true;
    });
    //MyUtils.showLoaderDialog(context);
    var req = {
      "countryCode": widget.countryCode,
      "phoneNumber": widget.mobileNumber,
      "contactMethod": "PhoneNumber",
    };

    print(req);
    var jsonReqString = json.encode(req);
    var apicall;
    apicall = resendOtpApi(jsonReqString);
    apicall.then((response) {
      print(response.body);
      setState(() {
        _saving = false;
      });
      // Navigator.pop(context);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          widget.authyId = jsonResponse['authyId'].toString();
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
      // print('error : $error');
      //Navigator.pop(context);
      setState(() {
        _saving = false;
      });
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

  void dismissProgressDialog() {
    _saving = false;
    setState(() {});
  }

  void navigateToReleaseLocationScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ReleaseLocationScreen()),
        (Route<dynamic> route) => false);
  }

  void showProgress() {
    setState(() {
      _saving = true;
    });
  }

/*  _getCurrentLocation() {
    // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    Geolocator().getCurrentPosition().then((Position position) {
      MyConstants.currentLat = position.latitude;
      MyConstants.currentLong = position.longitude;

      print("onLocationChanged code verification screen : " +
          MyConstants.currentLat.toString() +
          " : " +
          MyConstants.currentLong.toString());
    }).catchError((e) {
      print(e);
    });
  }*/

/* getLocation() async {
    LocationData _locationData;
    // try {
    _locationData = await Location().getLocation();

    */ /*} on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
      }else if(e.code == "PERMISSION_DENIED_NEVER_ASK"){
        var  error = 'Permission denied';
      }
      //_locationData = null;
    }*/ /*

    MyConstants.currentLat = _locationData.latitude;
    MyConstants.currentLong = _locationData.longitude;

    print("onLocationChanged code verification screen : " +
        MyConstants.currentLat.toString() +
        " : " +
        MyConstants.currentLong.toString());
  }*/
}
