import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:theme_provider/theme_provider.dart';


class MyAppTheme with ChangeNotifier{

  AppTheme _currentAppTheme;
  Color _appBarIconColor = Colors.white;
  List<AppTheme> _themeList = [];


  MyAppTheme() {
    // darkMode = false;
    // if(darkMode)
    //   b = Brightness.dark;
    // else
    //   b = Brightness.light;
    // appBar = Colors.blue[900];
    // appBarText = Colors.white;
    // accent = Colors.lightBlueAccent;
    // dividerColor = Colors.black;
    // appBarIconColor = Colors.white;
    // this._themeData = ThemeData(
    //   primaryColor: appBar,
    //   accentColor: accent,
    //   dividerColor: dividerColor,
    //   brightness: b,
    //   fontFamily: GoogleFonts.quicksand().toStringShort(),
    //   textTheme: getTextTheme(),
    //   buttonColor: appBarIconColor,
    // );
    bool dark = false;
    bool light = true;
    _themeList.add(
      AppTheme(
        id: "my_default",
        description: 'Dark Blue appbar, lightMode',
        data: ThemeData(
          primaryColor: Colors.blue[900],
          accentColor: Colors.blue,
          dividerColor: Colors.black,
          brightness: Brightness.light,
          fontFamily: GoogleFonts.quicksand().toStringShort(),
          textTheme: getTextTheme(light),
          buttonColor: _appBarIconColor,
        )
      ),
    );

    _themeList.add(
        AppTheme(
            id: "darkblue_dm",
            description: 'Dark blue appbar, darkMode',
            data: ThemeData(
              primaryColor: Colors.blue[900],
              accentColor: Colors.blue,
              dividerColor: Colors.white,
              brightness: Brightness.dark,
              fontFamily: GoogleFonts.quicksand().toStringShort(),
              textTheme: getTextTheme(dark),
              buttonColor: _appBarIconColor,
            )
        )
    );

    _themeList.add(
        AppTheme(
            id: "darkgreen_lm",
            description: 'Dark green appbar, lightMode',
            data: ThemeData(
              primaryColor: Colors.green[900],
              accentColor: Colors.green,
              dividerColor: Colors.black,
              brightness: Brightness.light,
              fontFamily: GoogleFonts.quicksand().toStringShort(),
              textTheme: getTextTheme(light),
              buttonColor: _appBarIconColor,
            )
        )
    );
    _themeList.add(
        AppTheme(
            id: "darkgreen_dm",
            description: 'Dark green appbar, darkMode',
            data: ThemeData(
              primaryColor: Colors.green[900],
              accentColor: Colors.green,
              dividerColor: Colors.white,
              brightness: Brightness.dark,
              fontFamily: GoogleFonts.quicksand().toStringShort(),
              textTheme: getTextTheme(dark),
              buttonColor: _appBarIconColor,
            )
        )
    );

    _themeList.add(
      AppTheme(
          id: "red_lm",
          description: 'Red appbar, lightMode',
          data: ThemeData(
            primaryColor: Colors.red,
            accentColor: Colors.redAccent,
            dividerColor: Colors.black,
            brightness: Brightness.light,
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(light),
            buttonColor: _appBarIconColor,
          )
      ),
    );
    _themeList.add(
      AppTheme(
          id: "red_dm",
          description: 'Red appbar, darkMode',
          data: ThemeData(
            primaryColor: Colors.red,
            accentColor: Colors.redAccent,
            dividerColor: Colors.white,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(dark),
            buttonColor: _appBarIconColor,
          )
      ),
    );

    _themeList.add(
      AppTheme(
          id: "purple_lm",
          description: 'Purple appbar, lightMode',
          data: ThemeData(
            primaryColor: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent,
            dividerColor: Colors.black,
            brightness: Brightness.light,
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(light),
            buttonColor: _appBarIconColor,
          )
      ),
    );
    _themeList.add(
      AppTheme(
          id: "purple_dm",
          description: 'Purple appbar, darkMode',
          data: ThemeData(
            primaryColor: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent,
            dividerColor: Colors.white,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(dark),
            buttonColor: _appBarIconColor,
          )
      ),
    );

    _themeList.add(
      AppTheme(
          id: "teal_lm",
          description: 'Teal appbar, lightMode',
          data: ThemeData(
            primaryColor: Colors.teal[300],
            accentColor: Colors.tealAccent[400],
            dividerColor: Colors.black,
            brightness: Brightness.light,
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(light),
            buttonColor: _appBarIconColor,
          )
      ),
    );
    _themeList.add(
      AppTheme(
          id: "teal_dm",
          description: 'Teal appbar, darkMode',
          data: ThemeData(
            primaryColor: Colors.teal[300],
            accentColor: Colors.tealAccent[400],
            dividerColor: Colors.white,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(dark),
            buttonColor: _appBarIconColor,
          )
      ),
    );
    _themeList.add(
      AppTheme(
          id: "brown_light",
          description: 'brown_light, lightMode',
          data: ThemeData(
            primaryColor: Colors.brown[400],
            accentColor: Colors.brown[300],
            dividerColor: Colors.brown,
            brightness: Brightness.light,
            backgroundColor: Colors.brown[100],
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(light),
            buttonColor: _appBarIconColor,
          )
      ),
    );
    _themeList.add(
      AppTheme(
          id: "brown_dark",
          description: 'brown_dark, lightMode',
          data: ThemeData(
            primaryColor: Colors.brown[400],
            accentColor: Colors.brown[300],
            dividerColor: Colors.brown,
            brightness: Brightness.dark,
            backgroundColor: Colors.brown[100],
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(light),
            buttonColor: _appBarIconColor,
          )
      ),
    );

    _themeList.add(
      AppTheme(
          id: "grey",
          description: 'grey, lightMode',
          data: ThemeData(
            primaryColor: Colors.grey[600],
            accentColor: Colors.grey[700],
            dividerColor: Colors.black,
            brightness: Brightness.light,
            backgroundColor: Colors.grey[400],
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(light),
            buttonColor: _appBarIconColor,
          )
      ),
    );

    _themeList.add(
      AppTheme(
          id: "grey_dark",
          description: 'grey, darkMode',
          data: ThemeData(
            primaryColor: Colors.grey[600],
            accentColor: Colors.grey[700],
            dividerColor: Colors.black,
            brightness: Brightness.dark,
            backgroundColor: Colors.grey[400],
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(dark),
            buttonColor: _appBarIconColor,
          )
      ),
    );

    _themeList.add(
      AppTheme(
          id: "deep_orange_light",
          description: 'deep_orange, lightMode',
          data: ThemeData(
            primaryColor: Colors.deepOrange[200],
            accentColor: Colors.deepOrange[400],
            dividerColor: Colors.black,
            brightness: Brightness.light,
            backgroundColor: Colors.grey[400],
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(light),
            buttonColor: _appBarIconColor,
          )
      ),
    );

    _themeList.add(
      AppTheme(
          id: "deep_orange_dark",
          description: 'deepOrange, darkMode',
          data: ThemeData(
            primaryColor: Colors.deepOrange[200],
            accentColor: Colors.deepOrange[400],
            dividerColor: Colors.white,
            brightness: Brightness.dark,
            backgroundColor: Colors.grey[400],
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: getTextTheme(dark),
            buttonColor: _appBarIconColor,
          )
      ),
    );

    // _themeList.add(
    //   AppTheme(
    //       id: "grey",
    //       description: 'grey, lightMode',
    //
    //       data: ThemeData(
    //         primaryColor: Colors.grey[600],
    //         accentColor: Colors.grey[700],
    //         dividerColor: Colors.black,
    //         brightness: Brightness.light,
    //         backgroundColor: Colors.grey[400],
    //         fontFamily: GoogleFonts.quicksand().toStringShort(),
    //         textTheme: getTextTheme(light),
    //         buttonColor: _appBarIconColor,
    //       )
    //   ),
    // );
  }



