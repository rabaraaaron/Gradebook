import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/category_service.dart';

class AssessmentService {
  CollectionReference assessmentRef;
  String catID;
  String courseID;
  String termID;

  AssessmentService(String termID, courseID, categoryID) {
    this.catID = categoryID;
    this.courseID = courseID;
    this.termID = termID;

    assessmentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses').doc(courseID)
        .collection("categories")
        .doc(categoryID)
        .collection('assessments');
  }

  Future<void> addAssessment(name, totalPoints, yourPoints) async {
      await assessmentRef
          .add({
        'name': name,
        'totalPoints': totalPoints,
        'yourPoints' : yourPoints
      })
          .then((value) => print("Assessment Added ( name: " + name + ", YP: " + yourPoints + ", TP: " + totalPoints ))
          .catchError((error) => print("Failed to add course: $error"));
      //await CategoryService(termID, courseID).calculateGrade(catID);
  }

  Stream<List<Assessment>> get assessments {
    return assessmentRef.snapshots().map(_assessmentFromSnap);
  }

  List<Assessment> _assessmentFromSnap(QuerySnapshot snapshot) {
    var v = snapshot.docs.map<Assessment>((doc) {

      var tp = double.parse(doc.get('totalPoints'));
      var yp = double.parse(doc.get('yourPoints'));
      var perc = yp/tp;

      return Assessment(
          name: doc.get('name'),
          totalPoints: tp ?? "",
          yourPoints: yp ?? "",
          id: doc.id,
          catID: catID,
          courseID: courseID,
          termID: termID
      );
    }).toList();
    return v;
  }

  Future<void> deleteAssessment(id) async {

    await assessmentRef.doc(id).delete().then((value) => print("Deleted assessment "))
        .catchError((error) => print("Failed to delete assessment: $error"));
  }
  Future<void> updateAssessmentName(id, name) async {
    // print(id);
    // print(name);
    await assessmentRef.doc(id).update({'name': name});
  }
}
