import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';

class CategoriesPageWrap extends StatefulWidget {
  String termID;
  String courseID;

  CategoriesPageWrap({Key key, @required this.termID, this.courseID}) : super(key: key);


  @override
  _CategoriesPageWrapState createState() => _CategoriesPageWrapState(termID, courseID);
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
  CategoriesPage({Key key, @required this.termID, this.courseID}) : super(key: key);

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
        title: Container(
          child: Row(
            children: [
              Expanded(
                child: Text("${categories[l].categoryName}",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline2,
                ),
              ),
              //SizedBox(width: 20,),
              Text("${categories[l].categoryWeight}%",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline2,
              ),
            ],
          ),
        ),
        children: [
          Container(
           // padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                addButton,
                Text("test            18/28"),
                Text("test            18/28"),
                Text("test            18/28"),
                Text("test            18/28"),
                Text("test            18/28"),
                Text("test            18/28"),
                //Text("Assignment 1", textScaleFactor: 1.5,)
              ],),
          )
        ],
      ));
    }

    return Scaffold(
        key: scaffoldKey,
        drawer: MenuDrawer(),
        appBar: AppBar(
          title:
          FutureBuilder(
              future: CourseService(termID)
                  .courseRef
                  .doc(courseID)
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                Map<String, dynamic> data = snapshot.data.data();
                return Text("${data['name']}",style: Theme.of(context).textTheme.headline1,);
              }


          ),
          centerTitle: true,
          leading:
          Builder(
            builder: (context) =>
                Center(
                  child: IconButton(
                      icon: Icon(Icons.menu_sharp, color: Colors.white,),
                      iconSize: 30,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      }),
                ),
          ),
          actions: [
            IconButton(icon: Icon(Icons.add), iconSize: 35, color: Colors.white,
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        NewCategoriesPopUp( categories, termID, courseID),
                  );
                  setState(() {});
                }
            )
          ],
        ),

        body: ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(
                color: Colors.white,
                indent: 25.0,
                endIndent: 25.0,
              ),
          itemCount: expansionList.length,
          itemBuilder: (context, index) =>
              Container(
                child: Slidable(
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: .2,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.transparent,
                      closeOnTap: true,
                      iconWidget: Icon(
                        Icons.more_vert, color: Colors.white, size: 35,),
                      onTap: () => null,
                    ),
                    IconSlideAction(
                      color: Colors.transparent,
                      closeOnTap: true,
                      iconWidget: Icon(
                        Icons.delete, color: Colors.white, size: 35,),
                    )
                  ],
                  child: expansionList[index],
                  // Text(
                  //   "${expansionList[index].}",
                  //   style: Theme.of(context).textTheme.headline2,
                  // ),
                ),
              ),
        )
    );
  }
}


class NewCategoriesPopUp extends StatefulWidget {
  List<Category> c = [];
  String termID;
  String courseID;


  NewCategoriesPopUp(List<Category> categories, String termID, String courseID){
    this.c = categories;
    this.courseID = courseID;
    this.termID = termID;
  }
  @override
  _NewCategoriesPopUpState createState() => _NewCategoriesPopUpState(c, termID, courseID);
}

class _NewCategoriesPopUpState extends State<NewCategoriesPopUp> {
  List<Category> c = [];
  bool checked = false;

  CategoryService categoryService;


  _NewCategoriesPopUpState(List<Category> categories, String termID, String courseID){
    c = categories;
    categoryService = new CategoryService(termID, courseID);
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController categoryTitleController = new TextEditingController();
    TextEditingController categoryWeightController = new TextEditingController();

    return AlertDialog(
        title: Text("Add a new Category", style: Theme
            .of(context)
            .textTheme
            .headline2,),
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
                          await categoryService.addCategory(categoryTitleController.text, categoryWeightController.text);
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
        )
    );
  }
}



