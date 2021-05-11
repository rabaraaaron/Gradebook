import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';

// ignore: must_be_immutable
class NewCategoriesPopUp extends StatefulWidget {
  List<Category> c = [];
  Term term;
  final Course course;

  NewCategoriesPopUp({
    this.c,
    this.course,
    this.term,
  });
  @override
  _NewCategoriesPopUpState createState() =>
      _NewCategoriesPopUpState(c, term, course);
}

class _NewCategoriesPopUpState extends State<NewCategoriesPopUp> {
  List<Category> c = [];
  // ignore: non_constant_identifier_names
  bool dropLowest_isChecked = false;
  bool isManuallyEntered = false;
  var equalWeights = false;
  String addedCategory;
  Course course;
  Form form;
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  CategoryService categoryService;
  final _formKey = GlobalKey<FormState>();

  _NewCategoriesPopUpState(
      List<Category> categories, Term term, Course course) {
    this.course = course;
    c = categories;
    //equalWeights = course.equalWeights;
    categoryService = new CategoryService(term.termID, course.id);
  }

  void handleSubmitted() {
    focusScopeNode.nextFocus();
  }

  TextEditingController numberDroppedController = new TextEditingController();
  TextEditingController categoryWeightController = new TextEditingController();
  TextEditingController catPercentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    List<String> categoriesStrings = [
      "Other",
      "Extra Credit",
      "Project",
      "Participation",
      "Homework",
      "Quizzes",
      "Exams",
      "Assignments",
    ];

    List<DropdownMenuItem> listOfCategories = [];

    for (var i = 0; i < categoriesStrings.length; i++) {
      listOfCategories.insert(
          0,
          DropdownMenuItem(
            child: Center(

              child: Text(
                "${categoriesStrings[i]}",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            value: categoriesStrings[i],
          ));
    }

    Row topRow = Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              style: Theme
                  .of(context)
                  .textTheme
                  .headline3,
              hint: Text(
                "Select Category",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline3,
              ),
              value: addedCategory,
              items: listOfCategories,
              validator: (value) {
                if (value == null) {
                  MessageBar(
                      context: context,
                      msg: "Please select one form the list of categories.",
                      title: "Missing selection").show();
                  return 'field required';
                } else {
                  return null;
                }
              },
              onChanged: (val) {
                setState(() {
                  addedCategory = val;
                });
              },
              isExpanded: true,
            ),
          ),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: categoryWeightController,
            keyboardType: TextInputType.number,
            onEditingComplete: handleSubmitted,
            validator:
                (value) {
              if (value == null || value.isEmpty) {
                MessageBar(
                  context: context,
                  title: 'Required field',
                  msg: 'Please enter weight value.',
                ).show();
                return 'Required field.';
              } else
              if (double.parse(value) > course.remainingWeight) {
                MessageBar(
                    context: context,
                    msg: 'Weight cannot be grater than ' +
                        course.remainingWeight.toString(),
                    title: "invalid weight value.").show();
                return course
                    .remainingWeight.toString() + " or less";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
              hintText: "ex 25",
              labelText: 'Weight',
            ),
          ),
        ),
      ],
  );
    Row manuallyEnterSwitch = Row(
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
        Text("Manually enter percentage", style: Theme.of(context).textTheme.headline3),
      ],
    );
    Row dropLowestSwitch = Row(
      children: [
        Switch(
          value: dropLowest_isChecked,
          activeColor: Theme
              .of(context)
              .accentColor,
          onChanged: (updateChecked) {
            setState(() {
              dropLowest_isChecked = updateChecked;
            });
          },
        ),
        Text(
          "Drop Lowest Score?",
          style: Theme
              .of(context)
              .textTheme
              .headline3,
        ),
      ],
    );
    SizedBox sizedBox = SizedBox(
      width: 155,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: numberDroppedController,
        keyboardType: TextInputType.number,
        validator:
            (value) {
          if (value == null || value.isEmpty) {
            MessageBar(
              context: context,
              title: 'Required field',
              msg: 'Please enter number of assessments to be dropped.',
            ).show();
            return 'Required field.';
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: "ex 2",
          labelText: 'Number of dropped assessments.',
        ),
      ),
    );
    Column c;

    TextFormField manEntered = TextFormField(
      textAlign: TextAlign.center,
      controller: catPercentController,
      decoration: const InputDecoration(
        hintText: "ex 95.5",
        labelText: 'Category Percentage',
      ),
      validator: (value){
        if(value == null || value.isEmpty || double.tryParse(value) == null) {
          MessageBar(context: context,
              msg:"Please enter a valid category percentage.",
              title: "Invalid category percentage").show();
          return 'Required field';
        } else {return null;}
      },
      onEditingComplete: handleSubmitted,

    );

    if(dropLowest_isChecked){
      c = Column(
        children: [
          dropLowestSwitch,
          sizedBox,
          SizedBox(height: 15,),
        ],
      );
    } else{
      c = Column(
        children: [
          dropLowestSwitch,
        ],
      );
    }

    if(isManuallyEntered) {
      form = Form(
          key: _formKey,
          child: FocusScope(
            node: focusScopeNode,
            child: Column(children: [
              topRow,
              manEntered,
              // manuallyEnterSwitch,
            ]),
          )
      );
    } else {
      form = Form(
          key: _formKey,
          child: FocusScope(
            node: focusScopeNode,
            child: Column(children: [
              topRow,
              // manuallyEnterSwitch,
              c,
            ]),
          )
      );
    }

    Widget button = RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0)),
      onPressed: () async {

        //TODO: add isManuallyEntered into the database
        if(_formKey.currentState.validate()) {
          await categoryService.addCategory(
              addedCategory, categoryWeightController.text,
              dropLowest_isChecked, numberDroppedController.text, course.equalWeights, isManuallyEntered);
          Navigator.pop(context);
        }
      },
      child: Text(
        "Add",
        style: Theme.of(context).textTheme.headline3,
      ),
      color: Colors.transparent,
      elevation: 0,
    );

    return CustomDialog(form: form, button: button, title: "Add Category" , context: context).show();

  }
}