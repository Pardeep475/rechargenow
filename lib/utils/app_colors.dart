import 'dart:ui';

class AppColor {
  static final AppColor _appColor = AppColor._internal();

  factory AppColor() {
    return _appColor;
  }

  AppColor._internal();

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const orange = Color(0xFFFF6600);
  static const yellow = Color(0xFFFEB62B);
  static const dark_text = Color(0xFF797777);
  static const divider_color = Color(0xFFEBEBEB);
  static const search_back = Color.fromRGBO(0,0,0,.13);
  static const yellow_transparent = Color.fromRGBO(253,156,39,.70);


}