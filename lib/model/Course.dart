

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
  String iconName;
  int countOfIncompleteItems = 0;
  bool equalWeights = false;
  bool passFail = false;
  bool manuallySetGrade = false;
  var url;
  double remainingWeight;


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
    this.remainingWeight,
    this.equalWeights,
    this.passFail,
    this.url,
    this.manuallySetGrade
  });

  @override
  String toString() {
    return {name, year, categories, _gradeLetter, term, credits}.toString();
  }

  String get getGradeLetter {
    return _gradeLetter;
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

