import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/pages/TermClassesPage.dart';
import 'package:provider/provider.dart';
import 'package:gradebook/model/user.dart';
import 'WelcomePage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GradeBookUser>(context);


      if (user == null) {
        return WelcomePage();
      } else {
        return TermClassesPage();
      }
  }
}
