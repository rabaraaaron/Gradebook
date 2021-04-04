import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';

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
  final _formKey = GlobalKey<FormState>();

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
  Form form;
  double dialogueHeight;
  double dialogueWidth = 150;



  @override
  Widget build(BuildContext context) {

    AssessmentService assServ =
    new AssessmentService(termID, courseID, categoryID);

    SizedBox confirmButton;

    if(assignmentIsCompleted){
      dialogueHeight = 155;
      form = Form(
        key: _formKey,
        child: Column(children: [
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
            validator: (text) {
              if (text == null || text.isEmpty) {
                MessageBar(context: context,
                    msg:"Please enter a name for the new assessment.",
                    title: "Required field").show();
                //print("text is empty");
                return 'Required field';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      MessageBar(context: context,
                          msg:"Please enter total points earned.",
                          title: "Required field").show();
                      //print("text is empty");
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
                ),
              ),
              SizedBox(width: 20,),

              Expanded(
                child: TextFormField(
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
                ),
              ),
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
              Expanded(
                  flex:10,
                  child: Text(
                      "Assignment Completed",
                    style: Theme.of(context).textTheme.headline3,
                  )
              ),
            ],
          ),
        ]),
      );

      confirmButton = SizedBox(
        //height: 50,
        //width: 300,
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
            if(_formKey.currentState.validate()) {
              await assServ.updateAssessmentData(
                assessment,
                nameController.text,
                totalPointsController.text,
                yourPointsController.text,
                assignmentIsCompleted,
                d,
              );
              Navigator.pop(context);
            }
          },
          child: Text(
            "Confirm",
            style: Theme.of(context).textTheme.headline3,
          ),
          color: Colors.transparent,
          elevation: 0,
        ),
      );

    } else { //When assignment is not completed yet
      dialogueHeight = 155;
      form = Form(
        key: _formKey,
        child: Column(children: [
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
        ]),
      );

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

              if(_formKey.currentState.validate()) {
                await assServ.updateAssessmentData(assessment, nameController.text, "0", "0", assignmentIsCompleted, d);
                Navigator.pop(context);
              }
             // }
            },
            child: Text(
              "Confirm",
              style: Theme.of(context).textTheme.headline3,
            ),
            color: Colors.transparent,
            elevation: 0,
          )
      );
    }

    return CustomDialog(form: form, button: confirmButton, context: context).show();


      AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      content: Container(
        width: 300.0,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
              ),
              child:Center(
                child: Text(
                  "Add Assessment",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: form,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              height: 2.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                //color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0)),
              ),
              child: confirmButton,
            ),
          ],
        ),
      ),
    );
  }

}
