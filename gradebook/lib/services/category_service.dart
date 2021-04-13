import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'assessment_service.dart';
import 'course_service.dart';
import 'package:gradebook/model/Category.dart';

class CategoryService {
  String termID, courseID;
  CollectionReference categoryRef;
  List<Category> listOfCategories;

  CategoryService(String termID, String courseID) {
    this.courseID = courseID;
    this.termID = termID;
    categoryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses')
        .doc(courseID)
        .collection("categories");
  }

  Future<void> addCategory(
      name, weight, dropLowest, numberDropped, equalWeights) async {
    if (numberDropped == "") {
      numberDropped = "0";
    }
    bool duplicate;
    await categoryRef
        .where('name', isEqualTo: name)
        .where('weight', isEqualTo: double.parse(weight))
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;
    });
    print("DUPE: " + duplicate.toString());

    if (!duplicate) {
      await categoryRef
          .add({
            'name': name,
            'weight': double.parse(weight),
            'dropLowest': dropLowest,
            'numberDropped': int.parse(numberDropped) ?? 1,
            'total': 0.0,
            'earned': 0.0,
            'gradePercentAsDecimal': 0.0,
            'equalWeights': equalWeights,
            'countOfIncompleteItems': 0,
          })
          .then((value) => print("Category Added"))
          .catchError((error) {
            //displayMessage(context, "Failed to add category :" + error.toString(), "Error");
            print("Failed to add category: $error");
          });
      await CourseService(termID)
          .decreaseRemainingWeight(courseID, double.parse(weight));
    }
  }

  Stream<List<Category>> get categories {
    return categoryRef.snapshots().map(_categoriesFromSnap);
  }

  List<Category> _categoriesFromSnap(QuerySnapshot snapshot) {
    try {
      var v = snapshot.docs.map<Category>((doc) {
        return Category(
          categoryName: doc.get('name') ?? "",
          categoryWeight: doc.get('weight') ?? 0.0,
          id: doc.id,
          dropLowestScore: doc.get('dropLowest') ?? false,
          numberDropped: doc.get('numberDropped'),
          total: doc.get('total').toString() ?? "0",
          earned: doc.get('earned').toString() ?? "0",
          equalWeights: doc.get('equalWeights') ?? false,
          countOfIncompleteItems: doc.get('countOfIncompleteItems') ?? 0,
          gradePercentAsDecimal: doc.get('gradePercentAsDecimal') ?? 0,
        );
      }).toList();
      listOfCategories = v;
      return v;
    } catch (err) {
      print("Error: -->> " + err.toString());
      var v = snapshot.docs.map<Category>((doc) {
        return Category(
          categoryName: doc.get('name') ?? "",
          categoryWeight: doc.get('weight') ?? 0.0,
          id: doc.id,
          dropLowestScore: false,
          numberDropped: doc.get('numberDropped'),
          total: doc.get('total') ?? "0",
          earned: doc.get('earned') ?? "0",
          equalWeights: doc.get('equalWeights') ?? false,
        );
      }).toList();
      listOfCategories = v;
      return v;
    }
  }

  Future<void> deleteCategory(id, weight) async {
    // int test = weight * -1;
    await categoryRef.doc(id).delete();
    await CourseService(termID).increaseRemainingWeight(courseID, weight);
    await CourseService(termID).calculateGrade(courseID);
  }

  Future<void> setDropLowest(catID, value) async {
    await categoryRef.doc(catID).update({'dropLowest': value});
    await CourseService(termID).calculateGrade(courseID);
  }

  Future<void> setEqualWeightsState(catID, value) async {
    await categoryRef.doc(catID).update({'equalWeights': value});
    await CourseService(termID).calculateGrade(courseID);
  }

  List<Category> getCategoryData() {
    this.categories;
    return listOfCategories;
  }

  Future<void> updateCategory(name, newWeight, oldWeight, dropLowest,
      numberDropped, equalWeights, catID) async {
    var result = double.parse(newWeight) - oldWeight;

    await categoryRef.doc(catID).update({
      'name': name,
      'weight': double.parse(newWeight),
      'dropLowest': dropLowest,
      'equalWeights': equalWeights,
      'numberDropped': dropLowest ? int.parse(numberDropped) : 0,
    });

    if (result < 0) {
      await CourseService(termID)
          .increaseRemainingWeight(courseID, (result).abs());
    } else if (result > 0) {
      await CourseService(termID)
          .decreaseRemainingWeight(courseID, (result).abs());
    }

    // await calculateGrade(catID);
  }

  Future<void> calculateGrade(catID) async {
    AssessmentService aServ =
        AssessmentService(this.termID, this.courseID, catID);
    DocumentSnapshot categorySnap = await categoryRef.doc(catID).get();
    QuerySnapshot assessmentsSnap =
        await categoryRef.doc(catID).collection('assessments').get();
    Map map = new SplayTreeMap<String, double>();
    double gradePercentAsDecimal = 0,
        categoryTotalPoints = 0,
        categoryEarnedPoints = 0;
    int numIncomplete = 0;
    double categoryWeight = categorySnap.get('weight');
    bool dropLowest = categorySnap.get('dropLowest');
    bool equalWeight = categorySnap.get('equalWeights');
    List<DocumentSnapshot> assessments=[];

    print("EQUAL WEIGHT: " + equalWeight.toString());

    //calculate Totals
    if (!equalWeight) {
      for (DocumentSnapshot assessment in assessmentsSnap.docs) {
        //reset all assessment so that none is dropped
        if (assessment.get('isDropped')) {
          aServ.updateDropState(assessment.id, false);
        }

        double totalPoints = double.parse(assessment.get('totalPoints'));
        double yourPoints = double.parse(assessment.get('yourPoints'));
        bool isCompleted = assessment.get('isCompleted');

        categoryTotalPoints += totalPoints;
        categoryEarnedPoints += yourPoints;

        if (isCompleted) {
          if (totalPoints > 0) {
            assessments.add(assessment);
            map.putIfAbsent(assessment.id, () => yourPoints / totalPoints);
            //this will be used only for equally wighted calc
          }
        } else {
          numIncomplete++;
        }
      }

      //findLowest
      if (dropLowest && map.length > 1) {
        assessments.sort((a,b){
          double aScore = double.parse(a.get('yourPoints'))/double.parse(a.get('totalPoints'));
          double bScore = double.parse(b.get('yourPoints'))/double.parse(b.get('totalPoints'));
          if(aScore<bScore)
            return -1;
          else if(aScore>bScore)
            return 1;
          else
            return 0;
        });

        // print(map.toString());
        // var sortedByValue = new SplayTreeMap.from(
        //     map, (key1, key2) => map[key1].compareTo(map[key2]));
        // print(sortedByValue.toString());


        for (int i = 0; i < categorySnap.get('numberDropped'); i++) {
          if (assessments.length > 1) {
            var droppedAssessmentID = assessments[0].id;
            // sortedByValue.remove(droppedAssessmentID);

            assessments.remove(assessments[0]);

            DocumentReference docRef = categoryRef
                .doc(catID)
                .collection('assessments')
                .doc(droppedAssessmentID);
            DocumentSnapshot aSnap = await docRef.get();
            var lowestEP = double.parse(aSnap.get('yourPoints'));
            var lowestTP = double.parse(aSnap.get('totalPoints'));

            aServ.updateDropState(aSnap.id, true);
            categoryEarnedPoints -= lowestEP;
            categoryTotalPoints -= lowestTP;
          }
        }
      }

      if (categoryTotalPoints > 0) {
        gradePercentAsDecimal =
            categoryWeight * (categoryEarnedPoints / categoryTotalPoints);
      }
    }

    if (equalWeight) {
      double sumPercents = 0;
      Map<String, double> gradePercents = {};
      int numCompleted = 0;
      for (DocumentSnapshot assessment in assessmentsSnap.docs) {
        if (assessment.get('isDropped')) {
          aServ.updateDropState(assessment.id, false);
        }

        double totalPoints = double.parse(assessment.get('totalPoints'));
        double yourPoints = double.parse(assessment.get('yourPoints'));
        bool isCompleted = assessment.get('isCompleted');

        if (isCompleted) {
          assessments.add(assessment);
          print("Complete Check:" + isCompleted.toString());
          numCompleted++;
          double percent = yourPoints / totalPoints;
          gradePercents[assessment.id] = percent;
          sumPercents += yourPoints / totalPoints;
          print("Running sumPercent:" + sumPercents.toString());
          print("Running completed:" + numCompleted.toString());
        }
        else
          numIncomplete++;
      }
      print("Final sumPercent:" + sumPercents.toString());

      if (dropLowest && gradePercents.length > 1) {

        assessments.sort((a,b){
          double aScore = double.parse(a.get('yourPoints'))/double.parse(a.get('totalPoints'));
          double bScore = double.parse(b.get('yourPoints'))/double.parse(b.get('totalPoints'));
          if(aScore<bScore)
            return -1;
          else if(aScore>bScore)
            return 1;
          else
            return 0;
        });

        var sortedByValue = new SplayTreeMap.from(gradePercents,
            (key1, key2) => gradePercents[key1].compareTo(gradePercents[key2]));

        for (int i = 0; i < categorySnap.get('numberDropped'); i++) {
          if (assessments.length > 1) {
            var droppedAssessmentID = assessments[0].id;
            // var droppedAssessmentID = sortedByValue.firstKey();
            // sortedByValue.remove(droppedAssessmentID);
            assessments.remove(assessments[0]);

            DocumentReference docRef = categoryRef
                .doc(catID)
                .collection('assessments')
                .doc(droppedAssessmentID);
            DocumentSnapshot aSnap = await docRef.get();
            var lowestEP = double.parse(aSnap.get('yourPoints'));
            var lowestTP = double.parse(aSnap.get('totalPoints'));

            aServ.updateDropState(aSnap.id, true);
            sumPercents -= lowestEP / lowestTP;
            numCompleted--;
          }
        }
      }

      if (numCompleted == 0) {
        gradePercentAsDecimal = 0;
      } else
        gradePercentAsDecimal = (sumPercents / numCompleted) * categoryWeight;
    }
    print("Final sumPercent:" + gradePercentAsDecimal.toString());
    await categoryRef.doc(catID).update({
      'gradePercentAsDecimal': gradePercentAsDecimal,
      'total': categoryTotalPoints,
      'earned': categoryEarnedPoints,
      'countOfIncompleteItems': numIncomplete,
    });

    await CourseService(termID).calculateGrade(courseID);
  }

  Future<void> recalculateGrades() async {
    var categories = await categoryRef.get();
    for(DocumentSnapshot cat in categories.docs){
      await calculateGrade(cat.id);
    }

  }

}
