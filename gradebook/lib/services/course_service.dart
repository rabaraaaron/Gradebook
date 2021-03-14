import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Grade.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:provider/provider.dart';
import 'assessment_service.dart';
import 'user_service.dart';

class CourseService {
  CollectionReference courseRef;

  CourseService(String termID) {
    courseRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses');
  }

  Future<void> addCourse(name, credits) async {
    bool duplicate;
    await courseRef
        .where('name', isEqualTo: name)
        .where('credits', isEqualTo: credits)
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;
    });
    print("DUPE: " + duplicate.toString());

    if (!duplicate)
      await courseRef
          .add({
            'name': name,
            'credits': credits,
            'gradePercent' : 0.0,
          })
          .then((value) => print("Course Added"))
          .catchError((error) => print("Failed to add course: $error"));
  }

  Future<void> updateGradePercent(courseID, gradePercent) async{
    await courseRef.doc(courseID).update({'gradePercent':gradePercent});

  }

  Stream<List<Course>> get courses {
    return courseRef.snapshots().map(_courseFromSnap);
  }

  List<Course> _courseFromSnap(QuerySnapshot snapshot) {
    var v = snapshot.docs.map<Course>((doc) {
      return Course(
          name: doc.get('name'), credits: doc.get('credits') ?? "", id: doc.id, gradePercent: doc.get('gradePercent'));
    }).toList();
    return v;
  }

  Future<void> deleteCourse(id) async {
      courseRef.doc(id).delete();
  }
  // String getGrade(courseID, termID){
  //   AssessmentService assessmentServ = new AssessmentService(termID, courseID, categoryID)
  //   print(courseRef.doc(courseID));
  //   return "asdfdsf";
  // }
  //
  // double getPercentage(courseID){
  //
  //   return null;
  // }
}
