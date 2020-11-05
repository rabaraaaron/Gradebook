import 'package:flutter/material.dart';
import 'package:gradebook/pages/login.dart';
import 'package:gradebook/pages/sign_up.dart';
import 'package:gradebook/pages/welcome.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:gradebook/pages/Terms.dart';
import 'package:gradebook/pages/TermClasses.dart';
import 'package:gradebook/pages/Categories.dart';

void main(){
runApp(Gradebook());
}

//root

class Gradebook extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GradebookState();
  }
}

class _GradebookState extends State<Gradebook>{
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.white,
        // fontFamily: GoogleFonts.quicksand().toStringShort(),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.w400),
          headline2: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.w300),
          headline3: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w100),
          headline4: TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.w100),
          headline5: TextStyle(fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.w200),
        ),

      ),

      routes: {
        '/': (context) => Welcome(),
        '/Login': (context) => Login(),
        '/Sign_up': (context) => SignUp(),
        '/Terms': (context) => TermsPage(),
        '/Home': (context) => TermClasses(),
        '/Categories': (context) => Categories(),
      },
    );
  }
}