import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';


class Calculator extends StatelessWidget{

  String termID = "";
  String courseID = "";
  String category = "";

  Calculator(String term, courseID, category){
    termID = term;
    this.courseID = courseID;
    this.category = category;
  }


  @override
  Widget build(BuildContext context){
    return null;
  }

  // double calculateCategoryPercentage(List<Assignment> listOfAssignments){
  //
  //   double addedPercentages = 0;
  //   for(int i = 0; i < listOfAssignments.length; i++){
  //     addedPercentages += listOfAssignments[i].;
  //   }
  //   addedPercentages = (addedPercentages / listOfAssignments.length) * 100;
  //   return roundDouble(addedPercentages, 2);
  // }

  // double calculateCourseGPA(List<Category> listOfCategories){
  //   double percentage;
  //   for(int i = 0; i < listOfCategories.length; i++){
  //     percentage += listOfCategories[i].categoryWeight *
  //         calculateCategoryPercentage(listOfCategories[i]);
  //   }
  //   return roundDouble(percentage, 2);
  // }

  // double calculateTermGPA(int qualityPoints, int termCreditHours){
  //   return roundDouble((qualityPoints / termCreditHours) * 100, 2);
  // }
  //
  // double calculateCumulativeGPA(List<double> termGPAs){
  //   double addedGPA = 0;
  //   for(int i = 0; i < termGPAs.length; i++){
  //     addedGPA += termGPAs[i];
  //   }
  //   return roundDouble((addedGPA / termGPAs.length) * 100, 2);
  // }
  //
  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}