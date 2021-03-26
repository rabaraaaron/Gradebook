import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Grade.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:provider/provider.dart';
import '../model/Category.dart';
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

  Future<void> addCourse(name, credits, passFail) async {
    bool duplicate;
    await courseRef
        .where('name', isEqualTo: name)
        .where('credits', isEqualTo: credits.toString())
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;
    });
    print("DUPE: " + duplicate.toString());

    if (!duplicate)
      await courseRef
          .add({
            'name': name,
            'credits': int.parse(credits),
            'gradePercent': 0,
        'passFail':passFail
          })
          .then((value) => print("Course Added"))
          .catchError((error) => print("Failed to add course: $error"));
  }

  // Future<void> updateGradePercent(courseID, gradePercent) async{
  //   await courseRef.doc(courseID).update({'gradePercent':gradePercent});
  //
  // }

  Stream<List<Course>> get courses {
    return courseRef.snapshots().map(_courseFromSnap);
  }

  List<Course> _courseFromSnap(QuerySnapshot snapshot) {
    try {
      var v = snapshot.docs.map<Course>((doc) {
        return Course(
          name: doc.get('name'),
          credits: doc.get('credits').toString() ?? "0",
          id: doc.id,
          gradePercent: doc.get('gradePercent').toString() ?? "0",
        );
      }).toList();
      return v;
    } catch (err) {
      print(
          "Error adding course form courseService.dart, catch block error is: " +
              err.toString());

      var v2 = snapshot.docs.map<Course>((doc) {
        return Course(
            name: doc.get('name'),
            credits: doc.get('credits') ?? "",
            id: doc.id,
            gradePercent: "0");
      }).toList();
      return v2;
    }
  }

  Future<void> deleteCourse(id) async {
    courseRef.doc(id).delete();
  }

  Future<void> updateCourse(name, credits, courseID, passFail) async {
    await courseRef.doc(courseID).update({
      'name': name,
      'credits': int.parse(credits),
      'passFail': passFail
    });
  }

  Future<void> calculateGrade(courseID) async {
    DocumentSnapshot course = await courseRef.doc(courseID).get();
    QuerySnapshot categories = await courseRef.doc(courseID).collection('categories').get();
    double courseGradeDecimal = 0.0;

    for ( DocumentSnapshot category in categories.docs){
      courseGradeDecimal += category.get('gradePercentAsDecimal');
    }
    double gradePercent = courseGradeDecimal;
    print(courseGradeDecimal);
    courseRef.doc(courseID).update({
      'gradePercent' : gradePercent
    });

  }

}
