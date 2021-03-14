

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
  double _sumOfCategoriesWeights = 0.0;
  double gradePercent;



  double get sumOfCategoriesWeights {
    for(var category in categories){
      _sumOfCategoriesWeights += category.categoryWeight;
    }

    return _sumOfCategoriesWeights;

  }

  Course({this.name, this.categories, this.term, this.year, this.credits, this.id, this.gradePercent});

  @override
  String toString() {
    return {name, year, categories, _gradeLetter, term, credits}.toString();
  }

  // void updateGrade( double grade){
  //   //print("update course " + this.name + " grade from " + this.grade.toString() + " to " + grade.toString());
  //   this.grade = (grade * 100).roundToDouble()/100;
  //   notifyListeners();
  // }
  String get getGradeLetter {
    return _gradeLetter;
  }


  void updateGradeLetter(double grade) {


    if(grade > 90){
      print("this print is from course.dart line 52 : updating grade to A");
      _gradeLetter = "A";
      notifyListeners();
      return;
    }
    if(grade > 80){
      print("this print is from course.dart line 58 :updating grade to B");
      _gradeLetter = "B";
      notifyListeners();
      return;
    }
    if(grade > 70){
      _gradeLetter = "C";
      notifyListeners();
      return;
    }
    if(grade > 60){
      _gradeLetter = "D";
      notifyListeners();
      return;
    } else {
      _gradeLetter = "F";
      notifyListeners();
      return;
    }

  }


}

