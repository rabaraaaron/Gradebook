
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/term.dart';
import 'package:gradebook/model/user.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';

class TermService {
  final CollectionReference termsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('terms');


  Future<void> addTerm(name, year) async {
    await termsCollection
        .add({
          'name': name,
          'year': year,
        })
        .then((value) => print("Term Added"))
        .catchError((error) => print("Failed to add term: $error"));
  }

  Stream<List<Term>> get terms{
    return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('terms').snapshots().map(_termFromSnap);
  }

  List<Term> _termFromSnap(QuerySnapshot snapshot){
    // print(snapshot.docs.first.data());
    var v = snapshot.docs.map<Term>((doc) {
      // print(doc.get('name'));
      return Term(
          name: doc.get('name'),
          year: doc.get('year') ?? "",
      );
    }

    ).toList();
    return v;
  }

}
