import 'package:flutter/material.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/services/course_service.dart';

import '../../services/course_service.dart';

// ignore: camel_case_types, must_be_immutable
class CourseOptions extends StatefulWidget {
  BuildContext context;
  String termID;
  Course course;

  CourseOptions(String tID, Course course) {

    termID = tID;
    this.course = course;
  }

  @override
  _CourseOptionsState createState() =>
      _CourseOptionsState(termID, course);
}

// ignore: camel_case_types
class _CourseOptionsState extends State<CourseOptions> {
  String termID;
  Course course;
  TextEditingController courseTitleController;
  TextEditingController creditHoursController;
  final FocusScopeNode focusScopeNode = FocusScopeNode();
  String initialTitle;
  String initialCredits;
  bool checked1 = false;
  bool checked2 = false;


  _CourseOptionsState(String tID, Course course) {
    this.termID = tID;
    this.course = course;
    initialTitle = course.name;
    initialCredits = course.credits;

    checked1 = course.passFail;
    checked2 = course.equalWeights;
  }


  void handleSubmitted() {
    focusScopeNode.nextFocus();
  }



  @override
  Widget build(BuildContext context) {


    SizedBox confirmButton = SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0)),
        onPressed: () async {
          if(courseTitleController == null){
            courseTitleController = TextEditingController();
            courseTitleController.text = initialTitle;
            initialTitle = null;
          }
          if(creditHoursController == null){
            creditHoursController = TextEditingController();
            creditHoursController.text = initialCredits;
            initialCredits = null;
          }

          await CourseService(termID).updateCourse(
            courseTitleController.text,
            creditHoursController.text,
            course.id,
            checked1,
            checked2,);
          if (int.parse(creditHoursController.text) is int) {
            // print(creditHoursController.text);
          }
          Navigator.pop(context);
          setState(() {});
        },
        child: Text(
          "Confirm",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );

    return AlertDialog(
      title: Column(children: [
        Text(
            "Course Options",
            style: Theme.of(context).textTheme.headline4
        ),
        Divider(color: Theme.of(context).dividerColor),
      ],),
        content: SizedBox(
          child: FocusScope(
            node: focusScopeNode,
            child: Form(
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(
                      initialValue: initialTitle,
                      controller: courseTitleController,
                      decoration: const InputDecoration(
                        hintText: "ex CS 101",
                        labelText: 'Course Title',
                      ),
                      onEditingComplete: handleSubmitted,
                      onTap: (){
                        if(courseTitleController == null){
                          courseTitleController = TextEditingController();
                          courseTitleController.text = initialTitle;
                          initialTitle = null;
                          setState(() {

                          });
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: initialCredits,
                      controller: creditHoursController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "ex 4",
                        labelText: 'Credit Hours',
                      ),
                      onEditingComplete: handleSubmitted,
                      onTap: (){
                        if(creditHoursController == null){
                          creditHoursController = TextEditingController();
                          creditHoursController.text = initialCredits;
                          initialCredits = null;
                          setState(() {

                          });
                        }
                      },
                    ),
                    Row(
                      children: [
                        Switch(
                          value: checked1,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (updateChecked) {
                            setState(() {
                              checked1 = updateChecked;
                            });
                          },
                        ),
                        Text("Pass/Fail", style: Theme.of(context).textTheme.headline3),
                      ],
                    ),
                    Row(
                      children: [
                        Switch(
                          value: checked2,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (updateChecked) {
                            setState(() {
                              checked2 = updateChecked;
                            });
                          },
                        ),
                        Text("Equally weighed \nAssignments",
                            style: Theme.of(context).textTheme.headline3),
                      ],
                    ),
                  ]),
                ),
            ),
          ),
          width: 100,
          height: 155,
        ),
      actions: [confirmButton],
    );
  }
}

