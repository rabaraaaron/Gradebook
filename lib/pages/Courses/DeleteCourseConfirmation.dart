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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          decoration: BoxDecoration(

            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0)),
          ),
          child: Center(child: Text("Delete Course", style: Theme.of(context).textTheme.bodyText1,),),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text(
                "Are you sure you want to delete the ${termCourses[index].name} class?",
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 20),

          Container(
            width: 200,
            child: TextButton(

              style: ButtonStyle(

                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                alignment: Alignment.centerLeft,
                backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.red,
                ),
              ),
              onPressed: () {
                CourseService(termID).deleteCourse(termCourses[index].id);
                Navigator.pop(context);
              },
              child: Center(
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
            ),
          )
            ],
          ),
        ),
      ]),
    );
  }
}
