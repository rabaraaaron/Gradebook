import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../services/category_service.dart';


// ignore: must_be_immutable
class AssessmentPopUp extends StatefulWidget {

  BuildContext c;
  String termID;
  String courseID;
  String categoryID;


  AssessmentPopUp(BuildContext bc, String termID, String courseID, String categoryID){
    c = bc;
    this.termID = termID;
    this.courseID = courseID;
    this.categoryID = categoryID;
  }


  @override
  _AssessmentPopUpState createState() => _AssessmentPopUpState(c, termID, courseID, categoryID);
}

// ignore: camel_case_types
class _AssessmentPopUpState extends State<AssessmentPopUp> {
  BuildContext context;
  String termID;
  String courseID;
  String categoryID;

  _AssessmentPopUpState(BuildContext bc, String termID, String courseID, String categoryID){
    context = bc;
    this.termID = termID;
    this.courseID = courseID;
    this.categoryID = categoryID;
  }

  FocusScopeNode focusScopeNode = FocusScopeNode();
  void handleSubmitted(){
    focusScopeNode.nextFocus();
  }
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final totalPoints = TextEditingController();
  final yourPoints = TextEditingController();
  final date = TextEditingController();
  DateTime dateTime = DateTime.now();

  bool isCompleted = false;
  Form form;
  double dialogueHeight = 325;
  double dialogueWidth = 150;



  @override
  Widget build(BuildContext context) {

    AssessmentService assServ =
    new AssessmentService(termID, courseID, categoryID);



    if(isCompleted){
      dialogueHeight = 400;
      form = Form(
        key: _formKey,
        child: Column(children: [
          Text(
            "Add Assessment",
            style: Theme.of(context).textTheme.headline4,
          ),
          Divider(color: Theme.of(context).dividerColor,),
          TextFormField(
            controller: name,
            validator: (text) {
              if (text == null || text.isEmpty) {
                //print("text is empty");
                return 'Text is emptyfff';
              }
              return null;
            },
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            onEditingComplete: handleSubmitted,
            decoration: const InputDecoration(
              hintText: "ex Quiz 1",
              labelText: 'Assessment Title',
            ),
          ),
          TextFormField(
            controller: totalPoints,
            inputFormatters: [LengthLimitingTextInputFormatter(4)],
            onEditingComplete: handleSubmitted,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "ex 100",
              labelText: 'Total Points',
            ),
          ),
          TextFormField(
            controller: yourPoints,
            inputFormatters: [LengthLimitingTextInputFormatter(4)],
            onEditingComplete: handleSubmitted,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "ex 89.8",
              labelText: 'Points Earned',
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Switch(
                value: isCompleted,
                activeColor: Theme.of(context).accentColor,
                onChanged: (updateChecked) {
                  setState(() {
                    isCompleted = updateChecked;
                  });
                },
              ),
              Expanded(flex: 10,
                  child: Text(
                    "Assignment Completed",
                    style: Theme.of(context).textTheme.headline3,
                  )),
            ],
          ),
          Expanded(
            child: SizedBox(
                width: 300,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  onPressed: () async {
                    if(name.text != "" && totalPoints.text != "" &&
                        yourPoints.text != ""){//When assignment is completed
                      await assServ.addAssessment(
                        //TODO: add due date to the database
                          name.text, totalPoints.text, yourPoints.text, isCompleted, dateTime);
                      Navigator.pop(context);
                    } else if(name.text == ""){
                    } else{ //When assignment is not completed yet

                      await assServ.addAssessment(
                          name.text, "0", "0", isCompleted);
                      Navigator.pop(context);
                    }


                  },
                  child: Text(
                    "Add",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  color: Theme.of(context).primaryColor,
                )
            ),
          ),

        ]),
      );
    } else {
      dialogueHeight = 315;
      form = Form(
        key: _formKey,
        child: Column(children: [
          Text(
            "Add Assessment",
            style: Theme.of(context).textTheme.headline4,
          ),
          Divider(color: Theme.of(context).dividerColor,),
          TextFormField(
            controller: name,
            validator: (text) {
              if (text == null || text.isEmpty) {
                //print("text is empty");
                return 'Text is empty';
              }
              return null;
            },
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            onEditingComplete: handleSubmitted,
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
                  enabled: false,
                  readOnly: true,
                  controller: date,
                  decoration: const InputDecoration(
                      labelText: 'Due Date'
                  ),
                ),
              ),
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.date_range),
                onPressed: (){
                  showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  ).then((v) {
                    if(v == null){
                      return null;
                    } else{
                      dateTime = v;
                      setState(() {
                        date.text = v.year.toString()+'/'+v.month.toString()+'/'+v.day.toString();
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
                value: isCompleted,
                activeColor: Theme.of(context).accentColor,
                onChanged: (updateChecked) {
                  setState(() {
                    isCompleted = updateChecked;
                  });
                },
              ),
              Expanded(flex: 10,
                  child: Text(
                      "Assignment Completed",
                    style: Theme.of(context).textTheme.headline3,
                  )),
            ],
          ),
          Expanded(
            child: SizedBox(
                width: 295,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  onPressed: () async {
                    // if (_formKey.currentState.validate()) {
                    //   // TODO submit
                    //   await assServ.addAssessment(
                    //       name.text, totalPoints.text, yourPoints.text, isCompleted);
                    //   //await CategoryService(termID, courseID).calculateGrade(categoryID);
                    //   Navigator.pop(context);
                    // }

                    if(name.text != "" && totalPoints.text != "" &&
                        yourPoints.text != ""){
                      await assServ.addAssessment(
                          name.text, totalPoints.text, yourPoints.text, isCompleted);
                      //await CategoryService(termID, courseID).calculateGrade(categoryID);
                      Navigator.pop(context);
                    } else if(name.text == ""){
                    } else{
                      await assServ.addAssessment(
                          name.text, "0", "0", isCompleted);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Add",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  color: Theme.of(context).primaryColor,
                )
            ),
          ),
        ]),
      );
    }

    return AlertDialog(
        content: SizedBox(
          child: FocusScope(
            node: focusScopeNode,
            child: form,
          ),
          width: dialogueWidth,
          height: dialogueHeight,
        )
    );
  }

}
