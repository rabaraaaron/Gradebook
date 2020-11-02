import 'package:flutter/material.dart';
import 'package:gradebook/pages/login.dart';
import 'package:gradebook/pages/sign_up.dart';
import 'package:gradebook/pages/welcome.dart';
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


  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
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