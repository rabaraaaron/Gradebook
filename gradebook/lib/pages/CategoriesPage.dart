import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/services/auth_service.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<String> categoriesStrings = ["Assignments", "Homework", "Quizzes", "Exams","Other"];
  Map categoriesData = new HashMap<String, List<String>>();
  final GlobalKey scaffoldKey = new GlobalKey();
  final SlidableController slidableController = new SlidableController();

  int weight = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Text("Menu", style: Theme.of(context).textTheme.headline2,)),
            ListTile(title: Text("Settings", style: Theme.of(context).textTheme.headline5,),),
            ListTile(title: Text("Membership", style: Theme.of(context).textTheme.headline5,),),
            ListTile(title: Text("Help", style: Theme.of(context).textTheme.headline5,)),
            ListTile(
              title: Text("Log Out", style: Theme.of(context).textTheme.headline5,),
              onTap: () async {

                await AuthService().signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Categories",
          style: Theme
              .of(context)
              .textTheme
              .headline1,
        ),
        centerTitle: true,
        leading:
          Builder(
            builder: (context) =>
                Center(
                  child: IconButton(
                      icon: Icon(Icons.menu_sharp, color: Colors.white,),
                      iconSize: 30,
                      onPressed: (){
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
                      newCategoriesPopUp(context, categoriesStrings),
                );
                setState(() {});
              }
          )
        ],
      ),

      body: ListView(
        children: [
          ExpansionTile(
            backgroundColor: Colors.grey[800],
            title: Text("Assignments      25%" , textScaleFactor: 2),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    FlatButton(child: Text("Add item",),),
                    Text("Assignment 1", textScaleFactor: 1.5,),
                    Text("Assignment 2", textScaleFactor: 1.5,),
                    Text("Assignment 3", textScaleFactor: 1.5,),
                ],),
              )
            ],),
          ExpansionTile(
            backgroundColor: Colors.grey[800],
            title: Text("Exams               25%", textScaleFactor: 2),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    FlatButton(child: Text("Add item",),),
                    Text("Exam 1", textScaleFactor: 1.5,),
                    Text("Exam 2", textScaleFactor: 1.5,),
                    Text("Exam 4", textScaleFactor: 1.5,),
                    Text("Exam 5", textScaleFactor: 1.5,),
                    Text("Exam 2", textScaleFactor: 1.5,),
                    Text("Exam 4", textScaleFactor: 1.5,),
                    Text("Exam 5", textScaleFactor: 1.5,),
                    Text("Exam 2", textScaleFactor: 1.5,),
                    Text("Exam 4", textScaleFactor: 1.5,),
                    Text("Exam 5", textScaleFactor: 1.5,),
                  ],
                ),
              )
          ],
          ),
          ExpansionTile(
            backgroundColor: Colors.grey[800],
            //expandedCrossAxisAlignment,
            title: Text("Project               10%" , textScaleFactor: 2),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    FlatButton(child: Text("Add item",),),
                    Text("Assignment 1", textScaleFactor: 1.5,),
                    Text("Assignment 2", textScaleFactor: 1.5,),
                    Text("Assignment 3", textScaleFactor: 1.5,),
                  ],),
              )
            ],),
          ExpansionTile(
            backgroundColor: Colors.grey[800],
            title: Text("Quizzes             15%", textScaleFactor: 2),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    FlatButton(child: Text("Add item",),),
                    Text("Quiz 1", textScaleFactor: 1.5,),
                    Text("Quiz 2", textScaleFactor: 1.5,),
                    Text("Quiz 3", textScaleFactor: 1.5,),
                    Text("Quiz 4", textScaleFactor: 1.5,),
                  ],
                ),
              )
            ],
          ),
          ExpansionTile(
            backgroundColor: Colors.grey[800],
            //expandedCrossAxisAlignment,
            title: Text("Homework        20%" , textScaleFactor: 2),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    FlatButton(child: Text("Add item",),),
                    Text("HW 1", textScaleFactor: 1.5,),
                    Text("HW 2", textScaleFactor: 1.5,),
                    Text("HW 3", textScaleFactor: 1.5,),
                  ],),
              )
            ],),
          ExpansionTile(
            backgroundColor: Colors.grey[800],
            title: Text("Other                  5%", textScaleFactor: 2),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    FlatButton(child: Text("Add item",),),
                    Text("test ", textScaleFactor: 1.5,),
                    Text("test ", textScaleFactor: 1.5,),
                    Text("test ", textScaleFactor: 1.5,),
                    Text(" ", textScaleFactor: 1.5,),
                  ],
                ),
              )
            ],
          ),
        ]
      )
        //====================================
      //   ListView.separated(
      //   separatorBuilder: (context, index) =>
      //       Divider(
      //         color: Colors.white,
      //         indent: 25.0,
      //         endIndent: 25.0,
      //       ),
      //   itemCount: categoriesStrings.length,
      //   itemBuilder: (context, index) =>
      //       Slidable(
      //         controller: slidableController,
      //         actionPane: SlidableDrawerActionPane(),
      //         actionExtentRatio: .2,
      //         secondaryActions: [
      //           IconSlideAction(
      //             color: Colors.transparent,
      //             closeOnTap: true,
      //             iconWidget: Icon(Icons.more_vert, color: Colors.white, size: 35,),
      //             onTap: () => null,
      //           ),
      //           IconSlideAction(
      //             color: Colors.transparent,
      //             closeOnTap: true,
      //             iconWidget: Icon(Icons.delete, color: Colors.white, size: 35,),
      //           )
      //         ],
      //         child: Container(
      //             width: MediaQuery
      //                 .of(context)
      //                 .size
      //                 .width,
      //             padding: EdgeInsets.all(5),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   child: Icon(
      //                       Icons.chevron_right,
      //                       size: 50,
      //                     ),
      //                   ),
      //                 Expanded(
      //                   child: GestureDetector(
      //                     onTap: () {
      //                       //Todo: make items in categories drop down
      //                     },
      //                     child: new Padding(
      //                       padding: new EdgeInsets.all(20.0),
      //                       child: Text(
      //                         "${categoriesStrings[index]}",
      //                         style: Theme
      //                             .of(context)
      //                             .textTheme
      //                             .headline2,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Text("20%", textScaleFactor: 2, style: Theme
      //                     .of(context)
      //                     .textTheme
      //                     .headline3,)
      //                 //================================================
      //               ],
      //             )
      //         ),
      //       ),
      // ),
    );
  }

  Widget newCategoriesPopUp(BuildContext c, List<String> categories) {
    TextEditingController categoryTitleController = new TextEditingController();
    TextEditingController categoryWeightController = new TextEditingController();

    return AlertDialog(
        title: Text("Add a new Category", style: Theme
            .of(c)
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
                RaisedButton(
                    onPressed: () {
                      if (int.parse(categoryWeightController.text) is int) {
                        categories.insert(0, categoryTitleController.text);
                        print(categoryWeightController.text);
                      } else {
                        print("Input is invalid");
                      }
                      Navigator.pop(c);
                    },
                    child: Text("Submit")
                )
              ])
          ),
          width: 100,
          height: 175,
        )
    );
  }
}


class Categories{
  String categoryName;
  List<String> categoryItems = new List<String>();

  Categories(String categoryName){
    this.categoryName = categoryName;
  }

  void add(String itemName){
    categoryItems.add(itemName);
  }

  void delete(String itemName){
    categoryItems.remove(itemName);
  }
}
