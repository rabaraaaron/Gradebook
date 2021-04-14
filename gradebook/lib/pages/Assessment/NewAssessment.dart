import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';
import 'package:gradebook/utils/timePicker.dart';

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

  var selectedTime;

  var initialTime = TimeOfDay.now();

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
  final dueDateController = TextEditingController();
  final dueTimeController = TextEditingController();
  DateTime dueDate = DateTime.now();


  bool isCompleted = false;
  Form form;
  double dialogueHeight = 325;
  double dialogueWidth = 170;
  double buttonHeight = 50;


  @override
  Widget build(BuildContext context) {

    //initialTime

    AssessmentService assServ =
    new AssessmentService(termID, courseID, categoryID);

    SizedBox addButton;

    if(isCompleted){
      dialogueHeight = 155;
      form = Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              textAlign: TextAlign.center,
              controller: name,
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
              inputFormatters: [LengthLimitingTextInputFormatter(15)],
              onEditingComplete: handleSubmitted,
              decoration: const InputDecoration(
                hintText: "ex Quiz 1",
                labelText: 'Assessment Title',
              ),
            ),
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
                        //print("text is empty");
                        return 'Required field';
                      } else if (double.parse(text) > double.parse(totalPoints.text)){
                        print('3333');
                        MessageBar(context: context,
                            msg:"Earned points cannot be greater than total points.",
                            title: "Invalid input").show();
                        return 'Invalid input';

                      }
                      return null;
                    },
                    controller: yourPoints,
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
                    controller: totalPoints,
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
          ]),
        )
      );

      addButton = SizedBox(
          height: buttonHeight,
          width: 300,
          child: RaisedButton(
            elevation: 0,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(13.0),
            // ),
            onPressed: () async {
              if(_formKey.currentState.validate()){
                if(name.text != "" && totalPoints.text != "" &&
                    yourPoints.text != ""){//When assignment is completed

                  await assServ.addAssessment(
                      name.text, totalPoints.text, yourPoints.text, isCompleted, dueDate);
                  Navigator.pop(context);
                } else if(name.text == ""){
                } else{ //When assignment is not completed yet

                  await assServ.addAssessment(
                      name.text, "0", "0", isCompleted, dueDate);
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              "Add",
              style: Theme.of(context).textTheme.headline3,
            ),
            color: Colors.transparent,
            //color: Theme.of(context).primaryColor,
          )
      );

    } else {
      dialogueHeight = 155;
      form = Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: [
          TextFormField(
            textAlign: TextAlign.center,
            controller: name,
            validator: (text) {
              if (text == null || text.isEmpty) {
                MessageBar(context: context,
                    msg:"Please enter a name for the new assessment.",
                    title: "Required field").show();
                return 'Required field';
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
                  textAlign: TextAlign.center,
                  enabled: false,
                  readOnly: true,
                  controller: dueDateController,
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
                    initialDate: dueDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  ).then((v) {
                    if(v == null){
                      return null;
                    } else{
                      dueDate = v;
                      setState(() {
                        dueDateController.text = v.month.toString()+'-'+v.day.toString()+
                            '-'+v.year.toString();
                      });
                    }
                  });
                },
              )
            ],
          ),
              getDueTimeWidget(),

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
                  Expanded(
                      flex: 10,
                      child: Text(
                        "Assignment Completed",
                        style: Theme.of(context).textTheme.headline3,
                      )
                  ),
                ],
              ),
            ]
            )
        ),
      );

      addButton = SizedBox(
          child: RaisedButton(
            //padding: EdgeInsets.only(top: ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            onPressed: () async {
               if (_formKey.currentState.validate()) {
                 await assServ.addAssessment(
                     name.text, "0", "0", isCompleted, dueDate);
                 Navigator.pop(context);
               }
              //}
            },
            child: Text("Add",
                style:Theme.of(context).textTheme.headline3,
            ),
            color: Colors.transparent,
            elevation: 0,
          )
      );
    }

    return CustomDialog(form: form, button: addButton, title: "Add Assessment", context: context).show();
  }

  Widget getDueTimeWidget(){
    if(dueDateController.text == ""){
      return Container();
    }

    return Row(children: [
      SizedBox(
        width: 175,
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          readOnly: true,
          controller: dueTimeController,
          decoration: const InputDecoration(
              labelText: 'Due Time (optional)'
          ),
        ),
      ),
      IconButton(
        iconSize: 40,
        icon: Icon(Icons.access_time_outlined),
        onPressed: () {
            showTimePicker(
              context: context,
              initialTime: initialTime,
              builder: (BuildContext context, Widget child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: false),
                  child: child,
                );
              },).then((v) {

              if (v == null) {
                return null;
              } else {

                dueDate = new DateTime(
                    dueDate.year,
                    dueDate.month,
                    dueDate.day,
                    v.hour,
                    v.minute);
                setState(() {
                  initialTime = v;
                  dueTimeController.text = v.format(context).toString();
                });
              }
            });
        },
      ),
    ],
    );
  }
}
