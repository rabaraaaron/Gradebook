import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/services/term_service.dart';

class Calculator {


  Future<void> calcCategoryGrade(termID, courseID, catID) async {
    CollectionReference categoryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses')
        .doc(courseID)
        .collection("categories");
    AssessmentService aServ =
    AssessmentService(termID, courseID, catID);
    DocumentSnapshot categorySnap = await categoryRef.doc(catID).get();
    QuerySnapshot assessmentsSnap =
    await categoryRef.doc(catID).collection('assessments').get();

    double gradePercentAsDecimal = 0,
        categoryTotalPoints = 0,
        categoryEarnedPoints = 0;
    int numIncomplete = 0;
    double categoryWeight = categorySnap.get('weight');
    bool dropLowest = categorySnap.get('dropLowest');
    bool equalWeight = categorySnap.get('equalWeights');
    List<DocumentSnapshot> assessments = [];

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
          }
        } else {
          numIncomplete++;
        }
      }

      //findLowest
      if (dropLowest && assessments.length > 1) {
        assessments.sort((a, b) {
          double aScore = double.parse(a.get('yourPoints')) /
              double.parse(a.get('totalPoints'));
          double bScore = double.parse(b.get('yourPoints')) /
              double.parse(b.get('totalPoints'));
          if (aScore < bScore)
            return -1;
          else if (aScore > bScore)
            return 1;
          else
            return 0;
        });


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
      else
        gradePercentAsDecimal = 0;
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
        assessments.sort((a, b) {
          double aScore = double.parse(a.get('yourPoints')) /
              double.parse(a.get('totalPoints'));
          double bScore = double.parse(b.get('yourPoints')) /
              double.parse(b.get('totalPoints'));
          if (aScore < bScore)
            return -1;
          else if (aScore > bScore)
            return 1;
          else
            return 0;
        });


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

    await calcCourseGrade(termID, courseID);
  }

  Future<void> recalculateGrades(termID, courseID) async {
    CollectionReference categoryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses')
        .doc(courseID)
        .collection("categories");
    var categories = await categoryRef.get();
    for (DocumentSnapshot cat in categories.docs) {
      await calcCategoryGrade(termID, courseID, cat.id);
    }
  }

  Future<void> calcCourseGrade(termID, courseID) async {
    CollectionReference courseRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses');
    DocumentSnapshot courseSnap = await courseRef.doc(courseID).get();
    if(!courseSnap.get('manuallySetGrade')) {
      QuerySnapshot categories = await courseRef.doc(courseID).collection(
          'categories').get();
      double courseGradeDecimal = 0.0;
      int counter = 0;
      double allocatedWeight = 0.0;

      for (DocumentSnapshot category in categories.docs) {
        courseGradeDecimal += category.get('gradePercentAsDecimal');
        counter += category.get('countOfIncompleteItems');
        allocatedWeight += category.get('weight');
      }
      double gradePercent = 0.0;
      if (allocatedWeight < 100) {
        gradePercent = courseGradeDecimal / allocatedWeight * 100;
      } else {
        gradePercent = courseGradeDecimal;
      }
      if (allocatedWeight == 0) {
        gradePercent = 100;
      }

      String letterGrade = getLetterGrade(gradePercent);

      print(courseGradeDecimal);
      await courseRef.doc(courseID).update({
        'gradePercent': gradePercent,
        'letterGrade': letterGrade,
        'countOfIncompleteItems': counter,
      });
    }
    await TermService().calculateGPA(courseRef.parent.id);

  }

  String getLetterGrade(gradePercent){
    var gPercent = gradePercent;
    if(gPercent >= 93){ return"A"; }
    if(gPercent >=90){ return"A-"; }
    if(gPercent >= 87){ return"B+"; }
    if(gPercent >= 83){ return"B"; }
    if(gPercent >= 80){ return"B-"; }
    if(gPercent >= 77){ return"C+"; }
    if(gPercent >= 73){ return"C"; }
    if(gPercent >= 70){ return"C-"; }
    if(gPercent >= 67){ return"D+"; }
    if(gPercent >= 63){ return"D"; }
    if(gPercent >= 60){ return"D-"; } else {return "F";}
  }
}