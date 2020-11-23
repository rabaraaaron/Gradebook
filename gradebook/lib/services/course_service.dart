import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/term.dart';
import 'package:gradebook/model/course.dart';
import 'package:gradebook/model/user.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';


class CoursesService {
  final CollectionReference termCoursesCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('terms')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('courses');

  Future<void> addCourse(title, credits) async {
    bool duplicate;
    await termCoursesCollection
        .where('title', isEqualTo: title)
        .where('credits', isEqualTo: credits)
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;});
    print("DUPE: " + duplicate.toString());

    if(!duplicate)
      await termCoursesCollection
          .add({
        'title': title,
        'credits': credits,
      })
          .then((value) => print("Course Added"))
          .catchError((error) => print("Failed to add course: $error"));
  }

  Stream<List<Course>> get courses{
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('course')
        .snapshots()
        .map(_coursesFromSnap);
  }

  List<Course> _coursesFromSnap(QuerySnapshot snapshot) {
    // print(snapshot.docs.first.data());
    var v = snapshot.docs.map<Course>((doc) {
      // print(doc.get('name'));
      return Course(
          title: doc.get('title'),
          credits: doc.get('credits') ?? "",
      );
    }).toList()
    ;
    return v;
  }

  Future<void> deleteCourse(title, credits) async {
    print(termCoursesCollection
        .where('title', isEqualTo: title)
        .where('credits', isEqualTo: credits)
        .get()
        .then((value) {
      String id = value.docs.first.id;
      termCoursesCollection.doc(id).delete();
    }));
  }
}
