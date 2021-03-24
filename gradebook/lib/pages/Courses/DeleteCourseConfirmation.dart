// ignore: must_be_immutable
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/services/course_service.dart';

class DeleteCourseConfirmation extends StatelessWidget {
  String termID;
  List<Course> termCourses;
  int index;

  DeleteCourseConfirmation(String id, List<Course> courses, int i) {
    termID = id;
    termCourses = courses;
    index = i;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          "Delete Course",
          style: Theme.of(context).textTheme.headline4,
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        Text(
          "Are you sure you want to delete the ${termCourses[index].name} class?",
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(height: 20),
        FlatButton(
          color: Colors.red,
          height: 40,
          onPressed: () {
            CourseService(termID).deleteCourse(termCourses[index].id);
            Navigator.pop(context);
          },
          child: Text(
            "Delete",
            textScaleFactor: 1.25,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ]),
    );
  }
}
