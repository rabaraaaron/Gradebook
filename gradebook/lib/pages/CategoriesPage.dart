import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
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
    RaisedButton addButton = RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      color: Colors.blue,
      child: Text(
        "Add Item",
        style: Theme.of(context).textTheme.headline6,
      ),
    );

    // List<ExpansionTile> expansionList = [];

    //
    final List categories = Provider.of<List<Category>>(context);
    //
    // for (var index = 0; index < categories.length; index++) {
    //
    //   expansionList.add(ExpansionTile(
    //     backgroundColor: Colors.grey[800],
    //     title: Container(
    //       child: Row(
    //         children: [
    //           Expanded(
    //             child: Text("${categories[index].categoryName}",
    //               style: Theme
    //                   .of(context)
    //                   .textTheme
    //                   .headline2,
    //             ),
    //           ),
    //           //SizedBox(width: 20,),
    //           Text("${categories[index].categoryWeight}%",
    //             style: Theme
    //                 .of(context)
    //                 .textTheme
    //                 .headline2,
    //           ),
    //         ],
    //       ),
    //     ),
    //     children: [
    //
    //       // StreamProvider.value(
    //       //     value:
    //       //         AssessmentService(term.termID, course.id, categories[index].id).assessments,
    //       //     child:
    //       //     AssessmentList(termID: term.termID, courseID: course.id, categoryID: categories[index].id,))
    //     ],
    //   ));
    // }

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
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
            indent: 25.0,
            endIndent: 25.0,
          ),
          itemCount: categories.length,
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
              child:
                  // expansionList[index]
                  StreamProvider.value(
                      value: AssessmentService(
                              term.termID, course.id, categories[index].id)
                          .assessments,
                      child: AssessmentTile(
                          term.termID, course.id, categories[index])),
            ),
          ),
        ));
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


  CategoryService categoryService;

  _NewCategoriesPopUpState(
      List<Category> categories, Term term, Course course) {
    c = categories;
    categoryService = new CategoryService(term.termID, course.id);
  }
  @override
  Widget build(BuildContext context) {
    //TextEditingController categoryTitleController = new TextEditingController();
    TextEditingController categoryWeightController = new TextEditingController();
    List<String> categoriesStrings = [
      "Other",
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
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            value: categoriesStrings[i],
          ));
    }
    String addedCategory;
    return AlertDialog(
        title: Text(
          "Add a new Category",
          style: Theme.of(context).textTheme.headline2,
        ),
        content: SizedBox(
          child: Form(
              child: Column(children: [
                DropdownButtonFormField(
                  hint: Text(
                    "Select Category",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  value: addedCategory,
                  items: listOfCategories,
                  onChanged: (newCategory) {
                    setState(() {
                      addedCategory = newCategory;
                    });
                  },
                  isExpanded: true,
                ),
                // TextFormField(
                //   controller: categoryTitleController,
                //   decoration: const InputDecoration(
                //     hintText: "ex Project",
                //     labelText: 'Category',
                //   ),
                // ),
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
                      onChanged: (updateChecked){
                        setState(() {
                          checked = updateChecked;
                        });
                      },

                    ),
                    Text("Drop Lowest Score?"),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: 300,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                        onPressed: () async{
                          await categoryService.addCategory(addedCategory, categoryWeightController.text);
                          Navigator.pop(context);
                        },
                        child: Text("Add",
                            style: Theme.of(context).textTheme.headline6,)
                    ),
                  ),
                )
              ])
          ),
          width: 100,
          height: 225,
        ));
  }
}

Widget AssessmentTile(String termID, String courseID, Category cat) {
  return Container(
    child: ExpansionTile(
      title: Row(
        children: [
          Expanded(child: Text("${cat.categoryName}",style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25, ))),
          Text("${cat.categoryWeight}%",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25, )
          ),
        ],
      ),
      children: [
        // Text('a')
        AssessmentList(
          termID: termID,
          courseID: courseID,
          categoryID: cat.id,
        )
      ],
    ),
  );
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

  _AssessmentListState({this.termID, this.courseID, this.categoryID});

  @override
  Widget build(BuildContext context) {

    final assessments = Provider.of<List<Assessment>>(context);
    // print ("HERERERERE!" + assessments[0].toString() );

    return Column(
      children: [
        newAssessment(termID, courseID, categoryID),

        Text("Test 2"),
        Text("test 1")
        // ListView.builder(
        //     itemCount: assessments.length,
        //     itemBuilder: (context, index) => (Row(
        //           children: [
        //             Text("${assessments[index].id}")
        //           ],
        //         ))),
      ],
    );
  }
}

Widget newAssessment(termID, courseID, categoryID) {
  AssessmentService assServ =
      new AssessmentService(termID, courseID, categoryID);
  final name = TextEditingController();
  final totalPoints = TextEditingController();
  final yourPoints = TextEditingController();
  return Text("Input");
  // return Form(
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       TextFormField(controller: name,
  //         decoration: const InputDecoration(
  //           hintText: "ex Quiz 1",
  //           labelText: 'Name',
  //         ),),
  //       TextFormField(controller: totalPoints,
  //         decoration: const InputDecoration(
  //           labelText: 'Total Points',
  //         ),),
  //       TextFormField(controller: yourPoints,
  //         decoration: const InputDecoration(
  //           labelText: 'Points Earned',
  //         ),),
  //       RaisedButton(
  //         onPressed: () async{
  //           await assServ.addAssessment(name, totalPoints, yourPoints);
  //           },
  //         child: Icon(Icons.add),
  //       )
  //     ],
  //   ),
  // );
}
