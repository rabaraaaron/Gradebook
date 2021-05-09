import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradebook/services/auth_service.dart';

class UserService {

  // Collection Reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // Constructor
  final String uid;
  UserService({this.uid});

  // Update User Document
  Future updateUserDocument(uidInput, email, username, {displayName, photoUrl}) async {
    await userCollection.doc(uid).set({
      'uid': uidInput,
      'lastSignIn': DateTime.now(),
      'displayPhoto': photoUrl,
      'displayName': displayName,
      'email': email,
      'username': username,
      'window': 7,
    },

    );
  }

  // User Profile Stream
  Stream<GradeBookUser> get user{
    return userCollection.doc(FirebaseAuth.instance.currentUser.uid).snapshots().map(_userDataFromSnapshot);
  }

  GradeBookUser _userDataFromSnapshot(DocumentSnapshot snapshot)  {

      return GradeBookUser(
          uid: FirebaseAuth.instance.currentUser.uid,
          email: snapshot.get('email'),
          displayName: snapshot.get('displayName'),
          photoUrl: snapshot.get('displayPhoto'),
          username: snapshot.get('username'),
          cumulativeGPA: snapshot.get('cumulativeGPA'),
          cumulativeCredits: snapshot.get('cumulativeCredits')
      );

  }

  Future<int> getUserWindow(String uID) async{
    DocumentSnapshot userDoc = await userCollection.doc(uID).get();
    return userDoc.get('window');
  }

  Future<void> setUserWindow(String uID, int window) async{
    //DocumentSnapshot userDoc = await userCollection.doc(uID).get();
    userCollection.doc(uID).update({'window': window});
  }

  Future<bool> validateCurrentPassword(String password) async {
    return await AuthService().validatePassword(password);
  }

  Future<String> getUserName(uID) async{
    DocumentSnapshot userDoc = await userCollection.doc(uID).get();
    return userDoc.get('username');
  }

  Future<String> getDisplayName(String uID) async{
    DocumentSnapshot userDoc = await userCollection.doc(uID).get();
    return userDoc.get('displayName');
  }

}