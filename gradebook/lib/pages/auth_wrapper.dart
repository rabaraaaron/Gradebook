import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/pages/TermClasses.dart';
import 'package:provider/provider.dart';
import 'package:gradebook/model/user.dart';
import 'welcome.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GradeBookUser>(context);


      if (user == null) {
        return Welcome();
      } else {
        return TermClasses();
      }
  }
}
