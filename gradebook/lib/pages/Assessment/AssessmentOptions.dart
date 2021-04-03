import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../services/category_service.dart';


// ignore: must_be_immutable
class AssessmentOptions extends StatefulWidget {

  BuildContext c;
  String termID;
  String courseID;
  String categoryID;
  Assessment assessment;


  AssessmentOptions(BuildContext bc, String termID, String courseID,
      String categoryID, Assessment a){
    c = bc;
    this.termID = termID;
    this.courseID = courseID;
    this.categoryID = categoryID;
    this.assessment = a;
  }


  @override
  _AssessmentOptionsState createState() =>
      _AssessmentOptionsState(c, termID, courseID, categoryID, assessment);
}

// ignore: camel_case_types
class _AssessmentOptionsState extends State<AssessmentOptions> {
  BuildContext context;
  String termID;
  String courseID;
  String categoryID;
  Assessment assessment;

  String initialName;
  String initialDate;
  String initialYourPoints;
  String initialTotalPoints;

  _AssessmentOptionsState(BuildContext bc, String termID, String courseID,
      String categoryID, Assessment a){
    context = bc;
    this.termID = termID;
    this.courseID = courseID;
    this.categoryID = categoryID;
    this.assessment = a;
    this.initialName = a.name;
    this.assignmentIsCompleted = a.isCompleted;
    initialDate = a.dueDate.month.toString()
        +'-'+a.dueDate.day.toString()
        + '-'+a.dueDate.year.toString();
    initialYourPoints = a.yourPoints.toString();
    initialTotalPoints = a.totalPoints.toString();

  }

  FocusScopeNode focusScopeNode = FocusScopeNode();
  void handleSubmitted(){
    focusScopeNode.nextFocus();
  }

  TextEditingController nameController;
  TextEditingController totalPointsController;
  TextEditingController yourPointsController;
  TextEditingController dateController;

  DateTime d = DateTime.now();

  bool assignmentIsCompleted = false;
  Column col;
  double dialogueHeight;
  double dialogueWidth = 150;



