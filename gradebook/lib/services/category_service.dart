import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';
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
          })
          .then((value) => print("Category Added"))
          .catchError((error) => print("Failed to add category: $error"));
  }

  Stream<List<Category>> get categories {
    return categoryRef.snapshots().map(_categoriesFromSnap);
  }

  List<Category> _categoriesFromSnap(QuerySnapshot snapshot) {

    // var v = snapshot.docs.map<Category>((doc) {
    //   if(doc.get('weight') is String){
    //     print("weight is double");
    //   }
    //
    // });
    // print(v);

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
    categoryRef.doc(id).delete();
  }

  Future<void> setDropLowest(catID, value) async {
    await categoryRef.doc(catID).update({'dropLowest': value});
  }

  List<Category> getCategoryData() {
    this.categories;
    return listOfCategories;
  }

  Future<void> updateCategory(name, weight, dropLowest, catID) async {
      await categoryRef.doc(catID)
          .update({
        'name': name,
        'weight': double.parse(weight),
        'dropLowest': dropLowest,
      });

  }


  //   return categoryRef.categories((data) {
  //     print(data);
  //     for(Category cat in data){
  //       print(cat);
  //     }
  //   },
  //     onError: (err){
  //       print('Error!!: ' + err.toString());
  //     },
  //     cancelOnError: false,);
  // }

  // Future<void> newAssessment(Assessment a, id) async{
  //   DocumentSnapshot doc = await categoryRef.doc(id).get();
  //   double totalpoints = double.parse(doc.get('totalPoints'));
  //   double totalEarnedPoints = double.parse(doc.get('totalEarnedPoints'));
  //   await categoryRef.doc(id).update({
  //     'totalPoints':totalpoints + a.totalPoints,
  //     'totalEarnedPoints' : totalEarnedPoints + a.yourPoints});
  //
  // }

  //todo: still need to implement "allAssessmentEqualWithinCategory"
  Future<void> calculateGrade(catID) async {

    AssessmentService aServ = AssessmentService(this.termID, courseID, catID);
    DocumentSnapshot categorySnap = await categoryRef.doc(catID).get();
    QuerySnapshot assessmentsSnap = await categoryRef.doc(catID).collection('assessments').get();
    SplayTreeMap map = new SplayTreeMap<String, double>();
    double gradePercentAsDecimal,
        totalOfTotalPoints = 0,
        totalofEarnedPoints = 0;
    double weight = categorySnap.get('weight');
    bool dropLowest = categorySnap.get('dropLowest');

    if(await categorySnap.get('equalWeights')){
      calculateEqualWeightedGrade(catID);
      return;
    }

    //calculate Totals
    for (DocumentSnapshot assessment in assessmentsSnap.docs) {
      //reset all assessment so that none is dropped
      aServ.updateDropState(assessment.id, false);

      double totalPoints = double.parse(assessment.get('totalPoints') ?? 0.0);
      double yourPoints = double.parse(assessment.get('yourPoints') ?? 0.0);
        totalOfTotalPoints += totalPoints;
        totalofEarnedPoints += yourPoints;
        if (yourPoints > 0) {
          map.putIfAbsent(assessment.id, () => yourPoints / totalPoints);
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

     // print("----->> " + test);
    }

    gradePercentAsDecimal = weight * (totalofEarnedPoints / totalOfTotalPoints);

    categoryRef.doc(catID).update({
      'gradePercentAsDecimal': gradePercentAsDecimal,
      'total': totalOfTotalPoints,
      'earned': totalofEarnedPoints
    });
  }

  Future<void> calculateEqualWeightedGrade(catID) async {

    AssessmentService aServ = AssessmentService(this.termID, courseID, catID);
    DocumentSnapshot categorySnap = await categoryRef.doc(catID).get();
    QuerySnapshot assessmentsSnap = await categoryRef.doc(catID).collection('assessments').get();
    SplayTreeMap map = new SplayTreeMap<String, double>();

    double weight = categorySnap.get('weight');
    bool dropLowest = categorySnap.get('dropLowest');

    double totalEarnedWeights = 0;

    for (DocumentSnapshot assessment in assessmentsSnap.docs) {
      //reset all assessment so that none is dropped
      aServ.updateDropState(assessment.id, false);

      double totalPoints = double.parse(assessment.get('totalPoints') ?? 0.0);
      double yourPoints = double.parse(assessment.get('yourPoints') ?? 0.0);

      if (totalPoints > 0) {
        double earnedWeight = (yourPoints / totalPoints) * (weight / assessmentsSnap.size);
        totalEarnedWeights += earnedWeight;

        map.putIfAbsent(assessment.id, () => yourPoints / totalPoints);
      }
    }
  }
}

