import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/User.dart';
import 'package:gradebook/services/user_service.dart';



class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create user obj based on FirebaseUser
  GradeBookUser _userFromFirebaseUser(User user) {
    return user != null ? GradeBookUser(uid: user.uid, email: user.email, photoUrl: user.photoURL, displayName: user.displayName) : null;
  }

  // auth change user stream
  Stream<GradeBookUser> get gradebookuser {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }


  // sign in with email & password
  Future signInEmailPass (context, String email, String password) async {
    try{
      User user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;

      // User profile
      return _userFromFirebaseUser(user);
    }
    catch(e){
      displayMessage(context, e.message, "Error logging in");

    //   print("signInEmailPass error");
    //   print(e.toString());
    //   return null;
     }
  }

  // register with email & password
  Future regEmailPass (context, String email, String password, String displayName) async {
    try{
      User user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;

      // User profile
      await UserService(uid: user.uid).updateUserDocument(user.uid, user.email, displayName: displayName);
      return _userFromFirebaseUser(user);
    }
    catch(e){
      displayMessage(context, e.message, "Error creating user");
      print("regemailpass error");
      print(e.toString());
      return null;
    }
  }
  Future<bool> validatePassword(String password) async{
    var firebaseUser = _auth.currentUser;
    var autCredential = EmailAuthProvider.credential(email: firebaseUser.email, password: password);
    try {
      var authResult = await firebaseUser.reauthenticateWithCredential(
          autCredential);

    return authResult.user != null;
    } catch (err){
      print(err.toString() + " ------------");
      return false;
    }
  }

  // sign out
  Future signOut(context) async{
    try {
      return await _auth.signOut();
    }
    catch(e){
      displayMessage(context, e.message, "Error signing out");
      print('signout error');
      print(e.toString());
      return null;
    }
  }
  Future resetPassword (context, String email) async {
    try{

      // User profile
      await _auth.sendPasswordResetEmail(email: email);
      return true;

    }
    catch(e){
      displayMessage(context, e.message, "Reset password Error ");
      print("ResetPassword error");
      print(e.toString());
      return false;
    }
  }
  void displayMessage(context, String msg, String title){
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 6),
      flushbarPosition: FlushbarPosition.BOTTOM,

    ).show(context);

  }

  Future<void> updateUserPassword(String newPassword) async{
   await _auth.currentUser.updatePassword(newPassword);
  }

  // User getCurrentUser(){
  //   return _auth.currentUser;
  // }

}
