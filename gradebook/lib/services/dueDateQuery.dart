import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/term_service.dart';

class DueDateQuery {
  Future<List<Assessment>> getAssesmentsDue([int days]) async {
    DateTime datesToDisplay;

    List<Assessment> upcomingAssessments;

    if (days != null)
      datesToDisplay = DateTime.now().add(Duration(days: days));
    else
      datesToDisplay = DateTime.now().add(const Duration(days: 7));


    CollectionReference termsCollection = TermService().termsCollection;
    QuerySnapshot terms = await termsCollection.get();

    for (DocumentSnapshot term in terms.docs){
      CollectionReference courseCollection =  termsCollection.doc(term.id).collection('courses');
      QuerySnapshot courses = await courseCollection.get();

      for(DocumentSnapshot course in courses.docs){
        CollectionReference categoryCollection =  courseCollection.doc(course.id).collection('categories');
        QuerySnapshot categories = await categoryCollection.get();

        for(DocumentSnapshot category in categories.docs){
          CollectionReference assessmentCollection = categoryCollection.doc(category.id).collection('assessments');
          QuerySnapshot assessments = await assessmentCollection.get();

          for(DocumentSnapshot assessment in assessments.docs){

          }
        }
      }
    }


  }
}
