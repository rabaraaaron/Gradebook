

import 'package:gradebook/model/Term.dart';

class GradeBookUser {

  final String uid;
  final String email;
  final String photoUrl;
  final String username;
  String displayName;
  List<Term> terms;
  final double cumulativeGPA;
  final double cumulativeCredits;


  GradeBookUser({this.uid, this.email, this.photoUrl, this.displayName, this.username, this.cumulativeGPA, this.cumulativeCredits});

  @override
  String toString() {
    return {uid, email, displayName, username, cumulativeGPA, cumulativeCredits}.toString();
  }

}