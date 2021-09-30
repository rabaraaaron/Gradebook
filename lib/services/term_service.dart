import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:gradebook/utils/calculator.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';

class TermService {
  final CollectionReference termsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('terms');

  Future<void> addTerm(name, year, manuallySetGPA, gpa, credits) async {
    bool duplicate;
    await termsCollection
        .where('name', isEqualTo: name)
        .where('year', isEqualTo: year)
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;
    });
    print("DUPE: " + duplicate.toString());

    if (!duplicate)
      if(manuallySetGPA){
        await termsCollection
            .add({
          'name': name,
          'year': year,
          'gpa': gpa,
          'credits': credits,
          'manuallySetGPA': manuallySetGPA,
      }).then((value) => print("Term Added"))
            .catchError((error) => print("Failed to add term: $error"));
            }else {
        await termsCollection
            .add({
          'name': name,
          'year': year,
          'gpa': 0.0,
          'credits': 0.0,
          'manuallySetGPA': manuallySetGPA
        })
            .then((value) => print("Term Added"))
            .catchError((error) => print("Failed to add term: $error"));
      }
    await Calculator().calcCumulativeGPA();
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
        year: doc.get('year') ?? 0,
        termID: doc.id ?? "",
        gpa: doc.get('gpa') ?? double.tryParse(doc.get('gpa')),
        credits: doc.get('credits') ?? double.tryParse(doc.get('credits')),
        manuallySetGPA: doc.get('manuallySetGPA')
      );
    }).toList();
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
    await Calculator().calcCumulativeGPA();
  }

  Future<void> updateTerm(termID, name, year, manuallySetGPA,[gpa, credits]) async {
    print('updating term ' + name + year.toString());
    if(manuallySetGPA){
      termsCollection.doc(termID).update({
        "name": name,
        'year': year,
        'manuallySetGPA':manuallySetGPA,
        'gpa': gpa,
        'credits': credits,
      });
    }else {
      termsCollection.doc(termID).update({
        "name": name,
        'year': year,
        'manuallySetGPA': manuallySetGPA,
        'gpa':0.0,
        'credits':0.0
      });
    }
    if(manuallySetGPA)
      await Calculator().calcCumulativeGPA();
    else
      await Calculator().calculateGPA(termID);
  }


}
