import 'package:gradebook/model/term.dart';

class GradeBookUser {

  final String uid;
  final String email;
  final String photoUrl;
  String displayName;
  List<Term> terms;

  GradeBookUser({this.uid, this.email, this.photoUrl, this.displayName});

  @override
  String toString() {
    return {uid, email, photoUrl, displayName}.toString();
  }

}