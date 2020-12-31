import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  static Color appBar = Colors.teal;
  static Color appBarText = Colors.white;
  static Color accent = Colors.tealAccent;
  static Color bodyText = Colors.black12;
  static bool lightMode = true;

  static void changeTheme(Color appBar, Color appBarText, Color accent,
      Color bodyText, {bool lightMode}){
    AppTheme.appBar = appBar;
    AppTheme.appBarText = appBarText;
    AppTheme.accent = accent;
    AppTheme.bodyText = bodyText;
    AppTheme.lightMode = lightMode;
  }

  static Brightness getBrightness(){
    if(AppTheme.lightMode == true){
      return Brightness.light;
    } else{
      return Brightness.dark;
    }
  }

  static ThemeData getThemeData() {
    return ThemeData(
      brightness: getBrightness(),
      primaryColor: appBar,
      accentColor: accent,
      fontFamily: GoogleFonts.quicksand().toStringShort(),
      textTheme: AppTextTheme.getTextTheme(),
    );
  }

}

class AppTextTheme{

  static List<TextStyle> textStyleList = new List<TextStyle>();


  static TextTheme getTextTheme(){
    return TextTheme(
      headline1: TextStyle(
          fontSize: 30.0,
          color: Colors.white,
          fontWeight: FontWeight.w300),
      headline2: TextStyle(
          fontSize: 30.0,
          color: Colors.white,
          fontWeight: FontWeight.w300),
      headline3: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
          fontWeight: FontWeight.w100),
      headline4: TextStyle(
          fontSize: 40.0,
          color: Colors.white,
          fontWeight: FontWeight.w100),
      headline5: TextStyle(
          fontSize: 25.0,
          color: Colors.white,
          fontWeight: FontWeight.w200),
    );
  }
}
