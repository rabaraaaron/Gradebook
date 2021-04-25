import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/utils/calculator.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';

// ignore: must_be_immutable
class CategoryOptions extends StatefulWidget {
  Term term;
  Course course;
  Category c;

  CategoryOptions(Category c, Term term, Course course) {
    this.c = c;
    this.term = term;
    this.course = course;
  }

  @override
  _CategoryOptions createState() => _CategoryOptions(c, term, course);
}

class _CategoryOptions extends State<CategoryOptions> {
  // ignore: non_constant_identifier_names
  Term term;
  bool dropLowest;
  Category c;
  String addedCategory;
  String initialWeight;
  String initialnumberDropped;
  bool equalWeights;
  Course course;
  Form form;
  Calculator calculator;

  CategoryService categoryService;

  _CategoryOptions(Category c, Term term, Course course) {


    this.course = course;
    this.c = c;
    this.term = term;
    categoryService = new CategoryService(term.termID, course.id);
    calculator = new Calculator();
    addedCategory = c.categoryName;
    initialWeight = c.categoryWeight.toString();
    initialnumberDropped = c.numberDropped.toString();
    equalWeights = c.equalWeights;
    if (c.dropLowestScore == null) {
      dropLowest = false;
    } else {
      dropLowest = c.dropLowestScore;
    }
  }

  TextEditingController categoryWeightController, numberDroppedController;


  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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

    form = Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          MessageBar(context: context,
                              msg: "Please select one form the list of categories.",
                              title: "Missing selection").show();
                          return 'field required';
                        } else {
                          return null;
                        }
                      },
                      style: Theme.of(context).textTheme.headline3,
                      hint: Text("Select Category", style: Theme.of(context).textTheme.headline3,),
                      value: addedCategory,
                      items: listOfCategories,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        MessageBar(
                          context: context,
                          title: 'Missing field value',
                          msg: 'Please enter a weight value',
                        ).show();
                        return 'Please enter weight value';
                      } else if (double.parse(value) >
                          course.remainingWeight + c.categoryWeight) {
                        MessageBar(
                            title: "invalid weight value",
                            msg: 'Weight cannot be grater than ' +
                                (course.remainingWeight + c.categoryWeight)
                                    .toString(),
                            context: context).show();
                        return 'Weight cannot be grater than ' +
                            (course.remainingWeight + c.categoryWeight).toString();
                      } else {
                        return null;
                      }
                    },
                    controller: categoryWeightController,
                    initialValue: initialWeight,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "ex 25",
                      labelText: 'Weight',
                    ),
                    onTap: () {
                      if (categoryWeightController == null) {
                        categoryWeightController = TextEditingController();
                        categoryWeightController.text = initialWeight;
                        initialWeight = null;
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: dropLowest,
                  activeColor: Theme
                      .of(context)
                      .accentColor,
                  onChanged: (updateChecked) {
                    setState(() {
                      dropLowest = updateChecked;
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
            ),

            getExtraFormFields(),
          ]),
        )
    );


    SizedBox confirmButton = SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0)),
        onPressed: () async {
          if (categoryWeightController == null) {
            categoryWeightController = TextEditingController();
            categoryWeightController.text = initialWeight;
            initialWeight = null;
          }

          if (numberDroppedController == null) {
            numberDroppedController = TextEditingController();
            numberDroppedController.text = initialnumberDropped;
            initialnumberDropped = null;
          }

          if(_formKey.currentState.validate()) {
            await categoryService.updateCategory(
                addedCategory,
                categoryWeightController.text,
                c.categoryWeight,
                dropLowest,
                numberDroppedController.text,
                equalWeights,
                c.id);
            await calculator.calcCategoryGrade(term.termID, course.id, c.id);

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

    return CustomDialog(form: form, button: confirmButton, title: "Category Options", context: context).show();

  }

  Widget getExtraFormFields(){
    if(!dropLowest) return Container();

    return Column(
      children: [
        SizedBox(
          width: 155,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: numberDroppedController,
            initialValue: initialnumberDropped,
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
            onTap: () {
              if (numberDroppedController == null) {
                numberDroppedController = TextEditingController();
                numberDroppedController.text = initialnumberDropped;
                initialnumberDropped = null;
                setState(() {});
              }
            },
            decoration: const InputDecoration(
              hintText: "ex 2",
              labelText: 'Number of dropped assessments.',
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }

}
