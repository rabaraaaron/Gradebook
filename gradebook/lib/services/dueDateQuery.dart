import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/term_service.dart';

class DueDateQuery {
  Future<List<Assessment>> getAssesmentsDue([int days]) async {
    DateTime futureDateCutOff;

    List<Assessment> upcomingAssessments = List.empty(growable: true);

    if (days != null)
      futureDateCutOff = DateTime.now().add(Duration(days: days));
    else
      futureDateCutOff = DateTime.now().add(const Duration(days: 7));

    CollectionReference termsCollection = TermService().termsCollection;
    QuerySnapshot terms = await termsCollection.get();

    for (DocumentSnapshot term in terms.docs) {
      CollectionReference courseCollection =
          termsCollection.doc(term.id).collection('courses');
      QuerySnapshot courses = await courseCollection.get();

      for (DocumentSnapshot course in courses.docs) {
        CollectionReference categoryCollection =
            courseCollection.doc(course.id).collection('categories');
        QuerySnapshot categories = await categoryCollection.get();

        for (DocumentSnapshot category in categories.docs) {
          CollectionReference assessmentCollection =
              categoryCollection.doc(category.id).collection('assessments');
          QuerySnapshot assessments = await assessmentCollection.get();

          for (DocumentSnapshot assessment in assessments.docs) {
            DateTime dueDate;
            if(assessment.get('dueDate') != null)
              dueDate = assessment.get('dueDate').toDate();

            if (dueDate.compareTo(futureDateCutOff) <= 0 &&
                dueDate.compareTo(DateTime.now().subtract(Duration(days: 1))) >= 0 &&
                assessment.get('isCompleted') == false) {
              Assessment a = new Assessment(
                  name: assessment.get('name'),
                  totalPoints: double.parse(assessment.get('totalPoints')),
                  yourPoints: double.parse(assessment.get('yourPoints')),
                  isDropped: assessment.get('isDropped'),
                  isCompleted: assessment.get('isCompleted'),
                  createDate: assessment.get('createDate'),
                  id: assessment.id,
                  catID: category.id,
                  courseID: course.id,
                  termID: term.id,
                  dueDate: dueDate);

              if (a != null)
               upcomingAssessments.add(a);
            }
          }
        }
      }
    }

    upcomingAssessments.sort((a,b)=> a.dueDate.compareTo(b.dueDate));

    return upcomingAssessments;
  }
}
