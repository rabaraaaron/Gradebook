import 'package:flutter/material.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/services/course_service.dart';

// ignore: camel_case_types, must_be_immutable
class NewCourse extends StatefulWidget {
  BuildContext context;
  List<Course> terms;
  String termID;

  NewCourse(BuildContext c, List<Course> t, String tID) {
    context = c;
    terms = t;
    termID = tID;
  }

  @override
  _NewCourseState createState() =>
      _NewCourseState(context, terms, termID);
}

// ignore: camel_case_types
class _NewCourseState extends State<NewCourse> {
  String termID;

  _NewCourseState(BuildContext c, List<Course> t, String tID) {
    this.termID = tID;
  }


  final classTitleController = TextEditingController();
  final creditHoursController = TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer", "Other"];
  List<DropdownMenuItem> listOfTerms = [];

  void handleSubmitted() {
    focusScopeNode.nextFocus();
  }

  bool checked1 = false;
  bool checked2 = false;

  @override
  Widget build(BuildContext context) {
    for (var l = 0; l < listOfTermsRaw.length; l++) {
      listOfTerms.insert(
          0, DropdownMenuItem(child: Text("${listOfTermsRaw[l]}")));
    }
    List<DropdownMenuItem> listOfYears = [];
    for (var i = 2015; i <= DateTime.now().year; i++) {
      listOfYears.insert(0, DropdownMenuItem(child: Text("$i")));
    }

    return AlertDialog(
        content: SizedBox(
          child: FocusScope(
            node: focusScopeNode,
            child: Form(
                child: Column(children: [
                  Text(
                    "Add new Class",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                  TextFormField(
                    controller: classTitleController,
                    decoration: const InputDecoration(
                      hintText: "ex CS 101",
                      labelText: 'Class Title',
                    ),
                    onEditingComplete: handleSubmitted,
                  ),
                  TextFormField(
                    controller: creditHoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "ex 4",
                      labelText: 'Credit Hours',
                    ),
                    onEditingComplete: handleSubmitted,
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
                      Text("Equally Weighed \nAssignments", style: Theme.of(context).textTheme.headline3),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                        width: 300,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith(
                                        (states) => Theme.of(context).primaryColor),
                                shape: MaterialStateProperty.resolveWith((states) =>
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13.0)))),
                            onPressed: () async {
                              await CourseService(termID).addCourse(classTitleController.text,
                                  creditHoursController.text);
                              if (int.parse(creditHoursController.text) is int) {
                                print(creditHoursController.text);
                              }
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text(
                              "Add",
                              style: Theme.of(context).textTheme.headline2,
                            ))),
                  ),
                ])),
          ),
          width: 100,
          height: 310,
        ));
  }
}

