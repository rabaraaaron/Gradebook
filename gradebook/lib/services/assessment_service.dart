import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';

class AssessmentService {
  CollectionReference courseRef;

  AssessmentService(String termID) {
    courseRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses');
  }

  Future<void> addCourse(name, TotalPoints, YourPoints) async {
    // bool duplicate;
    // await courseRef
    //     .where('name', isEqualTo: name)
    //     .where('credits', isEqualTo: TotalPoints)
    //     .get()
    //     .then((value) {
    //   duplicate = value.docs.isNotEmpty;
    // });
    // print("DUPE: " + duplicate.toString());
    //
    // if (!duplicate)
      await courseRef
          .add({
        'name': name,
        'credits': TotalPoints,
      })
          .then((value) => print("Course Added"))
          .catchError((error) => print("Failed to add course: $error"));
  }

  Stream<List<Assessment>> get courses {
    return courseRef.snapshots().map(_assessmentFromSnap);
  }

  List<Assessment> _assessmentFromSnap(QuerySnapshot snapshot) {
    var v = snapshot.docs.map<Assessment>((doc) {
      return Assessment(
          name: doc.get('name'), totalPoints: doc.get('totalPoints') ?? "", id: doc.id);
    }).toList();
    return v;
  }

  Future<void> deleteCourse(id) async {
    courseRef.doc(id).delete();
  }
}
