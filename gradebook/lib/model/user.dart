import 'package:gradebook/model/term.dart';
import 'package:gradebook/model/course.dart';

class GradeBookUser {

  final String uid;
  final String email;
  final String photoUrl;
  String displayName;
  List<Term> terms;
  List<Course> courses;

  GradeBookUser({this.uid, this.email, this.photoUrl, this.displayName});

  @override
  String toString() {
    return {uid, email, photoUrl, displayName}.toString();
  }

}