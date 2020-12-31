import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextTheme{

  static List<TextStyle> textStyleList = new List<TextStyle>();

  AppTextTheme(){


  }

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
