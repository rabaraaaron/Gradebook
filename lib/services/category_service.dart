import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/utils/calculator.dart';
import 'course_service.dart';
import 'package:gradebook/model/Category.dart';

class CategoryService {
  String termID, courseID;
  CollectionReference categoryRef;
  List<Category> listOfCategories;

  CategoryService(String termID, String courseID) {
    this.courseID = courseID;
    this.termID = termID;
    this.categoryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses')
        .doc(courseID)
        .collection("categories");
  }

  Future<void> addCategory(
      name, weight, dropLowest, numberDropped, equalWeights, isManuallySet) async {
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
            'isManuallySet': isManuallySet,
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
          isManuallySet: doc.get('isManuallySet') ?? false,
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
    await Calculator().calcCourseGrade(termID, courseID);
  }

  Future<void> setDropLowest(catID, value) async {
    await categoryRef.doc(catID).update({'dropLowest': value});
    await Calculator().calcCourseGrade(termID, courseID);
  }

  Future<void> setEqualWeightsState(catID, value) async {
    await categoryRef.doc(catID).update({'equalWeights': value});
    await Calculator().calcCourseGrade(termID, courseID);
  }

  List<Category> getCategoryData() {
    this.categories;
    return listOfCategories;
  }

  Future<void> updateCategory(name, newWeight, oldWeight, dropLowest,
      numberDropped, equalWeights, catID, gradePercentAsDecimal) async {
    var result = double.parse(newWeight) - oldWeight;

    await categoryRef.doc(catID).update({
      'name': name,
      'weight': double.parse(newWeight),
      'dropLowest': dropLowest,
      'equalWeights': equalWeights,
      'numberDropped': dropLowest ? int.parse(numberDropped) : 0,
      'gradePercentAsDecimal' : gradePercentAsDecimal,
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


}
