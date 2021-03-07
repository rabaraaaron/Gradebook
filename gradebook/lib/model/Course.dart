import 'package:flutter/foundation.dart';
import 'package:gradebook/model/Category.dart';
import 'package:provider/provider.dart';

class Course {

  final String name;
  final List categories;
  double grade = 0;
  final String credits;
  final String term;
  final int year;
  final String id;


  Course({this.name, this.categories, this.grade, this.term, this.year, this.credits, this.id});

  @override
  String toString() {
    return {name, year, categories, grade, term, credits}.toString();
  }

  void updateGrade( double grade){
    print("update course " + this.name + " grade from " + this.grade.toString() + " to " + grade.toString());
    this.grade = grade;
    //notifyListeners();
  }

}

