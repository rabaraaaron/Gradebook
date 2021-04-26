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
  bool isManuallyEntered = false;
  Course course;
  Form form;
  FocusScopeNode focusScopeNode = FocusScopeNode();
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
    //TODO: add isManuallyEntered into the database
    // isManuallyEntered = c.isManuallyEntered;
    if (c.dropLowestScore == null) {
      dropLowest = false;
    } else {
      dropLowest = c.dropLowestScore;
    }

    if(c.equalWeights){
      double x = ((c.gradePercentAsDecimal / c.categoryWeight)* 100);
      if(x % 1 == 0) {
        catPercentController.text = x.toInt().toString();
      } else {
        catPercentController.text = ((c.gradePercentAsDecimal / c.categoryWeight) * 100)
            .toStringAsFixed(2);
      }

    } else {
      if(double.parse(c.total) > 0) {
        catPercentController.text = c.getFormattedNumber(
            (double.parse(c.earned) / double.parse(c.total)) * 100);
      } else {
        catPercentController.text = c.getFormattedNumber(0);
      }

    }
  }

  TextEditingController categoryWeightController,
      numberDroppedController;
  TextEditingController catPercentController = TextEditingController();


  void handleSubmitted() {
    focusScopeNode.nextFocus();
  }

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
            initialValue: initialWeight,
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
    );
    SizedBox sizedBox = SizedBox(
      width: 155,
      child: TextFormField(
        textAlign: TextAlign.center,
        initialValue: initialnumberDropped,
        controller: numberDroppedController,
        keyboardType: TextInputType.number,
        onEditingComplete: handleSubmitted,
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
    Column col;

    if(dropLowest){
      col = Column(
        children: [
          dropLowestSwitch,
          sizedBox,
          SizedBox(height: 15,),
        ],
      );
    } else{
      col = Column(
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
              manuallyEnterSwitch,
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
              manuallyEnterSwitch,
              col,
            ]),
          )
      );
    }




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

          //TODO: push manually entered percentage
          //get this by using catPercentController.text
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
