import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:recharge_now/apiService/web_service.dart';
import 'package:recharge_now/auth/code_verification_screen.dart';
import 'package:recharge_now/common/AllStrings.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:recharge_now/utils/MyUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileDataScreen extends StatefulWidget {
  var forText, name, gender, language, email, mobile, countryCode;

  EditProfileDataScreen(
      {this.email,
      this.mobile,
      this.countryCode,
      this.name,
      this.forText,
      this.gender,
      this.language});

  @override
  _EditProfileDataScreenState createState() => _EditProfileDataScreenState();
}

class _EditProfileDataScreenState extends State<EditProfileDataScreen> {
  var f_name, l_name, email, mobile;
  int _currVal = 1;
  String _currText = '';
  SharedPreferences prefs;
  Map results;

  int _currValLang = 1;
  String _currTextLang = '';

  final nameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  List<GroupModel> genderTypes = [
    GroupModel(
      text: "Male",
      index: 1,
    ),
    GroupModel(
      text: "Female",
      index: 2,
    )
  ];

  List<GroupModel> languageTypes = [
    GroupModel(
      text: "English",
      index: 1,
    ),
    GroupModel(
      text: "German",
      index: 2,
    )
  ];



  @override
  void initState() {
    //  for name
    loadShredPref();
    print(widget.countryCode.toString());
    if (widget.name != null && widget.name != "") {
      f_name = widget.name.toString().split(" ")[0];
      l_name = widget.name.toString().split(" ")[1];
    }
    fnameController.text = f_name;
    lnameController.text = l_name;
    if(widget.email!=null) {
      emailController.text = widget.email;
    }else{
      phoneController.text = widget.countryCode+"\t"+widget.mobile;
    }


    super.initState();
    if (widget.gender == "Male") {
      _currVal = 1;
      _currText = "Male";
    } else {
      _currVal = 2;
      _currText = "Female";
    }

    //for languages

    if (widget.language == "English") {
      _currValLang = 1;
      _currTextLang = "English";
    } else {
      _currValLang = 2;
      _currTextLang = "German";
    }

    // fnameController.text=widget.name;
  }

