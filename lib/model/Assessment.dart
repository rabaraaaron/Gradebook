

import 'package:flutter/foundation.dart';
import 'package:gradebook/services/assessment_service.dart';

class Assessment with ChangeNotifier{

  String name;
  double totalPoints;
  double yourPoints;
  final String id;
  final String catID;
  final String termID;
  final String courseID;
  final int createDate;
  bool isDropped = false;
  bool isCompleted = false;
  String downloadURL = "";
  DateTime dueDate;


  Assessment({
    this.name,
    this.totalPoints,
    this.yourPoints,
    this.id,
    this.catID,
    this.courseID,
    this.termID,
    this.isDropped,
    this.createDate,
    this.isCompleted,
    this.dueDate,
    this.downloadURL,

  });

  // bool LowestScoreCompare(Assessment a1, Assessment a2) {
  //   return a2.yourPoints < a1.yourPoints;
  // }
  // @override
  // double compareTo(Assessment other) => this.createDate.toDouble() - other.createDate.toDouble();

  @override
  int compareTo(Assessment that) {
    return that.createDate - this.createDate;
  }

  // @override
  // int compareTo(Assessment that) {
  //   return that.createDate.difference(this.createDate).inSeconds;
  // }


  // @override
    // double compareTo(Assessment other) => this.yourPoints - other.yourPoints;


    @override
    String toString() {
    String line = "\n---------- Printing Assessment ------------";
    String name = "\n   Name: " + this.name;
    String tp = "\n   TP: " + this.totalPoints.toString();
    String yp = "\n   YP: " + this.yourPoints.toString();
    String id = "\n   ID: " + this.id;
    String catID = "\n   catID: " + this.catID;
    String termID = "\n   termID: " + this.termID;
    String courseID = "\n   courseID: " + this.courseID;
    String createDate = "\n   createDate: " + this.createDate.toString();
    String isDropped = "\n   isDropped: " + this.isDropped.toString();
    String isCompleted = "\n   isCompleted: " + this.isCompleted.toString();
    String dueDate = "\n   dueDate: " + this.dueDate.toString();
    String downloadURL = "\n  downloadURL: " + this.downloadURL;
    String line2 = "\n---------------------------------------------" ;

      return {line, name, tp, yp, id, catID, termID, courseID, createDate, isDropped, isCompleted, dueDate, downloadURL,line2}.toString();
    }
  String getFormattedNumber( num ) {
    //double x = ((cat.gradePercentAsDecimal / cat.categoryWeight)* 100);
    var result;
    if(num % 1 == 0) {
      result = num.toInt();
    } else {
      result = num.toStringAsFixed(2);
    }
    return result.toString();
  }
}

