import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:provider/provider.dart';
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
          })
          .then((value) => print("Course Added"))
          .catchError((error) => print("Failed to add course: $error"));
  }

  Stream<List<Course>> get courses {
    return courseRef.snapshots().map(_courseFromSnap);
  }

  List<Course> _courseFromSnap(QuerySnapshot snapshot) {
    var v = snapshot.docs.map<Course>((doc) {
      return Course(
          name: doc.get('name'), credits: doc.get('credits') ?? "", id: doc.id);
    }).toList();
    return v;
  }

  Future<void> deleteCourse(id) async {
      courseRef.doc(id).delete();
  }
}