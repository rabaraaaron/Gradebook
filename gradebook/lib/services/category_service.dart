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

  Future<void> addCategory(name, weight) async {
    bool duplicate;
    await categoryRef
        .where('name', isEqualTo: name)
        .where('weight', isEqualTo: weight)
        .get()
        .then((value) {
      duplicate = value.docs.isNotEmpty;
    });
    print("DUPE: " + duplicate.toString());

    if (!duplicate)
      await categoryRef
          .add({
            'name': name,
            'weight': weight,
          })
          .then((value) => print("Category Added"))
          .catchError((error) => print("Failed to add category: $error"));
  }

  Stream<List<Category>> get categories {
    return categoryRef.snapshots().map(_categoriesFromSnap);
  }

  List<Category> _categoriesFromSnap(QuerySnapshot snapshot) {
    var v = snapshot.docs.map<Category>((doc) {
      return Category(
          categoryName: doc.get('name') ?? "",
          categoryWeight: doc.get('weight') ?? 0,
          id: doc.id);
    }).toList();
    listOfCategories = v;
    return v;
  }

  Future<void> deleteCategory(id) async {
    categoryRef.doc(id).delete();
  }

  List<Category> getCategoryData(){
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

}
