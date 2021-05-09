import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/User.dart';
import 'package:gradebook/services/user_service.dart';
import 'package:gradebook/services/validator_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create user obj based on FirebaseUser
  GradeBookUser _userFromFirebaseUser(User user) {
    //print('dispaly name : ' + user.displayName);
    return user != null
        ? GradeBookUser(
            uid: user.uid,
            email: user.email,
            photoUrl: user.photoURL,
            displayName: user.displayName,
          )
        : null;
  }

  // auth change user stream
  Stream<GradeBookUser> get gradebookuser {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in with email & password
  Future signInEmailPass(context, String username, String password) async {
    bool isEmail = false;
    if (ValidatorService().validateEmail(username) == null) {
      isEmail = true;
    }

    try {
      User user;

      if (isEmail) {
        user = (await _auth.signInWithEmailAndPassword(
                email: username, password: password))
            .user;
      } else {
        String userEmail = await getUserEmail(username);

        user = (await _auth.signInWithEmailAndPassword(
                email: userEmail, password: password))
            .user;
      }

      // User profile
      return _userFromFirebaseUser(user);
    } catch (e) {
      displayMessage(context, e.message, "Error logging in");

      //   print("signInEmailPass error");
      //   print(e.toString());
      //   return null;
    }
  }

  Future<String> getUserEmail(String username) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    String email;

    final userSnap =
        await userCollection.where('username', isEqualTo: username).get();
    List<QueryDocumentSnapshot> test = userSnap.docs;

    for (QueryDocumentSnapshot snapshot in test) {
      if (snapshot.get('username') == username) {
        email = snapshot.get('email');
      }
    }

    return email;
  }

  // register with email & password
  Future regEmailPass(context, String email, String password,
      String displayName, String username) async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      // User
      if (username.isEmpty) {
        await UserService(uid: user.uid).updateUserDocument(
            user.uid,
            user.email,
            user.email, //<<--- Default value: set the username as email if the user didn't enter a username.
            displayName: displayName);
      } else {
        await UserService(uid: user.uid).updateUserDocument(
            user.uid,
            user.email,
            username,
            displayName: displayName);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'cumulativeGPA': 0.00,
        'cumulativeCredits' : 0.00
      },SetOptions(merge: true));

      return _userFromFirebaseUser(user);
    } catch (e) {
      displayMessage(context, e.message, "Error creating user");
      print("regemailpass error");
      print(e.toString());
      return null;
    }
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = _auth.currentUser;
    var autCredential = EmailAuthProvider.credential(
        email: firebaseUser.email, password: password);
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(autCredential);

      return authResult.user != null;
    } catch (e) {
      print(e.toString() + " ------------");
      return false;
    }
  }

  // sign out
  Future signOut(context) async {
    try {
      return await _auth.signOut();
    } catch (e) {
      displayMessage(context, e.message, "Error signing out");
      print('signout error');
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(context, String email) async {
    try {
      // User profile
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      displayMessage(context, e.message, "Reset password Error ");
      print("ResetPassword error");
      print(e.toString());
      return false;
    }
  }

  void displayMessage(context, String msg, String title) {
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 6),
      flushbarPosition: FlushbarPosition.BOTTOM,
    ).show(context);
  }

  Future<void> updateUserPassword(String newPassword) async {
    await _auth.currentUser.updatePassword(newPassword);
  }
}