  TextTheme getTextTheme(bool lightMode){

    if(lightMode){
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
        //For text in the body of the Scaffold. Changes via light or dark mode.
        headline3: TextStyle(
            fontSize: 16.5,
            color: Colors.black,
            fontWeight: FontWeight.w300),
        headline4: TextStyle(
            fontSize: 30.0,
            color: Colors.black,
            fontWeight: FontWeight.w300),
        headline5: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w300),
        headline6: TextStyle(
            fontSize: 25.0,
            color: Colors.black,
            fontWeight: FontWeight.w300
        ),
        bodyText1: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.w300),
        bodyText2: TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18),
      );
    } else{
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
        //For text in the body of the Scaffold. Changes via light or dark mode.
        headline3: TextStyle(
            fontSize: 16.5,
            color: Colors.white,
            fontWeight: FontWeight.w300),
        headline4: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.w300),
        headline5: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.w300),
        headline6: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
            fontWeight: FontWeight.w300
        ),
        bodyText1: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.w300),
        bodyText2: TextStyle(
            //fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18),
      );
    }
  }

  setCurrentAppTheme(String str){
    for(int i = 0; i < _themeList.length; i++){
      if(str == _themeList[i].id){
        _currentAppTheme = _themeList[i];
      }
    }
    notifyListeners();
  }

  getTheme(String str){
    for(int i = 0; i < _themeList.length; i++){
      if(str == _themeList[i].id){
        return _themeList[i];
      }
    }
  }

  getThemes(){
    return _themeList;
  }

  // setTheme(Color abColor, Color acc , bool dMode){
  //   appBar = abColor;
  //   accent = acc;
  //   darkMode = dMode;
  //   if(dMode == false){
  //     b = Brightness.light;
  //     dividerColor = Colors.black;
  //   } else{
  //     b = Brightness.dark;
  //     dividerColor = Colors.white;
  //   }
  //   _themeData = ThemeData(
  //     primaryColor: abColor,
  //     accentColor: acc,
  //     dividerColor: dividerColor,
  //     brightness: b,
  //     fontFamily: GoogleFonts.quicksand().toStringShort(),
  //     textTheme: getTextTheme(),
  //     buttonColor: appBarIconColor,
  //   );
  //   notifyListeners();
  // }




  void changeTheme(String themeID){

  }
}


