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

  final name = TextEditingController();
  final totalPoints = TextEditingController();
  final yourPoints = TextEditingController();
  final date = TextEditingController();
  DateTime d = DateTime.now();

  bool isChecked = false;
  Column col;
  double dialogueHeight = 325;
  double dialogueWidth = 150;



  @override
  Widget build(BuildContext context) {

    AssessmentService assServ =
    new AssessmentService(termID, courseID, categoryID);



    if(isChecked){
      dialogueHeight = 395;
      col = Column(children: [
        Text(
          "Add new Item",
          style: Theme.of(context).textTheme.headline4,
        ),
        Divider(color: Theme.of(context).dividerColor,),
        TextFormField(
          controller: name,
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
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                ).then((v) {
                  if(v == null){
                    return null;
                  } else{
                    d = v;
                    setState(() {
                      date.text = v.year.toString()+'/'+v.month.toString()+'/'+v.day.toString();
                    });
                  }
                });
              },
            )
          ],
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
              value: isChecked,
              activeColor: Theme.of(context).accentColor,
              onChanged: (updateChecked) {
                setState(() {
                  isChecked = updateChecked;
                });
              },
            ),
            Expanded(flex:10, child: Text("Assignment Completed")),
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
                        name.text, totalPoints.text, yourPoints.text, d);
                    Navigator.pop(context);
                  } else if(name.text == ""){
                  } else{ //When assignment is not completed yet
                    await assServ.addAssessment(
                        name.text, "0", "0");
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

      ]);
    } else {
      dialogueHeight = 260;
      col = Column(children: [
        Text(
          "Add new Item",
          style: Theme.of(context).textTheme.headline4,
        ),
        Divider(color: Theme.of(context).dividerColor,),
        TextFormField(
          controller: name,
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
                  initialDate: d,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                ).then((v) {
                  if(v == null){
                    return null;
                  } else{
                    d = v;
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
              value: isChecked,
              activeColor: Theme.of(context).accentColor,
              onChanged: (updateChecked) {
                setState(() {
                  isChecked = updateChecked;
                });
              },
            ),
            Expanded(flex: 10,
                child: Text("Assignment Completed")),
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
                  if(name.text != "" && totalPoints.text != "" &&
                      yourPoints.text != ""){
                    await assServ.addAssessment(
                        name.text, totalPoints.text, yourPoints.text);
                    //await CategoryService(termID, courseID).calculateGrade(categoryID);
                    Navigator.pop(context);
                  } else if(name.text == ""){
                  } else{
                    await assServ.addAssessment(
                        name.text, "0", "0");
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
      ]);
    }

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
