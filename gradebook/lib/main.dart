import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gradebook/model/User.dart';
import 'package:gradebook/pages/Category/CategoryPage.dart';
import 'package:gradebook/pages/Courses/CoursePage.dart';
import 'package:gradebook/pages/Settings/SettingsPage.dart';
import 'package:gradebook/pages/Term/TermsPage.dart';
import 'package:gradebook/pages/Assessment/UpcomingAssignmentsPage.dart';
import 'package:gradebook/pages/Login_related_pages/WelcomePage.dart';
import 'package:gradebook/pages/Login_related_pages/auth_wrapper.dart';
import 'package:gradebook/utils/loading.dart';
import 'package:gradebook/pages/Login_related_pages/LoginPage.dart';
import 'package:gradebook/pages/Login_related_pages/SignUpPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gradebook/pages/Login_related_pages/pswdRecoveryPage.dart';
import 'package:gradebook/utils/MyAppTheme.dart';
import 'package:provider/provider.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:theme_provider/theme_provider.dart';

FlutterLocalNotificationsPlugin localNotification;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var initializeAndroid =
    AndroidInitializationSettings('icon');

  var initializeIOS = IOSInitializationSettings();

  var initializationSettings = InitializationSettings(
      android: initializeAndroid, iOS: initializeIOS);

  localNotification = FlutterLocalNotificationsPlugin();

  localNotification.initialize(initializationSettings);

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
        child: ChangeNotifierProvider<MyAppTheme>(
          create: (_) => MyAppTheme(),
            child: new MaterialAppWithTheme()
        ),
      );
    else
      return Loading();
  }
}

class MaterialAppWithTheme extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final theme = Provider.of<MyAppTheme>(context);
    List<AppTheme> themes = theme.getThemes();

    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      defaultThemeId: 'my_default',
      themes:
        List.generate(themes.length, (index) {
          return themes[index];
        }),

      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            home: Wrapper(),
            routes: {
              '/Login': (context) => LoginPage(),
              '/Sign_up': (context) => SignUpPage(),
              '/Terms': (context) => TermsPage(),
              '/Home': (context) => TermCoursePage(),
              '/Categories': (context) => CategoryPageWrap(),
              '/Welcome': (context) => WelcomePage(),
              '/resetPassword': (context) => ResetPassword(),
              '/Settings': (context) => SettingsPage(),
              '/Upcoming': (context) => UpcomingAssignments(),
            },
          ),
        ),
      ),
    );
  }

}