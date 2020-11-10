import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/user.dart';
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
      display(context, e.message, "Error logging in");

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
      display(context, e.message, "Error creating user");
      print("regemailpass error");
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut(context) async{
    try {
      return await _auth.signOut();
    }
    catch(e){
      display(context, e.message, "Error signing out");
      print('signout error');
      print(e.toString());
      return null;
    }
  }
  void display(context, String msg, String title){
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 6),
      flushbarPosition: FlushbarPosition.BOTTOM,

    ).show(context);

  }

}
