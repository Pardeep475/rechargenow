import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:recharge_now/common/myStyle.dart';
import 'package:recharge_now/locale/AppLanguage.dart';
import 'package:recharge_now/locale/AppLocalizations.dart';
import 'package:recharge_now/utils/MyCustumUIs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeLanguageState();
  }
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          appBarViewEndBtn(
              name: AppLocalizations.of(context)
                  .translate('change language')
                  .toUpperCase(),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 24),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      isEnglish = false;
                      setState(() {});
                    },
                    child: CustomButtom(isEnglish == true ? false : true)),
                SizedBox(
                  width: 17,
                ),
                SizedBox(
                  width: 21,
                  height: 14,
                  child: Image.asset(
                    'flags/de.png',
                    package: 'country_code_picker',
                    fit: BoxFit.cover,
                  ),
                ),
                // SvgPicture.asset('assets/images/germanflag.svg',allowDrawingOutsideViewBox: true,),
                SizedBox(
                  width: 12,
                ),
                Text(
                  'Deutsch',
                  style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      isEnglish = true;

                      setState(() {});
                    },
                    child: CustomButtom(isEnglish == true ? true : false)),
                SizedBox(
                  width: 17,
                ),
                SizedBox(
                  width: 21,
                  height: 14,
                  child: Image.asset(
                    'flags/gb.png',
                    package: 'country_code_picker',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  'English',
                  style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5),
                )
              ],
            ),
          ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: GestureDetector(
                      onTap: () {
                        onSaveClick();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: custumButtonWithShape(
                            AppLocalizations.of(context)
                                .translate("Save Changes"),
                            primaryGreenColor),
                      )),
                )),
          ),
        ],
      ),
    );
  }

  var isEnglish = true;

  void initPrefs() async {
    SharedPreferences predfs = await SharedPreferences.getInstance();
    if (predfs.getString('language_code') == 'de') {
      isEnglish = false;
    } else {
      isEnglish = true;
    }
    setState(() {});
  }

  void onSaveClick() {
    if (isEnglish) {
      Provider.of<AppLanguage>(context, listen: false)
          .changeLanguage(Locale('en'));
    } else {
      Provider.of<AppLanguage>(context, listen: false)
          .changeLanguage(Locale('de'));
    }
    Navigator.pop(context);
  }
}

class CustomButtom extends StatelessWidget {
  bool isActive;

  CustomButtom(this.isActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 26,
      alignment: Alignment.center,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            color: isActive ? primaryGreenColor : Color(0xffF2F2F2),
            shape: BoxShape.circle),
      ),
      decoration:
          BoxDecoration(color: Color(0xffF2F2F2), shape: BoxShape.circle),
    );
  }
}
//flags/${json['code'].toLowerCase()}.png
