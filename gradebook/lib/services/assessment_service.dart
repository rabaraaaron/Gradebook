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

  Future<void> addAssessment(name, totalPoints, yourPoints, [dueDate]) async {

      await assessmentRef
          .add({
        'name': name,
        'totalPoints': totalPoints,
        'yourPoints' : yourPoints,
        'isDropped' : false,
        'createDate' : getFormattedDate(),
        'dueDate' : dueDate ?? null

      })
          .then((value) => print("Assessment Added ( name: " + name + ", YP: " + yourPoints + ", TP: " + totalPoints ))
          .catchError((error) => print("Failed to add course: $error"));
      await CategoryService(termID, courseID).calculateGrade(catID);
  }

  Stream<List<Assessment>> get assessments {
    return assessmentRef.snapshots().map(_assessmentFromSnap);
  }

  List<Assessment> _assessmentFromSnap(QuerySnapshot snapshot) {
    
    var v = snapshot.docs.map<Assessment>((doc) {

      var tp = double.parse(doc.get('totalPoints'));
      var yp = double.parse(doc.get('yourPoints'));
      var perc = yp/tp;
      // var test = doc.get('createDate');
      // print(" ---->" + test);
      //DateTime myDateTime = (doc.get('createDate')).toDate();

      return Assessment(
          name: doc.get('name'),
          totalPoints: tp ?? "",
          yourPoints: yp ?? "",
          isDropped: doc.get('isDropped') ?? false,
          createDate: int.parse(doc.get('createDate')) ?? 0000000,
          id: doc.id,
          catID: catID,
          courseID: courseID,
          termID: termID,
          dueDate:  doc.get('dueDate').toDate()
      );
    }).toList();

    ///sort by date before here.
    v.sort((a, b) => b.createDate.compareTo(a.createDate));

    return v;
  }

  Future<void> deleteAssessment(id) async {

    await assessmentRef.doc(id).delete().then((value) => print("Deleted assessment "))
        .catchError((error) => print("Failed to delete assessment: $error"));
    await CategoryService(termID, courseID).calculateGrade(catID);
  }
  Future<void> updateAssessmentName(id, name) async {
    // print(id);
    // print(name);
    await assessmentRef.doc(id).update({'name': name});
    await CategoryService(termID, courseID).calculateGrade(catID);
  }
  Future<void> updateDropState(id, bool drop) async {
    // print(id);
    // print(name);
    await assessmentRef.doc(id).update({'isDropped': drop});
    await CategoryService(termID, courseID).calculateGrade(catID);
  }

  /// Convert current date to a string of numbers so we can
  /// use it for sorting the assessments by creation date.
  /// @return Date in the following format "2021325182346"
  String getFormattedDate(){
    DateTime now = DateTime.now();
    String convertedDateTime = "${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}";
    print(convertedDateTime);
    return convertedDateTime;

  }

  Future<void> updateDueDate (DateTime date, String assessmentID){
    assessmentRef.doc(assessmentID).update({
      'dueDate' : date
    });
  }


}
