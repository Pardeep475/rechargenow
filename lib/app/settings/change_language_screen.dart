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
              name: AppLocalizations.of(context).translate('change language').toUpperCase(),
              context: context,
              callback: () {
                Navigator.pop(context);
              }),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,top: 24),
            child: InkWell(
              onTap: (){
                isEnglish=false;
                setState(() {

                });

              },
              child: Row(
                children: [
                  CustomButtom(isEnglish==true?false:true),
                  SizedBox(width: 22,),
                  SvgPicture.asset('assets/images/germanflag.svg',allowDrawingOutsideViewBox: true,),
                  SizedBox(width: 12,),
                  Text('Deutsch',style: TextStyle(
                    color: Color(0xff2F2F2F),
                    fontWeight: FontWeight.w400,fontSize: 14,height: 1.5

                  ),)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,top: 30),
            child: InkWell(
              onTap: (){
                isEnglish=true;

                setState(() {

                });
              },
              child: Row(
                children: [
                  CustomButtom(isEnglish==true?true:false),
                  SizedBox(width: 22,),
                  SvgPicture.asset('assets/images/image.svg'),    SizedBox(width: 12,),
                  Text('English',style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontWeight: FontWeight.w400,fontSize: 14,height: 1.5

                  ),)
                ],
              ),
            ),
          ),
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
          ),
        ],
      ),
    );
  }
var isEnglish=true;
  void initPrefs()async {
    SharedPreferences predfs=await SharedPreferences.getInstance();
    if(predfs.getString('language_code')=='en'){
      isEnglish=true;
    }else{
      isEnglish=false;
    }
    setState(() {

    });

  }

  void onSaveClick() {
    if(isEnglish){
      Provider.of<AppLanguage>(
          context,
          listen: false)
          .changeLanguage(
          Locale('en'));
    }else{
      Provider.of<AppLanguage>(
          context,
          listen: false)
          .changeLanguage(
          Locale('de'));
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
        decoration:
        BoxDecoration(color: isActive?primaryGreenColor:Color(0xffF2F2F2), shape: BoxShape.circle),
      ),
      decoration:
          BoxDecoration(color: Color(0xffF2F2F2), shape: BoxShape.circle),
    );
  }
}
