import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';

// ignore: must_be_immutable
class AssessmentCompleted extends StatefulWidget {

  String termID;
  String courseID;
  String categoryID;
  Assessment assessment;


  AssessmentCompleted(String termID, String courseID,
      String categoryID, Assessment a){
    this.termID = termID;
    this.courseID = courseID;
    this.categoryID = categoryID;
    this.assessment = a;
  }


  @override
  _AssessmentCompletedState createState() =>
      _AssessmentCompletedState(termID, courseID, categoryID, assessment);
}

// ignore: camel_case_types
class _AssessmentCompletedState extends State<AssessmentCompleted> {
  String termID;
  String courseID;
  String categoryID;
  Assessment assessment;

  String initialName;
  String initialDate;
  String initialYourPoints;
  String initialTotalPoints;

  _AssessmentCompletedState(String termID, String courseID,
      String categoryID, Assessment a){
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

  TextEditingController totalPointsController = TextEditingController();
  TextEditingController yourPointsController = TextEditingController();

  DateTime d = DateTime.now();

  bool assignmentIsCompleted = false;
  Column col;
  double dialogueHeight = 293;
  double dialogueWidth = 150;



  @override
  Widget build(BuildContext context) {

    AssessmentService assServ =
    new AssessmentService(termID, courseID, categoryID);

    col = Column(children: [
      Text(
        "Assessment Completion",
        style: TextStyle(
          fontSize: 25,
          color: Theme.of(context).dividerColor,
          fontWeight: FontWeight.w300,
        ),
      ),
      Divider(color: Theme.of(context).dividerColor,thickness: .2,),
      SizedBox(height: 5,),
      Text(assessment.name, style: Theme.of(context).textTheme.headline5,),
      SizedBox(height: 5,),
      TextFormField(
        controller: totalPointsController,
        inputFormatters: [LengthLimitingTextInputFormatter(4)],
        onEditingComplete: handleSubmitted,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: "ex 100",
          labelText: 'Total Points',
        ),
      ),
      TextFormField(
        controller: yourPointsController,
        inputFormatters: [LengthLimitingTextInputFormatter(4)],
        onEditingComplete: handleSubmitted,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: "ex 89.8",
          labelText: 'Points Earned',
        ),
      ),
      SizedBox(height: 15,),
      SizedBox(
        height: 50,
        width: 300,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          onPressed: () async {

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

            if(totalPointsController.text != "" &&
                yourPointsController.text != ""){//When assignment is completed

              print(totalPointsController.text);
              print(yourPointsController.text);
              await assServ.updateAssessmentData(
                assessment,
                assessment.name,
                totalPointsController.text,
                yourPointsController.text,
                true,
                d,
              );
              Navigator.pop(context);
            } else if(totalPointsController.text == "" ||
                totalPointsController.text == ""){
              Navigator.pop(context);
            } else{
              Navigator.pop(context);
            }


          },
          child: Text(
            "Confirm",
            style: Theme.of(context).textTheme.headline2,
          ),
          color: Theme.of(context).primaryColor,
        ),
      ),
    ]);

    return AlertDialog(
        content: SizedBox(
          child: FocusScope(
            node: focusScopeNode,
            child: col,
          ),
          width: dialogueWidth,
          height: dialogueHeight,
        )
    );
  }

}
