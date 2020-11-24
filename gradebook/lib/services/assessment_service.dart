import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';

class AssessmentService {
  CollectionReference assessmentRef;

  AssessmentService(String termID, courseID, categoryID) {
    assessmentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses').doc(courseID)
        .collection("categories").doc(categoryID).collection('assessments');
  }

  Future<void> addAssessment(name, totalPoints, yourPoints) async {
      await assessmentRef
          .add({
        'name': name,
        'totalPoints': totalPoints,
        'yourPoints' : yourPoints
      })
          .then((value) => print("Course Added"))
          .catchError((error) => print("Failed to add course: $error"));
  }

  Stream<List<Assessment>> get assessments {
    return assessmentRef.snapshots().map(_assessmentFromSnap);
  }

  List<Assessment> _assessmentFromSnap(QuerySnapshot snapshot) {
    var v = snapshot.docs.map<Assessment>((doc) {
      print ("HERERERERE!" + doc.data().toString());
      var tp = double.parse(doc.get('totalPoints'));
      var yp = double.parse(doc.get('yourPoints'));
      return Assessment(
          name: doc.get('name'),
          totalPoints: tp ?? "",yourPoints: yp ?? "", id: doc.id
      );
    }).toList();
    return v;
  }

  Future<void> deleteAssessment(id) async {
    await assessmentRef.doc(id).delete();
  }
}
