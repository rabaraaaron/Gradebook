import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/dueDateQuery.dart';


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
        .collection('users').doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms').doc(termID)
        .collection('courses').doc(courseID)
        .collection("categories").doc(categoryID)
        .collection("assessments");
  }


  Future<void> addAssessment(name, totalPoints, yourPoints, isCompleted, [dueDate]) async {

     try{
       await assessmentRef
           .add({
         'name': name,
         'totalPoints': totalPoints,
         'yourPoints' : yourPoints,
         'isDropped' : false,
         'createDate' : getFormattedDate(),
         'isCompleted' : isCompleted,
         'dueDate' : dueDate ?? null

       })
           .then((value) => print("Assessment Added ( name: " + name + ", YP: " + yourPoints + ", TP: " + totalPoints ))
           .catchError((error) => print("Failed to add assessment: $error"));

       await CategoryService(termID, courseID).calculateGrade(catID);
     } catch (e){
       print('Error in adding assessment: ' + e.toString());
    }

    List dueAssessments = await DueDateQuery().getAssessmentsDue();

     //print(dueAssessments);

  }
// //todo: ========================================================
//   Stream<List<Assessment>> get pendingAssessments {
//
//     return assessmentRef.snapshots().map(_incompleteFromSnap);
//   }
//   List<Assessment> _incompleteFromSnap(QuerySnapshot snapshot) {
//
//     var list = snapshot.docs.map<Assessment>((doc) {
//       var tp = double.parse(doc.get('totalPoints'));
//       var yp = double.parse(doc.get('yourPoints'));
//       DateTime dueDate;
//       if(doc.get('dueDate') != null)
//         dueDate = doc.get('dueDate').toDate();
//       return Assessment(
//         name: doc.get('name'),
//         totalPoints: tp ?? "",
//         yourPoints: yp ?? "",
//         isDropped: doc.get('isDropped') ?? false,
//         isCompleted: doc.get('isCompleted') ?? false,
//         createDate: doc.get('createDate') ?? 000000000,
//         id: doc.id,
//         catID: catID,
//         courseID: courseID,
//         termID: termID,
//         dueDate: dueDate ?? DateTime.now().subtract(Duration(days: 1))
//       );
//     }).toList();
//
//
//     var incompleteAssessments = list.where((element) => !element.isCompleted).toList();
//
//     return incompleteAssessments;
//   }
//   //todo: ========================================================

  Stream<List<Assessment>> get assessments {
    return assessmentRef.snapshots().map(_assessmentFromSnap);
  }

  List<Assessment> _assessmentFromSnap(QuerySnapshot snapshot) {
    
    var v = snapshot.docs.map<Assessment>((doc) {
      var tp = double.parse(doc.get('totalPoints'));
      var yp = double.parse(doc.get('yourPoints'));
      DateTime dueDate;
      if(doc.get('dueDate') != null)
         dueDate = doc.get('dueDate').toDate();
      return Assessment(
          name: doc.get('name'),
          totalPoints: tp ?? "",
          yourPoints: yp ?? "",
          isDropped: doc.get('isDropped') ?? false,
          isCompleted: doc.get('isCompleted') ?? false,
          createDate: doc.get('createDate') ?? 000000000,
          id: doc.id,
          catID: catID,
          courseID: courseID,
          termID: termID,
          dueDate: dueDate ?? DateTime.now().subtract(Duration(days: 1))
      );
    }).toList();

    ///sort by date here.
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
    // await CategoryService(termID, courseID).calculateGrade(catID);
  }
  Future<void> updateDropState(id, bool drop) async {
    // print(id);
    // print(name);
    await assessmentRef.doc(id).update({'isDropped': drop});
    // await CategoryService(termID, courseID).calculateGrade(catID);
  }

  /// Convert current date to a string of numbers so we can
  /// use it for sorting the assessments by creation date.
  /// @return Date in the following format "2021325182346"
  int getFormattedDate(){
    DateTime now = DateTime.now();
    String convertedDateTime = "${now.year}" +
        "${now.month.toString().padLeft(2,'0')}" +
        "${now.day.toString().padLeft(2,'0')}" +
        "${now.hour.toString().padLeft(2,'0')}" +
        "${now.minute.toString().padLeft(2,'0')}" +
        "${now.second.toString().padLeft(2,'0')}";
    //print(convertedDateTime);
    int createDate = int.parse(convertedDateTime);
    return createDate;

  }

  Future<void> updateDueDate (DateTime date, String assessmentID){
    assessmentRef.doc(assessmentID).update({
      'dueDate' : date
    });
    return null;
  }
  Future<void> updateAssessmentData (
      Assessment a,
      String name,
      String tp,
      String yp,
      bool isCompleted,
      DateTime dateTime
      ) async {

    await assessmentRef.doc(a.id).update({
      'name' :name,
      'totalPoints' : tp,
      'yourPoints' : yp,
      'isCompleted' : isCompleted,
      'dueDate': dateTime ?? null
    });
    await CategoryService(termID, courseID).calculateGrade(catID);

  }

  void displayMessage(context, String msg, String title){
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 6),
      flushbarPosition: FlushbarPosition.BOTTOM,

    ).show(context);

  }


}
