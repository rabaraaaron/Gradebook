import 'dart:async';
import 'dart:collection';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';


class Testing3 {
  double _sumOfWeights = 4;
  List<Assessment> assessmentList;
  List<Category> categoryList;
  double categoryTP =0;
  double get sumOfWeights => _sumOfWeights;

  set updateSumOfWeights(double sumOfWeights) {
    _sumOfWeights += sumOfWeights;

    //todo:check if sumOfWeights > 100 and display error message if true
  }

  Stream<String> getGrade (Course course, Term term) {
    print("======1");
    double catTP = 0;
    String string = "test";

    HashMap<String, String> map = new HashMap();

    //map.update("test", () => new S);

    StreamController<String> controller = StreamController<String>();

    Stream<String> stream = controller.stream;

    controller.add(categoryTP.toString());

    CategoryService categoryService = CategoryService(term.termID, course.id);
    final myStream = categoryService.categories;

    myStream.listen( (data) async {
      print("======2");

      if (data.isNotEmpty){
        //print("====== not empty : " + data.toString());

        for (Category category in data) {

          final assessmentServ = await Future.value(AssessmentService(
              term.termID, course.id, category.id));
          print("======3");
          final assessmentStream = await Future.value(assessmentServ.assessments);
          assessmentStream.listen((assessmentsData) async{
            Assessment assessment;
            assessmentList = assessmentsData;
            if (data.isNotEmpty) {
              for ( assessment in assessmentsData) {
                category.totalPoints +=  await Future.value(assessment.totalPoints);
                category.totalEarnedPoints += await Future.value(assessment.yourPoints);
                catTP += await Future.value(assessment.totalPoints);
                controller.add(catTP.toString());

              }
            }
          });
        }

      }
    });

    print("catTP ----->> " + categoryTP.toString());

    return stream;

  }

}