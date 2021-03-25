import 'package:flutter/material.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/services/course_service.dart';

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


  _CourseOptionsState(String tID, Course course) {
    this.termID = tID;
    this.course = course;
    initialTitle = course.name;
    initialCredits = course.credits;
  }


  void handleSubmitted() {
    focusScopeNode.nextFocus();
  }

  bool checked1 = false;
  bool checked2 = false;

  @override
  Widget build(BuildContext context) {


    return AlertDialog(
        content: SizedBox(
          child: FocusScope(
            node: focusScopeNode,
            child: Form(
                child: Column(children: [
                  Text(
                    "Course Options",
                    style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).dividerColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Divider(color: Theme.of(context).dividerColor),
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
                      Text("Pass/Fail", style: Theme.of(context).textTheme.headline3),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                        width: 300,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0)),
                              onPressed: () async {
                                if(courseTitleController == null ||
                                    creditHoursController == null){
                                  courseTitleController = TextEditingController();
                                  creditHoursController = TextEditingController();
                                  courseTitleController.text = initialTitle;
                                  creditHoursController.text = initialCredits;
                                  initialTitle = null;
                                  initialCredits = null;
                                }
                                //TODO: Update the changes to the course
                                // Get updated title with courseTitleController.text
                                // Get updated credits with creditHoursController.text
                                // Get Pass/fail updated value with checked1
                                // Get equally weighed assignments with checked2
                                // await CourseService(termID).addCourse(courseTitleController.text,
                                //     creditHoursController.text);
                                  if (int.parse(creditHoursController.text) is int) {
                                    print(creditHoursController.text);
                                  }
                                  Navigator.pop(context);
                                  setState(() {});
                                  },
                              child: Text(
                                "Confirm",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                          ),
                        ),
                    ),
                ]),
            ),
          ),
          width: 100,
          height: 310,
        ));
  }
}

