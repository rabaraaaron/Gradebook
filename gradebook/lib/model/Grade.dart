import 'package:flutter/material.dart';
import 'package:gradebook/pages/loading.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:provider/provider.dart';

import 'Assessment.dart';
import 'Category.dart';
import 'Course.dart';

class Grade extends StatefulWidget {
  Course course;
  String termID;

  Grade(course, termID){
    this.course = course;
    this.termID = termID;

  }

  @override
  _GradeState createState() {
    return  _GradeState(course, termID);
  }
}

class _GradeState extends State<Grade> {
  Course course;
  String termID;

  _GradeState(course, termID){
    this.termID = termID;
    this.course = course;
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Category>>.value(
      value: CategoryService(termID, course.id).categories,
      child: GradeWidget(course, termID),
    );
  }


}
class GradeWidget extends StatefulWidget {

  Course course;
  String termID;

  GradeWidget(course, termID){
    this.course = course;
    this.termID = termID;

  }

  @override
  _GradeWidgetState createState() => _GradeWidgetState(course, termID);
}

class _GradeWidgetState extends State<GradeWidget> {
  Course course;
  String termID;

  _GradeWidgetState(course, termID){
    this.course = course;
    this.termID = termID;
  }
  @override
  Widget build(BuildContext context) {
    final List<Category> list = Provider.of<List<Category>>(context);
    if(list != null) {
      for (Category category in list) {
        //print(category);
        return StreamProvider<List<Assessment>>.value(
          value: AssessmentService(termID, course.id, category.id).assessments,
          child: SubGrade(course, termID, category.id, list),
        );
      }
    }
    return Text("...");
  }
}

class SubGrade extends StatefulWidget {
  String  termID, catID;
  Course course;
  List<Category> catList;

  SubGrade(course, termID, catID, list){
    this.course = course;
    this.termID = termID;
    this.catID = catID;
    this.catList = list;
  }

  @override
  _SubGradeState createState() => _SubGradeState(course, termID, catID, catList);
}

class _SubGradeState extends State<SubGrade> {
  String termID, catID;
  Course course;
  List<Category> catList;

  _SubGradeState(course, termID, catID, catList){
    this.course = course;
    this.termID = termID;
    this.catID = catID;
    this.catList = catList;

  }

  @override
  Widget build(BuildContext context) {
    final aList = Provider.of<List<Assessment>>(context);
      double results = 0.0;
      double sumOfWeights = 0.0;

      if (catList.isNotEmpty) {
        for (Category category in catList) {
          category.categoryItems = new List<Assessment>();

          sumOfWeights += category.categoryWeight;

          for (Assessment a in aList) {
            if (a.parentID == category.id) {
              category.categoryItems.add(a);
            }
          }
        }

        for (Category category in catList) {
          for (Assessment assessment in category.categoryItems) {
            category.totalEarnedPoints += assessment.yourPoints.toDouble();
            category.totalPoints += assessment.totalPoints.toDouble();
          }
          if (category.totalEarnedPoints > 0) {
            //print("inside");
            results += ((category.categoryWeight *
                (category.totalEarnedPoints.toDouble() /
                    category.totalPoints.toDouble())) / sumOfWeights) * 100;
            //controller.add(earnedWeight);

          }
        }
      }

      results = (results * 100).roundToDouble() / 100;


      course.gradePercent = results;
      print(course.gradePercent);

      CourseService(termID,).updateGradePercent(course.id, results);

      //todo: The grade is being updated in course object but I couldn't find a way to dispaly it in the GUI.
      course.updateGradeLetter(results);

      //I was testing if we can send to widgets from this class to so we can get the grade parcentage and grade letter.
      // ListView listView = ListView(
      //   children: [
      //     Text("W"),
      //     Text(results.toString()),
      //   ],
      // );


      return Text(results.toString());
  }
}
