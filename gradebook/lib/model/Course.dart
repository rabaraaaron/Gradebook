
import 'package:gradebook/model/Category.dart';
//import 'package:provider/provider.dart';

class Course {

  final String name;
  List<Category> categories;
  double grade = 0;
  final String credits;
  final String term;
  final int year;
  final String id;
  double _sumOfCategoriesWeights = 0.0;


  double get sumOfCategoriesWeights {
    for(var category in categories){
      _sumOfCategoriesWeights += double.parse(category.categoryWeight);
    }

    return _sumOfCategoriesWeights;

  }

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

