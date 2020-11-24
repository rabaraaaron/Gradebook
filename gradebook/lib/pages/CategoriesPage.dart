import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';

class CategoriesPageWrap extends StatefulWidget {
  String termID;
  String courseID;

  CategoriesPageWrap({Key key, @required this.termID, this.courseID})
      : super(key: key);

  @override
  _CategoriesPageWrapState createState() =>
      _CategoriesPageWrapState(termID, courseID);
}

class _CategoriesPageWrapState extends State<CategoriesPageWrap> {
  String termID;
  String courseID;

  @override
  _CategoriesPageWrapState(String termID, String courseID) {
    this.termID = termID;
    this.courseID = courseID;
  }

  @override
  Widget build(BuildContext) {
    return StreamProvider<List<Category>>.value(
      value: CategoryService(termID, courseID).categories,
      child: CategoriesPage(termID: termID, courseID: courseID),
    );
  }
}

class CategoriesPage extends StatefulWidget {
  String termID;
  String courseID;
  CategoriesPage({Key key, @required this.termID, this.courseID})
      : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState(termID, courseID);
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<String> categoriesStrings = [
    "Assignments",
    "Homework",
    "Quizzes",
    "Exams",
    "Other"
  ];
  Map categoriesData = new HashMap<String, List<String>>();
  final GlobalKey scaffoldKey = new GlobalKey();
  final SlidableController slidableController = new SlidableController();
  int weight;
  String termID;
  String courseID;

  @override
  _CategoriesPageState(String termID, String courseID) {
    this.courseID = courseID;
    this.termID = termID;
  }

  @override
  Widget build(BuildContext context) {
    RaisedButton addButton = RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      color: Colors.blue,
      child: Text(
        "Add Item",
        style: Theme.of(context).textTheme.headline1,
      ),
    );

    List<ExpansionTile> expansionList = [];

    final List categories = Provider.of<List<Category>>(context);

    for (var l = 0; l < categories.length; l++) {
      expansionList.add(ExpansionTile(
        backgroundColor: Colors.grey[800],
        title: Text(
          "${categories[l].categoryName}",
          style: Theme.of(context).textTheme.headline2,
        ),
        children: [
          Container(
              // padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: StreamProvider.value(
                  value:
                      AssessmentService(termID, courseID, categories[l].id).assessments,
                  child:
                  AssessmentList(termID: termID, courseID: courseID, categoryID: categories[l].id,))
              //  Column(
              //    children: [
              //      addButton,
              //      Text("test            18/28"),
              //      Text("test            18/28"),
              //      Text("test            18/28"),
              //      Text("test            18/28"),
              //      Text("test            18/28"),
              //      Text("test            18/28"),
              //      //Text("Assignment 1", textScaleFactor: 1.5,)
              //    ],),
              )
        ],
      ));
    }

    return Scaffold(
        key: scaffoldKey,
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: FutureBuilder(
              future: CourseService(termID).courseRef.doc(courseID).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                Map<String, dynamic> data = snapshot.data.data();
                return Text(
                  "${data['name']}",
                  style: Theme.of(context).textTheme.headline1,
                );
              }),
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
                        NewCategoriesPopUp(categories, termID, courseID),
                  );
                  setState(() {});
                })
          ],
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
            indent: 25.0,
            endIndent: 25.0,
          ),
          itemCount: expansionList.length,
          itemBuilder: (context, index) => Container(
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
                    color: Colors.white,
                    size: 35,
                  ),
                  onTap: () => null,
                ),
                IconSlideAction(
                  color: Colors.transparent,
                  closeOnTap: true,
                  iconWidget: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 35,
                  ),
                )
              ],
              child: StreamProvider.value(value: AssessmentService(termID, courseID, categories[index].id).assessments,
                  child: AssessmentTile(termID, courseID, categories[index])),
              // Text(
              //   "${expansionList[index].}",
              //   style: Theme.of(context).textTheme.headline2,
              // ),
            ),
          ),
        ));
  }
}