  var fname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color_white,
        body: Column(
          children: [
            appBarViewEndBtn(
                name:  widget.forText,
                context: context,
                callback: () {
                  Navigator.pop(context);
                }),
            buildBodyUI(),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 24),
                    child: GestureDetector(
                        onTap: () {
                          onSaveClick();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: custumButtonWithShape(
                              AppLocalizations.of(context).translate("Save Changes"),
                              primaryGreenColor),
                        )),
                  )),
            ),],
        ));
    ;
  }
  var lableStyle=TextStyle(
      fontSize: 11,
      height: 1.5,
      color: Color(0xff686868),
      fontFamily: fontFamily,
      fontWeight: FontWeight.w600
  );
  var textFieldText = TextStyle(
      fontSize: 13,
      height: 1.6,
      color: Colors.black,
      fontFamily: fontFamily,

      fontWeight: FontWeight.w500);
  buildBodyUI() {

    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Stack(
        children: <Widget>[
          Visibility(
            visible: widget.name == null ? false : true,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "First Name",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  //SizedBox(height: 5,),

                  TextField(
                    controller: fnameController,
                    //autofocus: true,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    onChanged: (text) {
                      f_name = text;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        //border: InputBorder.none,
                        // hintText: 'First Name',
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    "Last Name",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  //SizedBox(height: 5,),

                  TextField(
                    controller: lnameController,
                    //autofocus: true,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    onChanged: (text) {
                      l_name = text;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        //border: InputBorder.none,
                        // hintText: 'Last Name',
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
            visible: widget.email == null ? false : true,
            child: Container(
              margin: EdgeInsets.only(top: 31),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate("E-mail"),
                    style: lableStyle,
                  ),
                  SizedBox(height: 7,),

                  Container(
                    decoration: MyUtils.showRoundCornerDecoration(),
                    height: 45,
                    width: MediaQuery.of(context).size.width * .80,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10, right: 10,bottom: 8,),
                    child: TextField(
                      controller: emailController,
                      //autofocus: true,
                      textAlign: TextAlign.start,
                      style: textFieldText,
                      onChanged: (text) {
                        widget.email = text;
                      },
                      textInputAction: TextInputAction.done,

                      decoration: InputDecoration(
                          border: InputBorder.none,
                          // hintText: 'First Name',

                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),

                  //SizedBox(height: 5,),
                ],
              ),
            ),
          ),

          Visibility(
            visible: widget.mobile == null ? false : true,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate("Phone"),
                    style: lableStyle,
                  ),
                  SizedBox(height: 10,),
                  Container(
                    decoration: MyUtils.showRoundCornerDecoration(),
                    height: 45,
                    width: MediaQuery.of(context).size.width * .80,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10, right: 10,bottom: 8),
                    child: TextField(
                      controller: phoneController,
                      //autofocus: true,
                      textAlign: TextAlign.start,
                      style: textFieldText,
                      onChanged: (text) {
                        widget.mobile = text;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          // hintText: 'First Name',
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  )



                  //SizedBox(height: 5,),
                ],
              ),
            ),
          ),

          Visibility(
            visible: widget.gender == null ? false : true,
            child: Container(
              child: Column(
                children: genderTypes
                    .map((t) => SizedBox(
                          height: 40,
                          child: RadioListTile(
                            activeColor: Colors.green,
                            dense: true,
                            title: Text(
                              "${t.text}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            groupValue: _currVal,
                            value: t.index,
                            onChanged: (val) {
                              setState(() {
                                _currVal = t.index;
                                _currText = t.text;
                                print(_currVal);
                                print(_currText);
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

          //for languages
          Visibility(
            visible: widget.language == null ? false : true,
            child: Container(
              child: Column(
                children: languageTypes
                    .map((t) => SizedBox(
                          height: 40,
                          child: RadioListTile(
                            activeColor: Colors.green,
                            dense: true,
                            title: Text(
                              "${t.text}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            groupValue: _currValLang,
                            value: t.index,
                            onChanged: (val) {
                              setState(() {
                                _currValLang = t.index;
                                _currTextLang = t.text;
                                print(_currValLang);
                                print(_currTextLang);
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),


        ],
      ),
    );
  }

  onSaveClick() {
    if (widget.name != null) {
      if (f_name.trim().length == 0) {
        MyUtils.showAlertDialog("Please enter first name", context);
      } else if (l_name.trim().length == 0) {
        MyUtils.showAlertDialog("Please enter last name", context);
      } else {
        setUserNameApi();
      }
    }

    if (widget.email != null) {
      if (widget.email.trim().length == 0) {
        MyUtils.showAlertDialog(
            AppLocalizations.of(context).translate("Please enter email"),
            context);
      } else {
        setEmailApi();
      }
    }

    if (widget.mobile != null) {
      if (widget.mobile.trim().length == 0) {
        MyUtils.showAlertDialog(
            AppLocalizations.of(context)
                .translate("Please enter mobile number"),
            context);
      } else {
        setPhoneNumberApi();
      }
    }

    if (widget.language != null) {
      var lang = "";
      if (_currTextLang == "German") {
        lang = "Hindi";
      } else {
        lang = "English";
      }

      // AppTranslations.load(Locale(MyConstants.languagesMap[lang]));
      prefs.setString('locate', lang);

      if (widget.language != null) {
        Navigator.of(context).pop({'language': _currTextLang});
      }
    }
  }

  onEditButtonCLick(text) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            EditProfileDataScreen(forText: text)));
  }

  setUserNameApi() {
    var name = f_name + " " + l_name;
    var req = {"userId": prefs.get('userId').toString(), "username": name};
    var jsonReqString = json.encode(req);
    print(jsonReqString);
    var apicall =
        updateUsernameApi(jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'].toString() == "1") {
          // MyUtils.showAlertDialog(jsonResponse['message']);

          if (widget.name != null) {
            Navigator.of(context).pop({'name': name});
          }
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'], context);
        }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  setEmailApi() {
    var req = {"id": prefs.get('userId').toString(), "email": widget.email};
    var jsonReqString = json.encode(req);
    print(jsonReqString);
    var apicall =
        updateEmailApi(jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //MyUtils.showAlertDialog(jsonResponse['message']);

        if (jsonResponse['status'].toString() == "1") {
          if (widget.email != null) {
            Navigator.of(context).pop({'email': widget.email});
          }
        } else if (jsonResponse['status'].toString() == "0") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  setPhoneNumberApi() {
    var userId = prefs.get('userId').toString();
    var req = {
      "id": userId,
      "countryCode": widget.countryCode.toString(),
      "phoneNumber": widget.mobile,
    };
    var jsonReqString = json.encode(req);
    print(jsonReqString);
    var apicall = sendOtpToUpdatePhoneNumberApi(
        jsonReqString, prefs.get('accessToken').toString());
    apicall.then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //MyUtils.showAlertDialog(jsonResponse['message']);

        if (jsonResponse['status'].toString() == "1") {
          if (widget.mobile != null) {
            //Navigator.of(context).pop({'mobile':widget.mobile,'countryCode':widget.countryCode});
            /*  Navigator.of(context).push(new MaterialPageRoute(
                 builder: (BuildContext context) => CodeVerificationScreen(authyId:jsonResponse['authyId'],mobileNumber:widget.mobile,countryCode: widget.countryCode,purpose:"updateMobile")));
*/

            sendOtpScreen(jsonResponse['authyId']);
          }
        } else if (jsonResponse['status'].toString() == "0") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else if (jsonResponse['status'].toString() == "2") {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        } else {
          MyUtils.showAlertDialog(jsonResponse['message'].toString(), context);
        }
      } else {
        MyUtils.showAlertDialog(AllString.something_went_wrong, context);
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  void loadShredPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  sendOtpScreen(authyId) async {
    results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => CodeVerificationScreen(
            authyId: authyId,
            mobileNumber: widget.mobile,
            countryCode: widget.countryCode,
            purpose: "updateMobile")));
    if (results != null) {
      print("update " + results['update'].toString());
      //navigateToLoginScreen();
      if (results['update'] == true) {
        Navigator.of(context)
            .pop({'mobile': widget.mobile, 'countryCode': widget.countryCode});
      }
    }
  }
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}
