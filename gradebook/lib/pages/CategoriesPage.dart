import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/validator_service.dart';
import 'package:gradebook/utils/MyAppTheme.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';

class CategoriesPageWrap extends StatefulWidget {
  Term term;
  Course course;

  CategoriesPageWrap({Key key, @required this.term, this.course})
      : super(key: key);

  @override
  _CategoriesPageWrapState createState() =>
      _CategoriesPageWrapState(term, course);
}

class _CategoriesPageWrapState extends State<CategoriesPageWrap> {
  Term term;
  Course course;

  @override
  _CategoriesPageWrapState(Term term, Course course) {
    this.term = term;
    this.course = course;
  }

  @override
  Widget build(BuildContext) {
    return StreamProvider<List<Category>>.value(
      value: CategoryService(term.termID, course.id).categories,
      child: CategoriesPage(term: term, course: course),
    );
  }
}

class CategoriesPage extends StatefulWidget {
  Term term;
  Course course;
  CategoriesPage({Key key, @required this.term, this.course}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState(term, course);
}

class _CategoriesPageState extends State<CategoriesPage> {
  Map categoriesData = new HashMap<String, List<String>>();
  final GlobalKey scaffoldKey = new GlobalKey();
  final SlidableController slidableController = new SlidableController();
  int weight;
  Term term;
  Course course;

  @override
  _CategoriesPageState(Term term, Course course) {
    this.course = course;
    this.term = term;
  }

  @override
  Widget build(BuildContext context) {
    CategoryService catServ = new CategoryService(term.termID, course.id);
    RaisedButton addButton = RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      color: Colors.blue,
      child: Text(
        "Add Item",
        style: Theme.of(context).textTheme.headline6,
      ),
    );

    final List categories = Provider.of<List<Category>>(context);
    Widget listView;

    if(Provider.of<List<Category>>(context) != null){
      listView = ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
            indent: 25.0,
            endIndent: 25.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              child: Slidable(
                controller: slidableController,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: .2,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    color: Colors.transparent,
                    closeOnTap: true,
                    iconWidget: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).dividerColor,
                      size: 35,
                    ),
                    onTap: () => null,
                  ),
                  IconSlideAction(
                    color: Colors.transparent,
                    closeOnTap: true,
                    iconWidget: Icon(
                      Icons.delete,
                      color: Theme.of(context).dividerColor,
                      size: 35,
                    ),
                    onTap: ()async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteConfirmation(
                              catServ, categories, index);
                        },
                      );
                    },
                  )
                ],
                child:
                // expansionList[index]
                StreamProvider.value(
                    value: AssessmentService(
                        term.termID, course.id, categories[index].id)
                        .assessments,
                    child: AssessmentTile(
                      termID: term.termID,
                      courseID: course.id,
                      cat: categories[index],
                    )),
              ),
            );
          }
      );
    } else{
      listView = Container();
    }


    return Scaffold(
        key: scaffoldKey,
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: Text(
            "${course.name}",
            style: Theme.of(context).textTheme.headline1,
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => Center(
              child: IconButton(
                  icon: Icon(
                    Icons.menu_sharp,
                    color: Colors.white,
                  ),
                  iconSize: 30,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }),
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                iconSize: 35,
                color: Colors.white,
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        NewCategoriesPopUp(categories, term, course),
                  );
                  setState(() {});
                })
          ],
        ),
        body: listView,
    );
  }
}

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
  bool checked = false;
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
                    fontSize: 25,
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
                      value: checked,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (updateChecked) {
                        setState(() {
                          checked = updateChecked;
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
                        await categoryService.addCategory(
                            addedCategory, categoryWeightController.text);
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

class AssessmentTile extends StatefulWidget {
  String termID;
  String courseID;
  Category cat;

  AssessmentTile({this.termID, this.courseID, this.cat});

  @override
  _AssessmentTileState createState() =>
      _AssessmentTileState(termID, courseID, cat);
}

class _AssessmentTileState extends State<AssessmentTile> {
  String termID;
  String courseID;
  Category cat;

  _AssessmentTileState(String tID, String cID, Category c) {
    this.termID = tID;
    this.courseID = cID;
    this.cat = c;
  }

  @override
  Widget build(BuildContext context) {
    AssessmentService assServ = new AssessmentService(termID, courseID, cat.id);
    final name = TextEditingController();
    final assessments = Provider.of<List<Assessment>>(context);
    double totalPoints = 0;
    double yourPoints = 0;
    if(Provider.of<List<Assessment>>(context) != null) {
      for (int i = 0; i < assessments.length; i++) {
        totalPoints += assessments[i].totalPoints;
        yourPoints += assessments[i].yourPoints;
      }
    }

    return Container(
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "${cat.categoryName}",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            //SizedBox(width: 20,),
            Text(
              "${cat.categoryWeight}%",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
        children: [
          Center(
            child: Text(
              "$yourPoints" + "/" + "$totalPoints",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Center(
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
              color: Theme.of(context).primaryColor,
              child: Text("Add Assessment", style: Theme.of(context).textTheme.headline2,),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      newAssessmentPopUp(context, termID, courseID, cat.id),
                );
                setState(() { });
              },
            ),
          ),
          AssessmentList(
            termID: termID,
            courseID: courseID,
            categoryID: cat.id,
          )
        ],
      ),
    );
  }
}

class AssessmentList extends StatefulWidget {
  String termID, courseID, categoryID;

  AssessmentList({Key key, this.termID, this.courseID, this.categoryID})
      : super(key: key);
  @override
  _AssessmentListState createState() => _AssessmentListState();
}

class _AssessmentListState extends State<AssessmentList> {

  String termID, courseID, categoryID;
  final SlidableController slidableController = new SlidableController();
  _AssessmentListState({this.termID, this.courseID, this.categoryID});



  @override
  Widget build(BuildContext context) {
    AssessmentService assServ = new AssessmentService(termID, courseID, categoryID);
    final assessments = Provider.of<List<Assessment>>(context);
    List<Widget> entries = [];
    if (Provider.of<List<Assessment>>(context) != null) {
      assessments.forEach((element) {
        entries.add(
            Slidable(
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: .2,
              secondaryActions: <Widget>[
                IconSlideAction(
                  color: Colors.transparent,
                  closeOnTap: true,
                  iconWidget: Icon(
                    Icons.add_alert,
                    color: Theme.of(context).dividerColor,
                    size: 35,
                  ),
                  onTap: () => null,
                ),
                IconSlideAction(
                  color: Colors.transparent,
                  closeOnTap: true,
                  iconWidget: Icon(
                    Icons.delete,
                    color: Theme.of(context).dividerColor,
                    size: 35,
                  ),
                  onTap: () async {
                    await assServ.deleteAssessment(element.id);
                  },
                )
              ],
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                      flex: 8,
                      child: TextFormField(
                        initialValue: element.name,
                        style: Theme.of(context).textTheme.headline5,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (itemName) {
                          //TODO: Push changed name to database
                          print(itemName);
                        },
                      )
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: "${element.yourPoints}",
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4)
                              ],
                              style: Theme.of(context).textTheme.headline5,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              onFieldSubmitted: (yourScore) {
                                if (double.tryParse(yourScore) != null) {
                                  print("Good change");
                                  //TODO: Push change to database
                                }
                                setState(() {
                                  //This is so that incorrect inputs that are not
                                  //pushed to the server will revert to the previous
                                  //version
                                });
                                print(yourScore);
                              },
                            ),
                          ),
                          Text("/ ", style: Theme.of(context).textTheme.headline5,),
                          Expanded(
                            child: TextFormField(
                              initialValue: "${element.totalPoints}",
                              inputFormatters: [LengthLimitingTextInputFormatter(4)],
                              style: Theme.of(context).textTheme.headline5,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              onFieldSubmitted: (totalPoints) {
                                if (double.tryParse(totalPoints) != null) {
                                  print("Good change");
                                  //TODO: Push change to database
                                }
                                setState(() {
                                  //This is so that incorrect inputs that are not
                                  //pushed to the server will revert to the previous
                                  //version
                                });
                              },
                            ),
                          )
                        ]
                    ),
                  ),

                ],
              ),
            ));
      });
    }
    return Column(children: entries);
  }
}


