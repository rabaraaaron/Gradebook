import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:provider/provider.dart';


// class Calculator extends StatelessWidget{
//
//   String termID = "";
//   String courseID = "";
//   String category = "";
//
//   Calculator(String term, courseID, category){
//     termID = term;
//     this.courseID = courseID;
//     this.category = category;
//   }
//
//
//   @override
//   Widget build(BuildContext context){
//     return null;
//   }
//
//   // double calculateCategoryPercentage(List<Assignment> listOfAssignments){
//   //
//   //   double addedPercentages = 0;
//   //   for(int i = 0; i < listOfAssignments.length; i++){
//   //     addedPercentages += listOfAssignments[i].;
//   //   }
//   //   addedPercentages = (addedPercentages / listOfAssignments.length) * 100;
//   //   return roundDouble(addedPercentages, 2);
//   // }
//
//   // double calculateCourseGPA(List<Category> listOfCategories){
//   //   double percentage;
//   //   for(int i = 0; i < listOfCategories.length; i++){
//   //     percentage += listOfCategories[i].categoryWeight *
//   //         calculateCategoryPercentage(listOfCategories[i]);
//   //   }
//   //   return roundDouble(percentage, 2);
//   // }
//
//   // double calculateTermGPA(int qualityPoints, int termCreditHours){
//   //   return roundDouble((qualityPoints / termCreditHours) * 100, 2);
//   // }
//   //
//   // double calculateCumulativeGPA(List<double> termGPAs){
//   //   double addedGPA = 0;
//   //   for(int i = 0; i < termGPAs.length; i++){
//   //     addedGPA += termGPAs[i];
//   //   }
//   //   return roundDouble((addedGPA / termGPAs.length) * 100, 2);
//   // }
//   //
//   double roundDouble(double value, int places){
//     double mod = pow(10.0, places);
//     return ((value * mod).round().toDouble() / mod);
//   }
// }

class Calculator {
  final Completer a = new Completer();

  Future<String> calc (Course course, Term term){
   final myStream = CategoryService(term.termID, course.id).categories;


   final sub = myStream.listen( (data) {
     Category category;
     List<Category> categories = data;
     a.complete(data);
     // for (category in categories) {
     //   print('${category.categoryName}');
     //
     //   final assessmentStream = AssessmentService(term.termID, course.id, category.id).assessments;
     //   assessmentStream.listen( (data) {
     //     Assessment assessment;
     //     List<Assessment> assessments = data;
     //     for (assessment in assessments){
     //       double average
     //       print('${assessment.name}');
     //     }
     //   });
     //
     // }
   });

  }

}