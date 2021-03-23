import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';
import 'package:gradebook/model/Category.dart';

class CategoryService {
  CollectionReference categoryRef;
  List<Category> listOfCategories;

  CategoryService(String termID, String courseID) {
    categoryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses')
        .doc(courseID)
        .collection("categories");
  }

  Future<void> addCategory(name, weight, dropLowest) async {
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
            'gradePercentAsDecimal': 0.0
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
            earned: doc.get('earned').toString() ?? "0"
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
            earned: doc.get('earned') ?? "0"
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

  ///todo: still need to implement "allAssessmentEqualWithinCategory"
  // Future<void> calculateGrade(catID) async {
  //   DocumentSnapshot category = await categoryRef.doc(catID).get();
  //   QuerySnapshot assessments =
  //       await categoryRef.doc(catID).collection('assessments').get();
  //
  //   double gradePercentAsDecimal,
  //       totalOfTotalPoints = 0,
  //       totalofEarnedPoints = 0;
  //   double weight = double.parse(category.get('weight'));
  //   bool dropLowest = category.get('dropLowest');
  //
  //   //calculate Totals
  //   for (DocumentSnapshot assessment in assessments.docs) {
  //     double totalPoints = double.parse(assessment.get('totalPoints') ?? 0.0);
  //     double yourPoints = double.parse(assessment.get('yourPoints') ?? 0.0);
  //     totalOfTotalPoints += totalPoints;
  //     totalofEarnedPoints += yourPoints;
  //   }
  //
  //   ///todo: Check with Mohd on how to find lowest
  //
  //   //findLowest
  //   if (dropLowest) {}
  //
  //   gradePercentAsDecimal = weight * (totalofEarnedPoints / totalOfTotalPoints);
  //
  //   categoryRef.doc(catID).update({
  //     'gradePercentAsDecimal': gradePercentAsDecimal,
  //     'total': totalOfTotalPoints,
  //     'earned': totalofEarnedPoints
  //   });
  // }
}
