import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/category_service.dart';

// ignore: must_be_immutable
class NewCategoriesPopUp extends StatefulWidget {
  List<Category> c = [];
  Term term;
  Course course;

  NewCategoriesPopUp(List<Category> categories, Term term, Course course) {
    this.c = categories;
    this.course = course;
    this.term = term;
  }
  @override
  _NewCategoriesPopUpState createState() =>
      _NewCategoriesPopUpState(c, term, course);
}

class _NewCategoriesPopUpState extends State<NewCategoriesPopUp> {
  List<Category> c = [];
  // ignore: non_constant_identifier_names
  bool dropLowest_isChecked = false;
  String addedCategory;

  CategoryService categoryService;

  _NewCategoriesPopUpState(
      List<Category> categories, Term term, Course course) {
    c = categories;
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
        content: SizedBox(
          child: Form(
              child: Column(children: [
                Text(
                  "Add new Category",
                  style: TextStyle(
                    fontSize: 27.5,
                    color: Theme.of(context).dividerColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Divider(color: Theme.of(context).dividerColor,),
                DropdownButtonFormField(
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
                  controller: categoryWeightController,
                  keyboardType: TextInputType.number,
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
                Expanded(
                  child: SizedBox(
                    width: 300,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0)),
                      onPressed: () async {

                        print(addedCategory);
                        //todo: -------------------------------------------------------------------------------
                        //todo: add GUI thing to switch category from equally weighted to point-based weight.
                        var equalWeights = false;
                        //todo: -------------------------------------------------------------------------------
                        await categoryService.addCategory(
                            addedCategory, categoryWeightController.text, dropLowest_isChecked, equalWeights);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Add",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ])),
          width: 100,
          height: 245,
        ));
  }
}