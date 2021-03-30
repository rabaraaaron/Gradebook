

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:provider/provider.dart';

class Course with ChangeNotifier {

  final String name;
  List<Category> categories;
  String _gradeLetter = "--";
  final String credits;
  final String term;
  final int year;
  final String id;
  String gradePercent;
  String letterGrade;
  String   iconName;
  int countOfIncompleteItems = 0;


  Course({
    this.name,
    this.categories,
    this.term,
    this.year,
    this.credits,
    this.id,
    this.gradePercent,
    this.letterGrade,
    this.iconName,
    this.countOfIncompleteItems,
  });

  @override
  String toString() {
    return {name, year, categories, _gradeLetter, term, credits}.toString();
  }

  // void updateGrade( double grade){
  //   this.grade = (grade * 100).roundToDouble()/100;
  //   notifyListeners();
  // }
  String get getGradeLetter {
    return _gradeLetter;
  }

}

