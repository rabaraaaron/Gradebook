import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';

class TermService {
  final CollectionReference termsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('terms');

  Future<void> addTerm(name, year) async {
    bool duplicate;
    await termsCollection
        .where('name', isEqualTo: name)
        .where('year', isEqualTo: year)
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;});
    print("DUPE: " + duplicate.toString());

    if(!duplicate)
    await termsCollection
        .add({
          'name': name,
          'year': year,
      'gpa' : 0.0
        })
        .then((value) => print("Term Added"))
        .catchError((error) => print("Failed to add term: $error"));
  }

  Stream<List<Term>> get terms {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .snapshots()
        .map(_termFromSnap);
  }

  List<Term> _termFromSnap(QuerySnapshot snapshot) {
    var v = snapshot.docs.map<Term>((doc) {
      return Term(
        name: doc.get('name'),
        year: doc.get('year') ?? "",
        termID: doc.id ?? "",
        gpa:  doc.get('gpa'),
      );
    }).toList()
    ;
    return v;
  }

  Future<void> deleteTerm(name, year) async {
    print(termsCollection
        .where('name', isEqualTo: name)
        .where('year', isEqualTo: year)
        .get()
        .then((value) {
      String id = value.docs.first.id;
      termsCollection.doc(id).delete();
    }));
  }

  Future<void> updateTerm(termID, name, year) async {
    print('updating term ' + name + year.toString());
    // print(termsCollection
    //     .where('name', isEqualTo: name)
    //     .where('year', isEqualTo: year)
    //     .get()
    //     .then((value) {
    //   String id = value.docs.first.id;
      termsCollection.doc(termID).update({
        "name" : name,
        'year' : year,
      });
  }


  Future<void> calculateGPA (termID) async {
    QuerySnapshot courses = await termsCollection.doc(termID).collection('courses').get();
    double gpa = 0.0;
    double totalGradePoints = 0.0;

    Map<String, double> letterToPoints = {
      'A': 4.0,
      'A-': 3.7,
      'B+': 3.3,
      'B' : 3.0,
      'B-': 2.7,
      'C+': 2.3,
      'C' : 2.0,
      'C-' : 1.7,
      'D+' : 1.3,
      'D' : 1.0,
      'D-' : 0.7,
      'F' : 0.0
    };
double creditCount = 0;

    for ( DocumentSnapshot course in courses.docs){

      double gradePoints = letterToPoints[course.get('letterGrade')];

      print("${course.get('letterGrade')} , $gradePoints");

      int credits = course.get('credits');
      creditCount += credits;
      if(gradePoints != null)
        totalGradePoints += credits*gradePoints;
    }

    gpa = totalGradePoints/creditCount;

    await termsCollection.doc(termID).update({
      'gpa' : gpa,
    });
  }

}


