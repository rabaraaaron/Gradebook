import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/category_service.dart';
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
  var equalWeights = false;
  String addedCategory;
  Course course;

  CategoryService categoryService;
  final _formKey = GlobalKey<FormState>();

  _NewCategoriesPopUpState(
      List<Category> categories, Term term, Course course) {
    this.course = course;
    c = categories;
    //equalWeights = course.equalWeights;
    categoryService = new CategoryService(term.termID, course.id);
  }

  TextEditingController categoryWeightController =
  new TextEditingController();
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

    return AlertDialog(
      title: Column(children: [
        Text(
          "Add Category",
          style: TextStyle(
            fontSize: 27.5,
            color: Theme.of(context).dividerColor,
            fontWeight: FontWeight.w300,
          ),
        ),
        Divider(color: Theme.of(context).dividerColor,),
      ],),
        content: SizedBox(
          child: Form(
            key: _formKey,
              child: SingleChildScrollView(
                child: Column(children: [
                  DropdownButtonFormField(
                    style: Theme.of(context).textTheme.headline3,
                    hint: Text(
                      "Select Category",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    value: addedCategory,
                    items: listOfCategories,
                    validator: (value){
                      if(value == null) {
                        MessageBar(
                            context: context,
                            msg:"Please select one form the list of categories.",
                            title: "Missing selection").show();
                        return 'field required';
                      } else {return null;}
                    },
                    onChanged: (val) {
                      setState(() {
                        addedCategory = val;
                      });
                    },
                    isExpanded: true,
                  ),
                  TextFormField(
                    controller: categoryWeightController,
                    keyboardType: TextInputType.number,
                    validator:
                        (value) {
                      if (value == null || value.isEmpty) {
                        MessageBar(
                          context: context,
                          title: 'Missing field value',
                          msg: 'Please enter weight value.',
                        ).show();
                        return 'Please enter weight value.';
                      } else if(double.parse(value) > course.remainingWeight){
                        MessageBar(
                            context: context,
                            msg: 'Weight cannot be grater than ' + course.remainingWeight.toString(),
                            title: "invalid weight value.").show();
                        return 'Weight cannot be grater than ' + course.remainingWeight.toString();
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "ex 25",
                      labelText: 'Weight',
                    ),
                  ),
                  Row(
                    children: [
                      Switch(
                        value: dropLowest_isChecked,
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (updateChecked) {
                          setState(() {
                            dropLowest_isChecked = updateChecked;
                          });
                        },
                      ),
                      Text(
                        "Drop Lowest Score?",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                ]),
              )),
          width: 100,
          height: 155,
        ),
      actions: [ SizedBox(
        height: 50,
        width: 300,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0)),
          onPressed: () async {
            if(_formKey.currentState.validate()) {
              print(addedCategory);
              await categoryService.addCategory(
                  addedCategory, categoryWeightController.text,
                  dropLowest_isChecked, course.equalWeights);
              Navigator.pop(context);
            }
            },
          child: Text(
            "Add",
            style: Theme.of(context).textTheme.headline2,
          ),
          color: Theme.of(context).primaryColor,
        ),
      )],
    );
  }
}