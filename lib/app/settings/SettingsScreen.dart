import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/app/settings/EditProfileDataScreen.dart';
import 'package:recharge_now/auth/login_screen.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLanguage.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/models/user_deatil_model.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_language_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  bool _isSwitched = true;
  bool isSwitched = true;
  bool isLoading = false;
  SharedPreferences prefs;
  UserDetails userdetails;

  Map results;
  var name = '';
  var gender = "";
  var email = "";
  var mobile = "";
  var countryCode = "";
  bool _saving = false;

  var language = "";
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
    userdetails = UserDetails(phoneNumber: "ewqeqq", email: "sarbjeet");
    getDetailsApi();

    //print("shared: "+prefs.getString("locate"));
    //AppTranslations.load(Locale(MyConstants.languagesMap[ prefs.getString('locate')]));

    if (prefs.get('language') == null) {
      language = "Deutsch";
    } else {
      language = prefs.get('language');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white,
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: ModalProgressHUD(
              child: SingleChildScrollView(
                child: buildBodyUI(),
              ),
              inAsyncCall: _saving,
            )));
  }

  buildBodyUI() {
    return userdetails == null
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: Column(
        children: [
          appBarView(
              name: AppLocalizations.of(context).translate('SETTINGS'),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          Container(
            margin: EdgeInsets.fromLTRB(
                screenPadding, screenPadding, screenPadding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)
                          .translate('E-mail')
                          .toUpperCase(),
                      style: loginDetailText,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        editEmailButtonClick(
                            AppLocalizations.of(context).translate(
                                "Change E-mail Address"));
                      },
                      child: Container(
                        decoration: MyUtils.showRoundCornerDecoration(),
                        height: 45,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .80,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          email.toString(),
                          style: editTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                /*        GestureDetector(
                        onTap: () {
                          editEmailButtonClick(AppLocalizations.of(context).translate("Change E-mail Address"));
                        },
                        child:
                        SvgPicture.asset("assets/images/edit.svg")),*/
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              editMobileButtonClick(
                  AppLocalizations.of(context).translate("Change Number"));
            },
            child: Container(
              margin:
              EdgeInsets.fromLTRB(screenPadding, 0, screenPadding, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('PHONENUMBER'),
                        style: loginDetailText,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: MyUtils.showRoundCornerDecoration(),
                        height: 45,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .80,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          countryCode + mobile,
                          style: editTextStyle,
                        ),
                      ),
                    ],
                  ),
                  /*    GestureDetector(
                          onTap: () {
                            editMobileButtonClick(
                                AppLocalizations.of(context).translate("Change Number"));
                          },
                          child:
                          SvgPicture.asset("assets/images/edit.svg")),*/
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin:
            EdgeInsets.fromLTRB(screenPadding, 0, screenPadding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('batteryAlarm'),
                  style: loginDetailText,
                ),
                Expanded(
                  child: isLoading
                      ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Center(
                              child: CircularProgressIndicator())),
                    ),
                  )
                      : Container(
                    height: 45,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: CustomSwitch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          sendAmarm(value);
                          isSwitched = value;
                          print(isSwitched);
                        });
                      },

                    ),
                  ),
                ),
                /*    GestureDetector(
                        onTap: () {
                          editMobileButtonClick(
                              AppLocalizations.of(context).translate("Change Number"));
                        },
                        child:
                        SvgPicture.asset("assets/images/edit.svg")),*/
              ],
            ),
          ),
          Container(
            margin:
            EdgeInsets.fromLTRB(screenPadding, 0, screenPadding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "CHANGE LANGUAGE",
                  style: loginDetailText,
                ),
                Expanded(
                  child: isLoading
                      ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Center(
                              child: CircularProgressIndicator())),
                    ),
                  )
                      : Container(
                    height: 45,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: IconButton(
                        onPressed: () async {
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  ChangeLanguage()));
                          /*var onClick = await showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                100, 400, 100, 0),
                            items: [
                              PopupMenuItem(
                                child: Text("Setting Language"),
                                value: 1,
                              ),
                              PopupMenuItem(
                                child: Text(
                                  "English",
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                value: 2,
                              ),
                              PopupMenuItem(
                                child: Text(
                                  "Deutsch",
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                value: 3,
                              ),
                            ],
                          );
                          if (onClick != null) {
                            print("onClick$onClick");

                            if (onClick == 2) {
                              Provider.of<AppLanguage>(
                                  context,
                                  listen: false)
                                  .changeLanguage(
                                  Locale('en'));
                            } else if (onClick == 3) {
                              Provider.of<AppLanguage>(
                                  context,
                                  listen: false)
                                  .changeLanguage(
                                  Locale('de'));
                            }
                          }*/
                        },
                        icon: Icon(Icons.language)),
                  ),
                ),
                /*    GestureDetector(
                        onTap: () {
                          editMobileButtonClick(
                              AppLocalizations.of(context).translate("Change Number"));
                        },
                        child:
                        SvgPicture.asset("assets/images/edit.svg")),*/
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width - 60,
                color: Color(0xffF2F3F7),
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(50.0))),
                onPressed: () {
                  //Provider.of<AppLanguage>(context, listen: false).changeLanguage(Locale('en'));
                  LogoutApi();
                },
                child: Text(
                  AppLocalizations.of(context).translate('Logout'),
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: Color(0xff848490),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          )
        ],
      ),
    );
  }

  onEditButtonCLick1(text) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            EditProfileDataScreen(forText: text)));
  }

  onEditButtonCLick(text) async {
    results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            EditProfileDataScreen(forText: text)));

    if (results != null) {
      print("fname " + results['fname']);
      name = results['fname'];
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      print("call api on resume");
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
    }
    /*else if(state == AppLifecycleState.suspending){
      // app suspended (not used in iOS)
    }*/

    setState(() {
      // print("app comes back");
    });
  }

  @override
  Future<bool> didPopRoute() {
    print("onresume");

    return super.didPopRoute();
  }

  @override
  Future<bool> didPushRoute(String route) {
    print("onresume");
    return super.didPushRoute(route);
  }

  @override
  void initState() {
    super.initState();
    loadShredPref();
    WidgetsBinding.instance.addObserver(this);
    //nameController.text="Charger";
    //emailController.text="marcel@gmail.com";
    //phoneController.text="7397979098";
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    print("onresume");
    super.didUpdateWidget(oldWidget);
  }

  logoutButtonUi() {
    return buttonGreyView(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 48,
        text: AppLocalizations.of(context).translate("Logout"),
        callback: () {
          LogoutApi();
        });
  }

  updateProfileButtonUi() {
    return GestureDetector(
      onTap: () {
        /*   print("dd "+language);
        if(language=="German"){
          language="Hindi";
        }
        AppTranslations.load(Locale(MyConstants.languagesMap[language]));
        prefs.setString('locate', language);
  */
      },
      child: Container(
        margin: new EdgeInsets.fromLTRB(0, 60, 0, 20),
        height: 50,
        width: double.infinity,
        child: new Center(
          child: new Text("Update Profile",
              style: new TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
        ),
        decoration: new BoxDecoration(
          border: new Border.all(width: .5, color: Colors.grey),
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
      ),
    );
  }

  editGenderButtonClick(text) async {
    results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            EditProfileDataScreen(forText: text, gender: gender)));

    if (results != null) {
      print("gender " + results['gender']);
      gender = results['gender'];
      setState(() {});
    }
  }

  editNameButtonClick(text) async {
    results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            EditProfileDataScreen(forText: text, name: name)));

    if (results != null) {
      print("name " + results['name']);
      name = results['name'];
      setState(() {});
    }
  }

  editEmailButtonClick(text) async {
    results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            EditProfileDataScreen(forText: text, email: email)));

    if (results != null) {
      print("email " + results['email']);
      email = results['email'];
      //navigateToLoginScreen();

      setState(() {});
    }
  }

  editMobileButtonClick(text) async {
    results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            EditProfileDataScreen(
                forText: text, mobile: mobile, countryCode: countryCode)));

    if (results != null) {
      print("mobile " + results['mobile']);
      mobile = results['mobile'];
      countryCode = results['countryCode'];
      //navigateToLoginScreen();

      setState(() {});
    }
  }

  editLanguageButtonClick(text) async {
    results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            EditProfileDataScreen(forText: text, language: language)));

    if (results != null) {
      print("language " + results['language']);
      language = results['language'];
      prefs.setString('language', language);

      setState(() {});
    }
  }

  getDetailsApi() {
    var apicall = getUserDetailsApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        UserDetailsPojo userDetailsPojo =
        UserDetailsPojo.fromJson(jsonResponse);
        userdetails = userDetailsPojo.userDetails;
        // name=userdetails.
        prefs.setString('walletAmount', "" + userdetails.walletAmount);
        mobile = userdetails.phoneNumber;
        countryCode = userdetails.countryCode;
        email = userdetails.email;
        if (email == null) {
          email = "";
        }
        if (mobile == null) {
          mobile = "";
        }
        if (countryCode == null) {
          countryCode = "";
        }
        setState(() {});
      } else {
        final jsonResponse = json.decode(response.body);
        MyUtils.showAlertDialog(jsonResponse['message'], context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  navigateToLoginScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }

  LogoutApi() {
//    prefs.clear();
//    navigateToLoginScreen();

    setState(() {
      _saving = true;
    });
    var apicall = getLogouttApi(
        prefs.get('userId').toString(), prefs.get('accessToken').toString());
    apicall.then((response) async {
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _saving = false;
        });
        prefs.setBool('is_login', false);
        navigateToLoginScreen();
//        final jsonResponse = json.decode(response.body);
//        setState(() {
//          _saving = false;
//        });
//        //MyUtils.showAlertDialog(jsonResponse['message'].toString());
//        if (jsonResponse['status'].toString() == "1") {
//
//          prefs.setBool('is_login', false);
//          navigateToLoginScreen();
//
//        } else if (jsonResponse['status'].toString() == "0") {
//          MyUtils.showAlertDialog(jsonResponse['message'].toString(),context);
//        } else if (jsonResponse['status'].toString() == "2") {
//          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
//        } else {
//          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
//        }
//      } else {
//        setState(() {
//          _saving = false;
//        });
//        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      setState(() {
        _saving = false;
      });
      prefs.setBool('is_login', false);
      navigateToLoginScreen();
//      print('error : $error');
    });
  }

  sendAmarm(bool value) {
//    prefs.clear();
//    navigateToLoginScreen();
    prefs.setBool('betteryAlarm', value);
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomSwitch({
    Key key,
    this.value,
    this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 45.0,
            height: 28.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: Color(0xffEBEBEB), width: 1),
              color: _circleAnimation.value ==
                  Alignment.centerLeft
                  ? Color(0xffF2F3F7)
                  : Color(0xffF2F3F7),),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child: Container(
                alignment: widget.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryGreenColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
