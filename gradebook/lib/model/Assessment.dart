

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
    this.createDate, this.dueDate,
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
    // double compareTo(Assessment other) => this.yourPoints - other.yourPoints;


    @override
    String toString() {
      return {name, totalPoints, yourPoints}.toString();
    }
  }

