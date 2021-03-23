

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
  bool dropped = false;
  final String  dropString = " (Dropped)";


  Assessment({this.name, this.totalPoints, this.yourPoints, this.id, this.catID, this.courseID, this.termID});

  // bool LowestScoreCompare(Assessment a1, Assessment a2) {
  //   return a2.yourPoints < a1.yourPoints;
  // }
  @override
  double compareTo(Assessment other) => this.yourPoints - other.yourPoints;


  @override
  String toString() {
    return {name, totalPoints, yourPoints}.toString();
  }

  // void drop(){
  //   dropped = true;
  //   this.name = name + dropString;
  //  // var assessmentServ = AssessmentService(termID, courseID, catID);
  //   //assessmentServ.updateAssessmentName(id, name);
  //
  // }
  //  void unDrop(){
  //    dropped = false;
  //    name.replaceAll(dropString, '');
  //  }

}