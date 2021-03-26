import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/category_service.dart';

// ignore: must_be_immutable
class CategoryOptions extends StatefulWidget {
  Term term;
  Course course;
  Category c;

  CategoryOptions(Category c, Term term, Course course) {
    this.c = c;
    this.course = course;
    this.term = term;
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

  CategoryService categoryService;

  _CategoryOptions(Category c, Term term, Course course) {
    this.c = c;
    categoryService = new CategoryService(term.termID, course.id);
    addedCategory = c.categoryName;
    initialWeight = c.categoryWeight;
    if (c.dropLowestScore == null) {
      dropLowest = false;
    } else {
      dropLowest = c.dropLowestScore;
    }
  }

  TextEditingController categoryWeightController;

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
          "Category Options",
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).dividerColor,
            fontWeight: FontWeight.w300,
          ),
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
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
        Expanded(
          child: SizedBox(
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
                print(addedCategory);
                print(categoryWeightController.text);
                print(dropLowest);
                //TODO: Update the category info in the database
                // Get updated category name with addedCategory
                // Get updated weight with categoryWeightController.text
                // Get updated drop lowest bool with dropLowest
                await categoryService.updateCategory(addedCategory,
                    categoryWeightController.text, dropLowest, c.id);
                Navigator.pop(context);
              },
              child: Text(
                "Confirm",
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
