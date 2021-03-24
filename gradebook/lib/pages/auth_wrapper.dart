import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/rabar/OneDrive/Desktop/499/grade-book/gradebook/lib/pages/Term/TermsPage.dart';
import 'package:provider/provider.dart';
import 'package:gradebook/model/User.dart';
import 'WelcomePage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<GradeBookUser>(context);

      if (user == null) {
        print("welcome");
        return WelcomePage();
      } else {
        print("Terms");

        return TermsPage();
      }
  }
}
