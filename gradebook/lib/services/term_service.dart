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
      // print ("DOCUMENT!!!!!!:" + doc.id);
      return Term(
        name: doc.get('name'),
        year: doc.get('year') ?? "",
        termID: doc.id ?? "",
        gpa:  4.0
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

  // Future<Term> get name(termID) async {
  //    // var v = termsCollection.doc(termID).snapshots().map( (doc) {return Term(
  //    //   name: doc.get('name'),
  //    //   year: doc.get('year')
  //    // );
  //    // } );
  //    var v = termsCollection.doc(termID).get()
  //   return v;
  // }

}
