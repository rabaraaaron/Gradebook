import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        .collection('terms').doc(termID)
        .collection('courses').doc(courseID)
        .collection("categories");
  }

  Future<void> addCategory(name, weight, dropLowest, equalWeights) async {
    bool duplicate;
    await categoryRef
        .where('name', isEqualTo: name)
        .where('weight', isEqualTo: double.parse(weight))
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;
    });
    print("DUPE: " + duplicate.toString());

    if (!duplicate)
      await categoryRef
          .add({
            'name': name,
            'weight': double.parse(weight),
            'dropLowest': dropLowest,
            'total': 0.0,
            'earned': 0.0,
            'gradePercentAsDecimal': 0.0,
            'equalWeights' : equalWeights,
            'countOfIncompleteItems' : 0,
          })
          .then((value) => print("Category Added"))
          .catchError((error) => print("Failed to add category: $error"));
  }

  Stream<List<Category>> get categories {
    return categoryRef.snapshots().map(_categoriesFromSnap);
  }

  List<Category> _categoriesFromSnap(QuerySnapshot snapshot) {
    try {
      var v = snapshot.docs.map<Category>((doc) {

        return Category(
            categoryName: doc.get('name') ?? "",
            categoryWeight: doc.get('weight').toString() ?? "0",
            id: doc.id,
            dropLowestScore: doc.get('dropLowest') ?? false,
            total: doc.get('total').toString() ?? "0",
            earned: doc.get('earned').toString() ?? "0",
            equalWeights: doc.get('equalWeights') ?? false,
            countOfIncompleteItems: doc.get('countOfIncompleteItems') ?? 0,
        );
      }).toList();
      listOfCategories = v;
      return v;

    } catch(err){
      print("Error: -->> " + err.toString() );
      var v = snapshot.docs.map<Category>((doc) {
        return Category(
            categoryName: doc.get('name') ?? "",
            categoryWeight: doc.get('weight') ?? '0',
            id: doc.id,
            dropLowestScore: false,
            total: doc.get('total') ?? "0",
            earned: doc.get('earned') ?? "0",
            equalWeights: doc.get('equalWeights') ?? false,
        );
      }).toList();
      listOfCategories = v;
      return v;
    }
  }

  Future<void> deleteCategory(id) async {
    await categoryRef.doc(id).delete();
    await CourseService(termID).calculateGrade(courseID);
  }

  Future<void> setDropLowest(catID, value) async {
    await categoryRef.doc(catID).update({'dropLowest': value});
    // await CourseService(termID).calculateGrade(courseID);
  }

  List<Category> getCategoryData() {
    this.categories;
    return listOfCategories;
  }

  Future<void> updateCategory(name, weight, dropLowest, equalWeights, catID) async {
      await categoryRef.doc(catID)
          .update({
        'name': name,
        'weight': double.parse(weight),
        'dropLowest': dropLowest,
        'equalWeights' : equalWeights,
      });
      // await calculateGrade(catID);
  }

  Future<void> calculateGrade(catID) async {

    AssessmentService aServ = AssessmentService(this.termID, this.courseID, catID);
    DocumentSnapshot categorySnap = await categoryRef.doc(catID).get();
    QuerySnapshot assessmentsSnap = await categoryRef.doc(catID).collection('assessments').get();
    SplayTreeMap map = new SplayTreeMap<String, double>();
    double gradePercentAsDecimal = 0,
        totalOfTotalPoints = 0,
        totalofEarnedPoints = 0,
        totalEarnedWeights = 0;
    int counter = 0;
    double categoryWeight = categorySnap.get('weight');
    bool dropLowest = categorySnap.get('dropLowest');


    //calculate Totals
    for (DocumentSnapshot assessment in assessmentsSnap.docs) {
      //reset all assessment so that none is dropped
      if(assessment.get('isDropped')){
        aServ.updateDropState(assessment.id, false);
      }

      double totalPoints = double.parse(assessment.get('totalPoints'));
      double yourPoints = double.parse(assessment.get('yourPoints'));
      bool isCompleted = assessment.get('isCompleted');

      totalOfTotalPoints += totalPoints;
      totalofEarnedPoints += yourPoints;

      if(isCompleted) {
        if (totalPoints > 0) {
          map.putIfAbsent(assessment.id, () => yourPoints / totalPoints);
          //this will be used only for equally wighted calc
          double earnedWeight = (yourPoints / totalPoints) *
              (categoryWeight / assessmentsSnap.size);
          totalEarnedWeights += earnedWeight;
        }
      }else{
        counter++;
      }
    }

    //findLowest
    if (dropLowest && map.length >1) {
      var sortedByValue = new SplayTreeMap.from(
          map, (key1, key2) => map[key1].compareTo(map[key2]));

      var id = sortedByValue.firstKey();

      DocumentReference docRef = categoryRef.doc(catID).collection('assessments').doc(id);
      DocumentSnapshot aSnap = await docRef.get();
      var lowestEP = double.parse(aSnap.get('yourPoints'));
      var lowestTP = double.parse(aSnap.get('totalPoints'));

      aServ.updateDropState(aSnap.id, true);
      totalofEarnedPoints -= lowestEP;
      totalOfTotalPoints -= lowestTP;

        //for equally weighted categroy,
      double lowestEW = (lowestEP / lowestTP) * (categoryWeight / assessmentsSnap.size);
        totalEarnedWeights -= lowestEW;
        //Add the full weight for that assessment to total earned weight
        totalEarnedWeights += categoryWeight / assessmentsSnap.size;

    }


    if(await categorySnap.get('equalWeights')){
      gradePercentAsDecimal = totalEarnedWeights;
    } else if( totalOfTotalPoints>0){
      gradePercentAsDecimal =
          categoryWeight * (totalofEarnedPoints / totalOfTotalPoints);
    }

    categoryRef.doc(catID).update(
        {
          'gradePercentAsDecimal': gradePercentAsDecimal,
          'total': totalOfTotalPoints,
          'earned': totalofEarnedPoints,
          'countOfIncompleteItems': counter,
        }
    );

    await CourseService(termID).calculateGrade(courseID);
  }

  // Future<void> calculateEqualWeightedGrade(catID) async {
  //
  //   AssessmentService aServ = AssessmentService(this.termID, this.courseID, catID);
  //   DocumentSnapshot categorySnap = await categoryRef.doc(catID).get();
  //   QuerySnapshot assessmentsSnap = await categoryRef.doc(catID).collection('assessments').get();
  //   SplayTreeMap map = new SplayTreeMap<String, double>();
  //
  //   double catWeight = categorySnap.get('weight');
  //   double  totalOfTotalPoints = 0,
  //           totalofEarnedPoints = 0;
  //
  //   bool dropLowest = categorySnap.get('dropLowest');
  //
  //   double totalEarnedWeights = 0;
  //
  //   for (DocumentSnapshot assessment in assessmentsSnap.docs) {
  //     //reset all assessment so that none is dropped
  //     aServ.updateDropState(assessment.id, false);
  //
  //     double totalPoints = double.parse(assessment.get('totalPoints') ?? 0.0);
  //     double yourPoints = double.parse(assessment.get('yourPoints') ?? 0.0);
  //     totalOfTotalPoints += totalPoints;
  //     totalofEarnedPoints += yourPoints;
  //
  //     if (totalPoints > 0) {
  //       double earnedWeight = (yourPoints / totalPoints) * (catWeight / assessmentsSnap.size);
  //       totalEarnedWeights += earnedWeight;
  //
  //
  //       map.putIfAbsent(assessment.id, () => yourPoints / totalPoints);
  //     }
  //   }
  //
  //   double gradePercentAsDecimal = (totalEarnedWeights);
  //
  //   categoryRef.doc(catID).update({
  //     'gradePercentAsDecimal': gradePercentAsDecimal,
  //     'total': totalOfTotalPoints,
  //     'earned': totalofEarnedPoints
  //   });
  //
  //
  //   await CourseService(termID).calculateGrade(courseID);
  // }
}