Widget newAssessmentPopUp(
    BuildContext context, String termID, courseID, categoryID) {
  AssessmentService assServ =
      new AssessmentService(termID, courseID, categoryID);

  final name = TextEditingController();
  final totalPoints = TextEditingController();
  final yourPoints = TextEditingController();

  List<DropdownMenuItem> listOfYears = [];
  for (var i = 2015; i <= DateTime.now().year; i++) {
    listOfYears.insert(0, DropdownMenuItem(child: Text("$i")));
  }

  FocusScopeNode focusScopeNode = FocusScopeNode();
  void handleSubmitted(){
    focusScopeNode.nextFocus();
  }

  return AlertDialog(
      content: SizedBox(
        child: FocusScope(
          node: focusScopeNode,
          child: Column(children: [
            Text(
              "Add new Item",
              style: Theme.of(context).textTheme.headline4,
            ),
            Divider(color: Theme.of(context).dividerColor,),
            TextFormField(
            controller: name,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            onEditingComplete: handleSubmitted,
            decoration: const InputDecoration(
              hintText: "ex Quiz 1",
              labelText: 'Assessment Title',
            ),
          ),
            TextFormField(
              controller: totalPoints,
              inputFormatters: [LengthLimitingTextInputFormatter(4)],
              onEditingComplete: handleSubmitted,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "ex 100",
                labelText: 'Total Points',
              ),
            ),
            TextFormField(
              controller: yourPoints,
              inputFormatters: [LengthLimitingTextInputFormatter(4)],
              onEditingComplete: handleSubmitted,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "ex 89.8",
                labelText: 'Points Earned',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: SizedBox(
                  width: 300,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                      ),
                      onPressed: () async {
                        if(name.text != "" && totalPoints.text != "" &&
                            yourPoints.text != ""){
                          await assServ.addAssessment(
                              name.text, totalPoints.text, yourPoints.text);
                          Navigator.pop(context);
                        } else if(name.text == ""){
                          //TODO: alert the user of invalid input
                        } else{
                          await assServ.addAssessment(
                              name.text, "0", "0");
                          Navigator.pop(context);
                        }
                        },
                      child: Text(
                        "Add",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    color: Theme.of(context).primaryColor,
                  )
              ),
          ),
        ]),
        ),
        width: 150,
        height: 285,
      )
  );
}

class DeleteConfirmation extends StatelessWidget{
  CategoryService catServ;
  List<Category> categories;
  int index;

  DeleteConfirmation(CategoryService catService, List<Category> cat, int i){
    catServ = catService;
    categories = cat;
    index = i;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Delete Category",
              style: Theme.of(context).textTheme.headline4,
            ),
            Divider(color: Theme.of(context).dividerColor,),
            Text(
              "Are you sure you want to delete the ${categories[index].categoryName} category?",
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.red,
              height: 40,
              onPressed: () {
                catServ.deleteCategory(categories[index].id);
                Navigator.pop(context);
              },
              child: Text(
                "Delete",
                textScaleFactor: 1.25,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ]
      ),

    );
  }

}
