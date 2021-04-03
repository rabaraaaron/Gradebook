import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/category_service.dart';
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
  bool dropLowest;
  Category c;
  String addedCategory;
  String initialWeight;
  bool equalWeights;
  Course course;

  CategoryService categoryService;

  _CategoryOptions(Category c, Term term, Course course) {


    this.course = course;
    this.c = c;
    categoryService = new CategoryService(term.termID, course.id);
    addedCategory = c.categoryName;
    initialWeight = c.categoryWeight.toString();
    equalWeights = c.equalWeights;
    if (c.dropLowestScore == null) {
      dropLowest = false;
    } else {
      dropLowest = c.dropLowestScore;
    }
  }

  TextEditingController categoryWeightController;


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

    SizedBox confirmButton =         SizedBox(
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
          //TODO: Update the category info in the database
          // Get updated category name with addedCategory
          // Get updated weight with categoryWeightController.text
          // Get updated drop lowest bool with dropLowest
          if(_formKey.currentState.validate()) {
            await categoryService.updateCategory(addedCategory,
                categoryWeightController.text, c.categoryWeight, dropLowest,
                equalWeights, c.id);
            await categoryService.calculateGrade(c.id);
            Navigator.pop(context);
          }
        },
        child: Text(
          "Confirm",
          style: Theme.of(context).textTheme.headline2,
        ),
        color: Theme.of(context).primaryColor,
      ),
    );

    return AlertDialog(
      title: Column(children: [
        Text(
          "Category Options",
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
          validator: (value){
            if(value == null) {
              MessageBar(context: context,
                  msg: "Please select one form the list of categories.",
                  title: "Missing selection").show();
              return 'field required';
            } else {return null;}
          },
            style: Theme.of(context).textTheme.headline3,
            hint: Text(
              "Select Category",
              style: Theme.of(context).textTheme.headline3,
            ),
            value: addedCategory,
            items: listOfCategories,
            onChanged: (val) {
              setState(() {
                addedCategory = val;
              });
            },
            isExpanded: true,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              MessageBar(
                  context: context,
                  title: 'Missing field value',
                  msg: 'Please enter a weight value',
              ).show();
              return 'Please enter weight value';
            } else if(double.parse(value) > course.remainingWeight + c.categoryWeight){
              MessageBar(
                title: "invalid weight value",
                msg: 'Weight cannot be grater than ' + (course.remainingWeight + c.categoryWeight).toString(),
                context: context).show();
              return 'Weight cannot be grater than ' + (course.remainingWeight + c.categoryWeight).toString();
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
        Row(
            children: [
              Switch(
                value: dropLowest,
                activeColor: Theme.of(context).accentColor,
                onChanged: (updateChecked) {
                  setState(() {
                    dropLowest = updateChecked;
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
          )
      ),
      width: 100,
      height: 155,
        ),
      actions: [confirmButton],
    );
  }

}
