import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';


class GradeCalc {
  double _sumOfWeights = 0;
  List<Assessment> assessmentList;
  List<Category> categoryList = List<Category>();
  double categoryTP =0;
  double get sumOfWeights => _sumOfWeights;
  final Map map = HashMap<String, double>();
  double earnedWeight = 0.0;
  double weight = 0.0;

  set updateSumOfWeights(double sumOfWeights) {
    _sumOfWeights += sumOfWeights;

    //todo:check if sumOfWeights > 100 and display error message if true
  }

  Stream<Map> getGrade (Course course, Term term)  {
    print("======1");

    var controller = StreamController<Map>();

    Stream<Map> stream = controller.stream.asBroadcastStream();
    map.putIfAbsent("percentage", () => 0.0);
    map.putIfAbsent("sumOfPoints", () => 0.0);
    map.putIfAbsent("EarnedPointSum", () => 0.0);
    controller.add(map);

    CategoryService categoryService = CategoryService(term.termID, course.id);
    final myStream = categoryService.categories;

    test3(myStream, term, course);
    sleep(new Duration(milliseconds: 200));


    return stream;

  }

  void test3(Stream myStream, Term term, Course course){
    //print("======2");
    myStream.listen((event) async {
      await Future.value(event).then((value) {
        categoryList = value;

        for(var category in categoryList){
          //print("======3");
         // print(category);
          final assessmentStream = AssessmentService( term.termID, course.id, category.id).assessments;

          assessmentStream.listen((list) async {
            await Future.value(list).then((value) {
              assessmentList = value;
              for (var assessment in assessmentList) {
                //print("======4");
                //print(assessment.toString());
                category.totalEarnedPoints += assessment.yourPoints.toDouble();
                category.totalPoints += assessment.totalPoints.toDouble();
                //print("catTP: " + category.totalPoints.toString() + " catEP: " + category.totalEarnedPoints.toString());
              }
            }).then((value) {
              //print("======5");
              if(category.totalEarnedPoints > 0) {
                //print("inside");
                earnedWeight += double.parse(category.categoryWeight) * (category.totalEarnedPoints.toDouble()/category.totalPoints.toDouble());
                //print(earnedWeight);
                map["percentage"] = earnedWeight;
              }

            });

          });
          //map["sumOfPoints"] += assessment.totalPoints.toDouble();
          //map["EarnedPointSum"] += assessment.yourPoints.toDouble();
        }
      });
      //print(categoryList.toString());
    });

  }

  void test4(Stream myStream, Term term, Course course){
    myStream.listen((event) {
      categoryList = event;
      for(var category in categoryList){
        final assessmentStream = AssessmentService( term.termID, course.id, category.id).assessments;

        assessmentStream.listen((list) async {
          assessmentList = list;
          for (var assessment in list) {
            category.totalEarnedPoints += assessment.yourPoints.toDouble();
            category.totalPoints += assessment.totalPoints.toDouble();
          }
        });

        if(category.totalEarnedPoints > 0) {
          earnedWeight += double.parse(category.categoryWeight) * (category.totalEarnedPoints.toDouble()/category.totalPoints.toDouble());
        }

        //map["sumOfPoints"] += assessment.totalPoints.toDouble();
        //map["EarnedPointSum"] += assessment.yourPoints.toDouble();

      }
      map["percentage"] = earnedWeight * 100;
      var tt = earnedWeight * 100;
      print("----------- ew " + tt.toString());

    });


  }

  Future test( Stream<List<Category>> myStream, Term term, Course course) async {

    await for (var categoryList in myStream) {
      //print("======  : " + categoryList.toString());
       for (var category in categoryList) {
        weight = double.parse(await Future.value(category.categoryWeight));
        //print("------------------>>>>" + weight.toString());

        final assessmentServ = await Future.value(AssessmentService( term.termID, course.id, category.id));
        //print("======3 - cat");
        final assessmentStream = await Future.value(assessmentServ.assessments);

         //for (var assessmentList in assessmentStream) {
          //print("======4");
        await assessmentStream.listen((list) async* {
          for (var assessment in list) {
            //print("======5");
            map["sumOfPoints"] += await Future.value(assessment.totalPoints.toDouble());
            //print("======6");
            map["EarnedPointSum"] += await Future.value(assessment.yourPoints.toDouble());
            //category.totalEarnedPoints += assessment.yourPoints.toDouble();
            //category.totalPoints += assessment.totalPoints.toDouble();
            //print("======7");
            //print("-----------" + earnedWeight.toString());
          }
        });
          //print("======8");
          //print("-----------" + earnedWeight.toString());

        //}
        //print("======9 --");

        //print("-----------" + earnedWeight.toString());
        //var test = map["EarnedPointSum"] / map["sumOfPoints"];

        var num1 = 9.3, mu3 = 23.2;
        var num2 = num1/mu3;
        if(category.totalEarnedPoints > 0) {
          earnedWeight += double.parse(category.categoryWeight) * (map["EarnedPointSum"] / map["sumOfPoints"]);
        }
        //print("------------------>>>> test lllll" + test.toString());
        //print("------------------>>>> num " + num2.toString());

        //print("------------------>>>> " + map["EarnedPointSum"].toString());
       // print("----------- ew " + earnedWeight.toString());
      }
      map["percentage"] = earnedWeight * 100;
       var tt = earnedWeight * 100;
       //print("----------- ew " + earnedWeight.toString());
       print("----------- ew " + tt.toString());
      // await assessmentStream.listen((assessmentsData) async{
      //    Assessment assessment;
      //    assessmentList = assessmentsData;
      //    if (data.isNotEmpty) {
      //      for ( assessment in assessmentsData) {
      //
      //        map["sumOfPoints"] +=  await Future.value(assessment.totalPoints);
      //        map["EarnedPointSum"] += await Future.value(assessment.yourPoints);
      //        //map["percentage"] = map["EarnedPointSum"]/map["sumOfPoints"];
      //        // category.totalPoints +=  await Future.value(assessment.totalPoints);
      //        // category.totalEarnedPoints += await Future.value(assessment.yourPoints);
      //        //catTP += await Future.value(assessment.totalPoints);
      //        //assessmentList.add(assessment);
      //        //controller.add(catTP.toString());
      //        //controller.sink.close();
      //      }
      //      earnedWeight += await Future.value(weight * (map["EarnedPointSum"]/map["sumOfPoints"]));
      //
      //    }
      //  });

      //categoryList.add(category);
    }
    return null;
  }
  Stream<List<Category>> test2(Stream<List<Category>> categoryList) async* {

    List<Category> list;

    int size = await Future.value(categoryList.length);

    for (int i = 1; i <= size ; i++) {
      //yield i;
     // await Future.delayed(const Duration(seconds: 1));
    }
  }


}