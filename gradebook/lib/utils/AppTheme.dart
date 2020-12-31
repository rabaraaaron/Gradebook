

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradebook/utils/AppTextTheme.dart';

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

  static ThemeData getThemeData(){
    return ThemeData(
      brightness: getBrightness(),
      primaryColor: appBar,
      accentColor: accent,
      fontFamily: GoogleFonts.quicksand().toStringShort(),
      textTheme: AppTextTheme.getTextTheme(),
    );
  }
}