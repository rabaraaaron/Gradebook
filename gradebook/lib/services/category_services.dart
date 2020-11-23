import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
import 'package:provider/provider.dart';
import 'user_service.dart';
import 'package:gradebook/model/Category.dart';

class CategoryService {

  CollectionReference categoryRef;

  CategoryService(String termID, String courseID){
    categoryRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('terms')
        .doc(termID)
        .collection('courses')
        .doc(courseID)
        .collection("category");
  }


  Future<void> addCategory(name, weight) async {
    bool duplicate;
    await categoryRef
        .where('name', isEqualTo: name)
        .where('weight', isEqualTo: weight)
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;});
    print("DUPE: " + duplicate.toString());

    if(!duplicate)
      await categoryRef
          .add({
        'name': name,
        'weight': weight,
      })
          .then((value) => print("Category Added"))
          .catchError((error) => print("Failed to add category: $error"));
  }

  Stream<List<Category>> get categories {
    return categoryRef
        .snapshots()
        .map(_categoriesFromSnap);
  }

  List<Category> _categoriesFromSnap(QuerySnapshot snapshot) {
    var v = snapshot.docs.map<Category>((doc) {
      return Category(
        categoryName: doc.get('name') ?? "",
          categoryWeight: doc.get('weight') ?? 0);
    }).toList()
    ;
    return v;
  }

  Future<void> deleteCourse(name) async {
    print(categoryRef
        .where('name', isEqualTo: name)
        .get()
        .then((value) {
      String id = value.docs.first.id;
      categoryRef.doc(id).delete();
    }));
  }
}
