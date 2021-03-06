import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gradebook/utils/MyAppTheme.dart';
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
  DateTime dueDate;
  String initialDate;
  String initialYourPoints;
  String initialTotalPoints;
  var initialTime;
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
    if(a.yourPoints > 0 ){
      initialYourPoints = a.getFormattedNumber(a.yourPoints);
    }
    if(a.totalPoints > 0) {
      initialTotalPoints = a.getFormattedNumber(a.totalPoints);
    }
    dueDate = a.dueDate;
    initialTime = new TimeOfDay(hour: dueDate.hour, minute: dueDate.minute);


  }

  FocusScopeNode focusScopeNode = FocusScopeNode();
  void handleSubmitted(){
    focusScopeNode.nextFocus();
  }

  TextEditingController nameController;
  TextEditingController totalPointsController;
  TextEditingController yourPointsController;
  TextEditingController dateController;
  TextEditingController timeController;

  DateTime d = DateTime.now();

  bool assignmentIsCompleted = false;
  Form form;
  double dialogueHeight;
  //double dialogueWidth = 175;



  @override
  Widget build(BuildContext context) {

    AssessmentService assServ =
    new AssessmentService(termID, courseID, categoryID);

    SizedBox confirmButton;

    if(assignmentIsCompleted){
      dialogueHeight = 155;
      form = Form(
        key: _formKey,
        child: FocusScope(
          node: focusScopeNode,
          child: Column(children: [
            TextFormField(
              textAlign: TextAlign.center,
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
                    textAlign: TextAlign.center,
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
                    textAlign: TextAlign.center,
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
                Text(
                    "Assignment Completed",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ]),
        ),
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
      //dialogueHeight = 155;
      form = Form(
        key: _formKey,
        child: FocusScope(
          node: focusScopeNode,
          child: Column(children: [
            TextFormField(
              textAlign: TextAlign.center,
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
                    textAlign: TextAlign.center,
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
                      initialDate: dueDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                        builder: (BuildContext context, Widget child) {
                          return MyAppTheme().getPickerTheme(child, context);
                        }
                    ).then((v) {
                      if(v == null){
                        return null;
                      } else{
                        dueDate = v;
                        setState(() {
                          d = v;
                          dateController.text = v.month.toString()+'-'+v.day.toString()+
                              '-'+v.year.toString();
                        });
                      }
                    });
                  }
                ),
              ],
            ),
            getDueTimeWidget(),
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
        ),
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
                d = new DateTime(
                    d.year,
                    d.month,
                    d.day,
                    initialTime.hour,
                    initialTime.minute);
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

    return CustomDialog(form: form, button: confirmButton, title: 'Assessment Options', context: context).show();

  }

  Widget getDueTimeWidget(){
    // if(dateController.text == ""){
    //   return Container();
    // }
    timeController = new TextEditingController();
    timeController.text = initialTime.format(context);
        //DateFormat('h:mm a').format(dueDate).toString();

    return Row(children: [
      SizedBox(
        width: 175,
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          readOnly: true,
          controller: timeController,
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
                timeController.text = v.format(context).toString();
              });
            }
          });
        },
      ),
    ],
    );
  }

}
