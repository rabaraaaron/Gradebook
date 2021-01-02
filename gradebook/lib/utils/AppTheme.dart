import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  static Color appBar = Colors.green;
  static Color appBarText = Colors.white;
  static Color accent = Colors.lightGreen;
  static Color bodyText = Colors.black;
  static bool lightMode = true;
  static Color appBarIconColor = Colors.white;
  static Color bodyIconColor = Colors.black;

  static void changeTheme(Color appBar, Color appBarText, Color accent,
      {bool lightMode}){
    AppTheme.appBar = appBar;
    AppTheme.appBarText = appBarText;
    AppTheme.accent = accent;
    AppTheme.lightMode = lightMode;
    if(!lightMode){
      bodyText = Colors.white;
      bodyIconColor = Colors.white;
    } else{
      bodyText = Colors.black;
      bodyIconColor = Colors.black;
    }
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

  static TextTheme getTextTheme(){
    return TextTheme(
      //For text inside a widget with the primary theme color.
      headline1: TextStyle(
          fontSize: 40.0,
          color: Colors.white,
          fontWeight: FontWeight.w400),
      headline2: TextStyle(
          fontSize: 35.0,
          color: Colors.white,
          fontWeight: FontWeight.w300),
      headline3: TextStyle(
          fontSize: 15.0,
          color: AppTheme.bodyText,
          fontWeight: FontWeight.w300),
      //For text in the body of the Scaffold. Changes via light or dark mode.
      headline4: TextStyle(
          fontSize: 30.0,
          color: AppTheme.bodyText,
          fontWeight: FontWeight.w300),
      headline5: TextStyle(
          fontSize: 20.0,
          color: AppTheme.bodyText,
          fontWeight: FontWeight.w300),

    );
  }
}
