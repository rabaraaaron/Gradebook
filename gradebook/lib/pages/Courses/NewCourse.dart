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

  _NewCourseState(BuildContext c, List<Course> t, String tID) {
    this.termID = tID;
  }

  //var equalWeights = false;
  final classTitleController = TextEditingController();
  final creditHoursController = TextEditingController();
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

    form = Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Expanded(

                  child: TextFormField(
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

            Column(
              children: [
                Row(
                  children: [
                    Switch(
                      value: passFail,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (updateChecked) {
                        setState(() {
                          passFail = updateChecked;
                        });
                      },
                    ),
                    Text("Pass/Fail", style: Theme.of(context).textTheme.headline3),
                  ],
                ),
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
              ],
            ),
          ]),
        ));

    SizedBox addButton = SizedBox(
        height: 50,
        width: 300,
        child: RaisedButton(
            elevation: 0,
            color: Colors.transparent,
            onPressed: () async {
              if(_formKey.currentState.validate()) {

                if (creditHoursController.text.isEmpty) {
                  await CourseService(termID).addCourse(classTitleController.text, "0" , passFail, equalWeights);
                } else{
                  await CourseService(termID).addCourse(classTitleController.text,
                      creditHoursController.text, passFail, equalWeights);
                }
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text("Add", style: Theme.of(context).textTheme.headline3,
            )));

    return CustomDialog(form: form, button: addButton, title: "Add Course", context: context).show();


      AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      content: Container(
        width: 3300.0,
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
              child: Center(child: Text("Add Course", style: Theme.of(context).textTheme.bodyText1,),),
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
              child: addButton,
            ),
          ],
        ),
      ),
    );



    AlertDialog(
      title: Column(children: [
        Text(
          "Add Course",
          style: Theme.of(context).textTheme.headline4,
        ),
        Divider(color: Theme.of(context).dividerColor),
      ],),
        content: SizedBox(
          child: Scrollbar(

            child: FocusScope(
              node: focusScopeNode,
              child: form,
            ),
          ),
          width: 100,
          height: 200,
        ),
      actions: [addButton],
    );
  }
}