  @override
  Widget build(BuildContext context) {

    AssessmentService assServ =
    new AssessmentService(termID, courseID, categoryID);

    SizedBox confirmButton;

    if(assignmentIsCompleted){
      dialogueHeight = 155;
      col = Column(children: [
        TextFormField(
          initialValue: initialName,
          controller: nameController,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
          onEditingComplete: handleSubmitted,
          onTap: (){
            if(nameController == null){
              nameController = TextEditingController();
              nameController.text = initialName;
              initialName = null;
              setState(() { });
            }
          },
          decoration: const InputDecoration(
            hintText: "ex Quiz 1",
            labelText: 'Assessment Title',
          ),
        ),

        TextFormField(
          initialValue: initialTotalPoints,
          controller: totalPointsController,
          inputFormatters: [LengthLimitingTextInputFormatter(4)],
          onEditingComplete: handleSubmitted,
          keyboardType: TextInputType.number,
          onTap: (){
            if(totalPointsController == null){
              totalPointsController = TextEditingController();
              totalPointsController.text = initialTotalPoints;
              initialTotalPoints = null;
              setState(() { });
            }
          },
          decoration: const InputDecoration(
            hintText: "ex 100",
            labelText: 'Total Points',
          ),
        ),
        TextFormField(
          initialValue: initialYourPoints,
          controller: yourPointsController,
          inputFormatters: [LengthLimitingTextInputFormatter(4)],
          onEditingComplete: handleSubmitted,
          keyboardType: TextInputType.number,
          onTap: (){
            if(yourPointsController == null){
              yourPointsController = TextEditingController();
              yourPointsController.text = initialYourPoints;
              initialYourPoints = null;
              setState(() { });
            }
          },
          decoration: const InputDecoration(
            hintText: "ex 89.8",
            labelText: 'Points Earned',
          ),
        ),

        Row(
          children: [
            Switch(
              value: assignmentIsCompleted,
              activeColor: Theme.of(context).accentColor,
              onChanged: (updateChecked) {
                setState(() {
                  assignmentIsCompleted = updateChecked;
                });
              },
            ),
            Expanded(
                flex:10,
                child: Text(
                    "Assignment Completed",
                  style: Theme.of(context).textTheme.headline3,
                )
            ),
          ],
        ),
      ]);

      confirmButton = SizedBox(
        height: 50,
        width: 300,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          onPressed: () async {

            if(nameController == null){
              nameController = TextEditingController();
              nameController.text = initialName;
              initialName = null;
              setState(() { });
            }
            if(totalPointsController == null){
              totalPointsController = TextEditingController();
              totalPointsController.text = initialTotalPoints;
              initialTotalPoints = null;
              setState(() { });
            }
            if(yourPointsController == null){
              yourPointsController = TextEditingController();
              yourPointsController.text = initialYourPoints;
              initialYourPoints = null;
              setState(() { });
            }

            if(nameController.text != "" && totalPointsController.text != "" &&
                yourPointsController.text != ""){//When assignment is completed

              print(nameController.text);
              print(totalPointsController.text);
              print(yourPointsController.text);
              await assServ.updateAssessmentData(
                assessment,
                nameController.text,
                totalPointsController.text,
                yourPointsController.text,
                assignmentIsCompleted,
                d,
              );
              Navigator.pop(context);
            } else if(nameController.text == ""){
            } else{
              await assServ.addAssessment(nameController.text, assignmentIsCompleted, "0", "0");
              Navigator.pop(context);
            }


          },
          child: Text(
            "Confirm",
            style: Theme.of(context).textTheme.headline2,
          ),
          color: Theme.of(context).primaryColor,
        ),
      );

    } else { //When assignment is not completed yet
      dialogueHeight = 155;
      col = Column(children: [
        TextFormField(
          initialValue: initialName,
          controller: nameController,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
          onEditingComplete: handleSubmitted,
          onTap: (){
            if(nameController == null){
              nameController = TextEditingController();
              nameController.text = initialName;
              initialName = null;
              setState(() { });
            }
          },
          decoration: const InputDecoration(
            hintText: "ex Quiz 1",
            labelText: 'Assessment Title',
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 175,
              child: TextFormField(
                initialValue: initialDate,
                enabled: false,
                readOnly: true,
                controller: dateController,
                decoration: const InputDecoration(
                    labelText: 'Due Date'
                ),
              ),
            ),
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.date_range),
              onPressed: (){
                if(dateController == null){
                  dateController = TextEditingController();
                  dateController.text = initialDate;
                  initialDate = null;
                }
                showDatePicker(
                  context: context,
                  initialDate: d,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                ).then((v) {
                  if(v == null){
                    return null;
                  } else{
                    d = v;
                    dateController = TextEditingController();
                    setState(() {
                      dateController.text = v.month.toString()+'-'+
                          v.day.toString()+'-'+v.year.toString();
                    });
                  }
                });
              },
            )
          ],
        ),
        Row(
          children: [
            Switch(
              value: assignmentIsCompleted,
              activeColor: Theme.of(context).accentColor,
              onChanged: (updateChecked) {
                setState(() {
                  assignmentIsCompleted = updateChecked;
                });
              },
            ),
            Expanded(flex: 10,
                child: Text(
                    "Assignment Completed",
                  style: Theme.of(context).textTheme.headline3,
                ),
            ),
          ],
        ),
      ]);

      confirmButton = SizedBox(
          height: 50,
          width: 295,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            onPressed: () async {
              if(nameController == null){
                nameController = TextEditingController();
                nameController.text = initialName;
                initialName = null;
                setState(() { });
              }

              if(dateController == null){
                dateController = TextEditingController();
                dateController.text = initialDate;
                initialDate = null;
                setState(() { });
              }

              if(totalPointsController == null){
                totalPointsController = TextEditingController();
                totalPointsController.text = initialTotalPoints;
                initialTotalPoints = null;
                setState(() {});
              }

              if(yourPointsController == null){
                yourPointsController = TextEditingController();
                yourPointsController.text = initialYourPoints;
                initialYourPoints = null;
                setState(() {});
              }

              if(nameController.text != ""){

                print(nameController.text);

                await assServ.updateAssessmentData(
                    assessment,
                    nameController.text,
                    totalPointsController.text,
                    yourPointsController.text,
                    assignmentIsCompleted,
                    d
                );
                // await assServ.addAssessment(
                //     nameController.text, totalPointsController.text, yourPointsController.text, assignmentIsCompleted);
                //await CategoryService(termID, courseID).calculateGrade(categoryID);
                Navigator.pop(context);
              } else if(nameController.text == ""){
              } else{
                print('print from assessmentOptions.dart line 356---------- about to update assessment ) ' + assessment.name);
                //await assServ.updateAssessmentData(assessment, nameController.text, totalPointsController.text, yourPointsController.text);
                await assServ.addAssessment(nameController.text, "0", "0", assignmentIsCompleted);
                Navigator.pop(context);
              }
            },
            child: Text(
              "Confirm",
              style: Theme.of(context).textTheme.headline2,
            ),
            color: Theme.of(context).primaryColor,
          )
      );
    }

    return AlertDialog(
        title: Column(
          children: [Text(
            "Assessment Options",
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).dividerColor,
              fontWeight: FontWeight.w300,
            ),
          ),
            Divider(color: Theme.of(context).dividerColor,),
          ]),
        content: SizedBox(
          child: FocusScope(
            node: focusScopeNode,
            child: SingleChildScrollView(
                child: col,
            ),
          ),
          width: dialogueWidth,
          height: dialogueHeight,
        ),
      actions: [confirmButton],
    );
  }

}
