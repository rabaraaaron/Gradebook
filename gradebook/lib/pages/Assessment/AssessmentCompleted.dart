import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';

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
  final _formKey = GlobalKey<FormState>();

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
  Form form;
  double dialogueHeight = 293;
  double dialogueWidth = 150;



  @override
  Widget build(BuildContext context) {

    AssessmentService assServ =
    new AssessmentService(termID, courseID, categoryID);

    Widget button = SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
        ),
        onPressed: () async {
          //
          // if(totalPointsController == null){
          //   totalPointsController = TextEditingController();
          //   totalPointsController.text = initialTotalPoints;
          //   initialTotalPoints = null;
          //   setState(() { });
          // }
          // if(yourPointsController == null){
          //   yourPointsController = TextEditingController();
          //   yourPointsController.text = initialYourPoints;
          //   initialYourPoints = null;
          //   setState(() { });
          // }
          //
          // if(totalPointsController.text != "" &&
          //     yourPointsController.text != ""){//When assignment is completed
          //
          //   print(totalPointsController.text);
          //   print(yourPointsController.text);
          //
          if(_formKey.currentState.validate()) {
            await assServ.updateAssessmentData(
              assessment,
              assessment.name,
              totalPointsController.text,
              yourPointsController.text,
              true,
              d,
            );
            Navigator.pop(context);
            setState(() {

            });
          }
          // } else if(totalPointsController.text == "" ||
          //     totalPointsController.text == ""){
          //   Navigator.pop(context);
          // } else{
          //   Navigator.pop(context);
          // }


        },
        child: Text(
          "Confirm",
          style: Theme.of(context).textTheme.headline3,
        ),
        color: Colors.transparent,
        elevation: 0,
      ),
    );




    form = Form(
      key: _formKey,
      child: Column(children: [
        SizedBox(height: 15,),
        Text(assessment.name, style: Theme.of(context).textTheme.headline5,),
        SizedBox(height: 5,),

        Row(
          children: [
            Expanded(

              child: TextFormField(
                textAlign: TextAlign.center,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    MessageBar(context: context,
                        msg:"Please enter total points earned.",
                        title: "Required field").show();
                    return 'Required field';
                  } else if (totalPointsController.text.isNotEmpty && double.parse(text) > double.parse(totalPointsController.text)){
                    print('3333');
                    MessageBar(context: context,
                        msg:"Earned points cannot be greater than total points.",
                        title: "Invalid input").show();
                    return 'Invalid input';

                  }
                  return null;
                },
                controller: yourPointsController,
                inputFormatters: [LengthLimitingTextInputFormatter(4)],
                onEditingComplete: handleSubmitted,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "ex 89.8",
                  labelText: 'Points Earned',
                ),
              ),
            ),
            SizedBox(width: 20,),
            Expanded(
              child: TextFormField(
                textAlign: TextAlign.center,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    MessageBar(context: context,
                        msg:"Please enter total points value for this assessment.",
                        title: "Required field").show();
                    //print("text is empty");
                    return 'Required field';
                  }
                  return null;
                },
                controller: totalPointsController,
                inputFormatters: [LengthLimitingTextInputFormatter(4)],
                onEditingComplete: handleSubmitted,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "ex 100",
                  labelText: 'Total Points',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15,),
        //button,

      ]),
    );



    return CustomDialog(form: form, button: button, title:"Assessment Completion", context: context).show();
  }

}
