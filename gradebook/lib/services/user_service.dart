import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

  // Collection Reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // Constructor
  final String uid;
  UserService({this.uid});

  // Update User Document
  Future updateUserDocument(uidInput, email, {displayName, photoUrl}) async {
    await userCollection.doc(uid).set({
      'uid': uidInput,
      'lastSignIn': DateTime.now(),
      'displayPhoto': photoUrl,
      'displayName': displayName,
      'email': email
    },

    );
  }

  // User Profile Stream
  Stream<GradeBookUser> get user{
    return userCollection.doc(FirebaseAuth.instance.currentUser.uid).snapshots().map(_userDataFromSnapshot);
  }

  GradeBookUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return GradeBookUser(
        uid: FirebaseAuth.instance.currentUser.uid,
        email: snapshot.get('email'),
        displayName: snapshot.get('displayName'),
        photoUrl: snapshot.get('displayPhoto')
    );
  }
}