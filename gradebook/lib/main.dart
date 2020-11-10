import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradebook/model/user.dart';
import 'package:gradebook/pages/CategoriesPage.dart';
import 'package:gradebook/pages/WelcomePage.dart';
import 'package:gradebook/pages/auth_wrapper.dart';
import 'package:gradebook/pages/loading.dart';
import 'package:gradebook/pages/LoginPage.dart';
import 'package:gradebook/pages/SignUpPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gradebook/pages/TermsPage.dart';
import 'package:gradebook/pages/TermClassesPage.dart';
import 'package:provider/provider.dart';
import 'package:gradebook/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Gradebook());
}

//root

class Gradebook extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GradebookState();
  }
}

class _GradebookState extends State<Gradebook> {
  bool _initialized = false;
  bool _error = false;
  bool stayLoggedIn = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_initialized)
      return StreamProvider<GradeBookUser>.value(
        value: AuthService().gradebookuser,
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.grey[700],
            backgroundColor: Colors.brown[300],
            accentColor: Colors.red,
            fontFamily: GoogleFonts.quicksand().toStringShort(),
            textTheme: TextTheme(
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
            ),
          ),
          home: Wrapper(),
          routes: {
            '/Login': (context) => LoginPage(),
            '/Sign_up': (context) => SignUpPage(),
            '/Terms': (context) => TermsPage(),
            '/Home': (context) => TermClassesPage(),
            '/Categories': (context) => CategoriesPage(),
            '/Welcome': (context) => WelcomePage(),
          },
        ),
      );
    else
      return Loading();
  }
}
