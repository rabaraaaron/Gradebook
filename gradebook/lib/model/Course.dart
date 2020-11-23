import 'package:gradebook/model/Category.dart';

class Course {

  final String name;
  final List categories;
  final double grade;
  final String credits;
  final String term;
  final int year;
  final String id;


  Course({this.name, this.categories, this.grade, this.term, this.year, this.credits, this.id});

  @override
  String toString() {
    return {name, year, categories, grade, term, credits}.toString();
  }

}