class NewCategoriesPopUp extends StatefulWidget {
  List<Category> c = [];
  String termID;
  String courseID;

  NewCategoriesPopUp(
      List<Category> categories, String termID, String courseID) {
    this.c = categories;
    this.courseID = courseID;
    this.termID = termID;
  }
  @override
  _NewCategoriesPopUpState createState() =>
      _NewCategoriesPopUpState(c, termID, courseID);
}

class _NewCategoriesPopUpState extends State<NewCategoriesPopUp> {
  List<Category> c = [];
  bool checked = false;

  CategoryService categoryService;

  _NewCategoriesPopUpState(
      List<Category> categories, String termID, String courseID) {
    c = categories;
    categoryService = new CategoryService(termID, courseID);
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController categoryTitleController = new TextEditingController();
    TextEditingController categoryWeightController =
        new TextEditingController();

    return AlertDialog(
        title: Text(
          "Add a new Category",
          style: Theme.of(context).textTheme.headline2,
        ),
        content: SizedBox(
          child: Form(
              child: Column(children: [
            TextFormField(
              controller: categoryTitleController,
              decoration: const InputDecoration(
                hintText: "ex Project",
                labelText: 'Category',
              ),
            ),
            TextFormField(
              controller: categoryWeightController,
              decoration: const InputDecoration(
                hintText: "ex 25",
                labelText: 'Weight',
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: checked,
                  onChanged: (updateChecked) {
                    setState(() {
                      checked = updateChecked;
                    });
                  },
                ),
                Text("Drop Lowest Score?"),
              ],
            ),
            RaisedButton(
                onPressed: () async {
                  await categoryService.addCategory(
                      categoryTitleController.text,
                      categoryWeightController.text);
                  Navigator.pop(context);
                },
                child: Text("Add"))
          ])),
          width: 100,
          height: 225,
        ));
  }
}

Widget AssessmentTile(termID, courseID, Category cat){
  return Container(
    child: ExpansionTile(
    title: Row(children:[Text("${cat.categoryName}"),
        ], ),
    children: [
      AssessmentList(termID: termID,courseID: courseID, categoryID: cat.id,)
    ],
    ),
  );
}


class AssessmentList extends StatefulWidget {
  String termID, courseID, categoryID;

  AssessmentList({Key key, this.termID,this.courseID,this.categoryID}) : super(key:key);
  @override
  _AssessmentListState createState() => _AssessmentListState();
}

class _AssessmentListState extends State<AssessmentList> {
  String termID, courseID, categoryID;

  _AssessmentListState({this.termID,this.courseID,this.categoryID});


  @override
  Widget build(BuildContext context) {
    final assessments = Provider.of<List<Assessment>>(context);

    return Column(
      children: [
        newAssessment(termID, courseID, categoryID),
        ListView.builder(
          itemCount: assessments.length ?? 0,
            itemBuilder: (context, index) => (Container(
                    child: Row(
                  children: [Expanded(child: Text("${assessments[index].name}"))],
                )))),
      ],
    );
  }


}

Widget newAssessment(termID, courseID, categoryID){
  AssessmentService assServ = new AssessmentService(termID, courseID, categoryID);
  final name = TextEditingController();
  final totalPoints = TextEditingController();
  final yourPoints = TextEditingController();

  return Form(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextFormField(controller: name,
          decoration: const InputDecoration(
            hintText: "ex Quiz 1",
            labelText: 'Name',
          ),),
        TextFormField(controller: totalPoints,
          decoration: const InputDecoration(
            labelText: 'Total Points',
          ),),
        TextFormField(controller: yourPoints,
          decoration: const InputDecoration(
            labelText: 'Points Earned',
          ),),
        RaisedButton(
          onPressed: () async{
            await assServ.addAssessment(name, totalPoints, yourPoints);
            },
          child: Icon(Icons.add),
        )
      ],
    ),
  );
}