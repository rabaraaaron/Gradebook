import 'package:flutter/material.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';

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
  _CourseOptionsState createState() => _CourseOptionsState(termID, course);
}

// ignore: camel_case_types
class _CourseOptionsState extends State<CourseOptions> {
  String termID;
  Course course;
  TextEditingController courseTitleController;
  TextEditingController creditHoursController;
  TextEditingController courseGradeController = TextEditingController();
  String initialTitle;
  String initialCredits;
  bool isPassFail = false;
  bool isEquallyWeighted = false;
  bool isManuallyEntered = false;
  Form form;
  final FocusScopeNode focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  _CourseOptionsState(String tID, Course course) {
    this.termID = tID;
    this.course = course;
    initialTitle = course.name;
    initialCredits = course.credits;
    isPassFail = course.passFail;
    isEquallyWeighted = course.equalWeights;
    courseGradeController.text =
        double.tryParse(course.gradePercent).toStringAsFixed(2);
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
        color: Colors.transparent,
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            if (courseTitleController == null) {
              courseTitleController = TextEditingController();
              courseTitleController.text = initialTitle;
              initialTitle = null;
            }
            if (creditHoursController == null) {
              creditHoursController = TextEditingController();
              creditHoursController.text = initialCredits;
              initialCredits = null;
            }

            //TODO: send course grade to database with courseGradeController.text;
            await CourseService(termID).updateCourse(
                courseTitleController.text,
                creditHoursController.text,
                course.id,
                isPassFail,
                isEquallyWeighted,
                isManuallyEntered,
                courseGradeController.text);
            if (int.parse(creditHoursController.text) is int) {}
            Navigator.pop(context);
            setState(() {});
          }
        },
        child: Text(
          "Confirm",
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );

    if (!isManuallyEntered) {
      form = Form(
        key: _formKey,
        child: FocusScope(
          node: focusScopeNode,
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    initialValue: initialTitle,
                    controller: courseTitleController,
                    decoration: const InputDecoration(
                      hintText: "ex CS 101",
                      labelText: 'Course Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        MessageBar(
                                context: context,
                                msg: "Please enter a name for the new course.",
                                title: "Missing course title")
                            .show();
                        return 'Required field';
                      } else {
                        return null;
                      }
                    },
                    onEditingComplete: handleSubmitted,
                    onTap: () {
                      if (courseTitleController == null) {
                        courseTitleController = TextEditingController();
                        courseTitleController.text = initialTitle;
                        initialTitle = null;
                        setState(() {});
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        MessageBar(
                                context: context,
                                msg:
                                    "Please enter the credit hours of this course.",
                                title: "Invalid credit hours")
                            .show();
                        return 'Required field';
                      } else {
                        return null;
                      }
                    },
                    initialValue: initialCredits,
                    controller: creditHoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "ex 4",
                      labelText: 'Credit Hours',
                    ),
                    onEditingComplete: handleSubmitted,
                    onTap: () {
                      if (creditHoursController == null) {
                        creditHoursController = TextEditingController();
                        creditHoursController.text = initialCredits;
                        initialCredits = null;
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isManuallyEntered,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (updateChecked) {
                    setState(() {
                      isManuallyEntered = updateChecked;
                    });
                  },
                ),
                Text("Manually enter grade",
                    style: Theme.of(context).textTheme.headline3),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isPassFail,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (updateChecked) {
                    setState(() {
                      isPassFail = updateChecked;
                    });
                  },
                ),
                Text("Pass/Fail", style: Theme.of(context).textTheme.headline3),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isEquallyWeighted,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (updateChecked) {
                    setState(() {
                      isEquallyWeighted = updateChecked;
                    });
                  },
                ),
                Text("Equally weighed \nAssignments",
                    style: Theme.of(context).textTheme.headline3),
              ],
            ),
          ]),
        ),
      );
    } else {
      form = Form(
        key: _formKey,
        child: FocusScope(
          node: focusScopeNode,
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    initialValue: initialTitle,
                    controller: courseTitleController,
                    decoration: const InputDecoration(
                      hintText: "ex CS 101",
                      labelText: 'Course Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        MessageBar(
                                context: context,
                                msg: "Please enter a name for the new course.",
                                title: "Missing course title")
                            .show();
                        return 'Required field';
                      } else {
                        return null;
                      }
                    },
                    onEditingComplete: handleSubmitted,
                    onTap: () {
                      if (courseTitleController == null) {
                        courseTitleController = TextEditingController();
                        courseTitleController.text = initialTitle;
                        initialTitle = null;
                        setState(() {});
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        MessageBar(
                                context: context,
                                msg:
                                    "Please enter the credit hours of this course.",
                                title: "Invalid credit hours")
                            .show();
                        return 'Required field';
                      } else {
                        return null;
                      }
                    },
                    initialValue: initialCredits,
                    controller: creditHoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "ex 4",
                      labelText: 'Credit Hours',
                    ),
                    onEditingComplete: handleSubmitted,
                    onTap: () {
                      if (creditHoursController == null) {
                        creditHoursController = TextEditingController();
                        creditHoursController.text = initialCredits;
                        initialCredits = null;
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              textAlign: TextAlign.center,
              controller: courseGradeController,
              decoration: const InputDecoration(
                hintText: "ex 95.5",
                labelText: 'Course Grade',
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null) {
                  MessageBar(
                          context: context,
                          msg: "Please enter a valid course grade.",
                          title: "Invalid course grade")
                      .show();
                  return 'Required field';
                } else {
                  return null;
                }
              },
              onEditingComplete: handleSubmitted,
            ),
            Row(
              children: [
                Switch(
                  value: isManuallyEntered,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (updateChecked) {
                    setState(() {
                      isManuallyEntered = updateChecked;
                    });
                  },
                ),
                Text("Manually enter grade",
                    style: Theme.of(context).textTheme.headline3),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isPassFail,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (updateChecked) {
                    setState(() {
                      isPassFail = updateChecked;
                    });
                  },
                ),
                Text("Pass/Fail", style: Theme.of(context).textTheme.headline3),
              ],
            ),
          ]),
        ),
      );
    }

    return CustomDialog(
            title: "Course Options",
            form: form,
            button: confirmButton,
            context: context)
        .show();
  }
}
