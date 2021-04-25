
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/Course.dart';

import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/utils/calculator.dart';


class CourseService {
  CollectionReference courseRef;
  String termID;

  CourseService(String termID) {
    courseRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses');

    this.termID = termID;
  }

  Future<void> addCourse(name, credits, passFail, equalWeights) async {
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
            'letterGrade' : "",
            'passFail':passFail,
            'iconName': "default",
            'countOfIncompleteItems' : 0,
            'remainingWeight' : 100.0,
            'equalWeights': equalWeights,
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
          letterGrade: doc.get('letterGrade'),
          iconName: doc.get('iconName') ?? 'default',
          countOfIncompleteItems: doc.get('countOfIncompleteItems') ?? 0,
          remainingWeight: doc.get('remainingWeight').toDouble() ?? 100.0,
          equalWeights: doc.get('equalWeights') ?? false,
          passFail: doc.get('passFail') ?? false,
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
            gradePercent: "0",
            iconName: doc.get('iconName') ?? 'default',
            countOfIncompleteItems: doc.get('countOfIncompleteItems') ?? 0,
            remainingWeight: doc.get('remainingWeight').toDouble() ?? 100.0,
            equalWeights: doc.get('equalWeights') ?? false,
            passFail: doc.get('passFail') ?? false,
        );
      }).toList();
      return v2;
    }
  }

  Future<void> deleteCourse(id) async {
    await courseRef.doc(id).delete();
    await TermService().calculateGPA(courseRef.parent.id);
  }

  Future<String> getCourseName(id) async {
    DocumentSnapshot courseSnap = await courseRef.doc(id).get();
    //print("----" + courseSnap.get('name'));

    //await TermService().calculateGPA(courseRef.parent.id);
    return courseSnap.get('name');
  }

  Future<void> updateCourse(name, credits, courseID, passFail, equalWeights) async {
    DocumentSnapshot courseSnap = await courseRef.doc(courseID).get();
    bool ew = courseSnap.get('equalWeights');

    if(ew != equalWeights){
      QuerySnapshot categoriesSnap = await courseRef.doc(courseID).collection('categories').get();
      for(DocumentSnapshot category in categoriesSnap.docs){
        await CategoryService(termID, courseID).setEqualWeightsState(category.id, equalWeights);
        await Calculator().recalculateGrades(termID,courseID);
      }

    }

    await courseRef.doc(courseID).update({
      'name': name,
      'credits': int.parse(credits),
      'passFail': passFail,
      'equalWeights': equalWeights,
    });
    //Todo: check with Mike if this is needed
    Calculator().calcCourseGrade(termID, courseID);
  }
  Future<void> updateCourseIcon(courseID, iconName) async {
    await courseRef.doc(courseID).update({
      'iconName': iconName,
    });
  }
  Future<void> decreaseRemainingWeight(courseID, weight) async {
    var courseSnap = await courseRef.doc(courseID).get();
    var remaining = courseSnap.get('remainingWeight');

    await courseRef.doc(courseID).update({
      'remainingWeight': remaining - weight,
    });
  }
  Future<void> increaseRemainingWeight(courseID, weight) async {
    var courseSnap = await courseRef.doc(courseID).get();
    var remaining = courseSnap.get('remainingWeight');

    await courseRef.doc(courseID).update({
      'remainingWeight': remaining + weight,
    });
  }



}
