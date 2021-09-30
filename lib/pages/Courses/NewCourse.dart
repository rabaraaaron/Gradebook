import 'package:flutter/material.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';

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
  Form form;
  String initialGrade = "";
  bool isManuallyEntered = false;

  _NewCourseState(BuildContext c, List<Course> t, String tID) {
    this.termID = tID;
  }

  //var equalWeights = false;
  final classTitleController = TextEditingController();
  final creditHoursController = TextEditingController();
  final courseGradeController = TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer", "Other"];
  List<DropdownMenuItem> listOfTerms = [];
  final _formKey = GlobalKey<FormState>();

  void handleSubmitted() {
    focusScopeNode.nextFocus();
  }

  bool passFail = false;
  bool equalWeights = false;

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

    if(!isManuallyEntered){
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
                    validator: (value){
                      if(value == null || value.isEmpty) {
                        MessageBar(context: context,
                            msg:"Please enter a name for the new course.",
                            title: "Required field").show();
                        return 'Required field';
                      } else {return null;}
                    },
                    controller: classTitleController,
                    decoration: const InputDecoration(
                      hintText: "ex CS 101",
                      labelText: 'Course Title',
                    ),
                    onEditingComplete: handleSubmitted,
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    validator: (value){
                      if(value == null || value.isEmpty || int.tryParse(value) == null) {
                        MessageBar(context: context,
                            msg:"Please enter the credit hours of this course.",
                            title: "Invalid credit hours").show();
                        return 'Required field';
                      } else {return null;}
                    },
                    controller: creditHoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "ex 4",
                      labelText: 'Credit Hours',
                    ),
                    onEditingComplete: handleSubmitted,
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
                Text("Manually enter grade", style: Theme.of(context).textTheme.headline3),
              ],
            ),
            // Row(
            //   children: [
            //     Switch(
            //       value: passFail,
            //       activeColor: Theme.of(context).accentColor,
            //       onChanged: (updateChecked) {
            //         setState(() {
            //           passFail = updateChecked;
            //         });
            //       },
            //     ),
            //     Text("Pass/Fail", style: Theme.of(context).textTheme.headline3),
            //   ],
            // ),
            Row(
              children: [
                Switch(
                  value: equalWeights,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (updateChecked) {
                    setState(() {
                      equalWeights = updateChecked;
                    });
                  },
                ),
                Text("Equally Weighed \nAssessments", style: Theme.of(context).textTheme.headline3),
              ],
            ),
          ]),
        ),
      );
    } else{
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
                    validator: (value){
                      if(value == null || value.isEmpty) {
                        MessageBar(context: context,
                            msg:"Please enter a name for the new course.",
                            title: "Required field").show();
                        return 'Required field';
                      } else {return null;}
                    },
                    controller: classTitleController,
                    decoration: const InputDecoration(
                      hintText: "ex CS 101",
                      labelText: 'Course Title',
                    ),
                    onEditingComplete: handleSubmitted,
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    validator: (value){
                      if(value == null || value.isEmpty || int.tryParse(value) == null) {
                        MessageBar(context: context,
                            msg:"Please enter the credit hours of this course.",
                            title: "Invalid credit hours").show();

                        return 'Required field';
                      } else {return null;}
                    },
                    controller: creditHoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "ex 4",
                      labelText: 'Credit Hours',
                    ),
                    onEditingComplete: handleSubmitted,
                  ),
                ),
              ],
            ),
            TextFormField(
              textAlign: TextAlign.center,
              validator: (value){
                if(value == null || value.isEmpty || double.tryParse(value) == null) {
                  MessageBar(context: context,
                      msg:"Please enter the course grade.",
                      title: "Invalid course grade").show();
                  return 'Required field';
                } else {return null;}
              },
              controller: courseGradeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "ex 95.5",
                labelText: 'Course Grade',
              ),
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
                Text("Manually enter grade", style: Theme.of(context).textTheme.headline3),
              ],
            ),
            // Row(
            //   children: [
            //     Switch(
            //       value: passFail,
            //       activeColor: Theme.of(context).accentColor,
            //       onChanged: (updateChecked) {
            //         setState(() {
            //           passFail = updateChecked;
            //         });
            //       },
            //     ),
            //     Text("Pass/Fail", style: Theme.of(context).textTheme.headline3),
            //   ],
            // ),
          ]),
        ),
      );
    }


    SizedBox addButton = SizedBox(
        height: 50,
        width: 300,
        child: RaisedButton(
            elevation: 0,
            color: Colors.transparent,
            onPressed: () async {
              if(_formKey.currentState.validate()) {

                //TODO: add manually entered course grade into database using
                // courseGradeController.text
                if (creditHoursController.text.isEmpty) {
                  await CourseService(termID).addCourse(classTitleController.text, "0" , passFail, equalWeights, isManuallyEntered, courseGradeController.text);
                } else{
                  await CourseService(termID).addCourse(classTitleController.text,
                      creditHoursController.text, passFail, equalWeights, isManuallyEntered, courseGradeController.text);
                }
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text("Add", style: Theme.of(context).textTheme.headline3,
            )
        )
    );

    return CustomDialog(form: form, button: addButton, title: "Add Course", context: context).show();
  }
}

