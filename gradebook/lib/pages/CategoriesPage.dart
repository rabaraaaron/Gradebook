import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:gradebook/utils/menuDrawer.dart';

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






  List<ExpansionTile> expansionList = [];


  @override
  Widget build(BuildContext context) {

    FlatButton addButton = FlatButton(
      color: Colors.blue,
      child: Text(
        "Add Item",
        style: Theme.of(context).textTheme.headline1,
      ),
    );

    ExpansionTile e1 = ExpansionTile(
      backgroundColor: Colors.grey[800],
      title: Text(
          "Assignments 25%",
        style: Theme.of(context).textTheme.headline2,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: addButton,
              ),
              Text("Assignment 1", textScaleFactor: 1.5,),
              Text("Assignment 2", textScaleFactor: 1.5,),
              Text("Assignment 3", textScaleFactor: 1.5,),
            ],),
        )
      ],
    );

    ExpansionTile e2 = ExpansionTile(
      backgroundColor: Colors.grey[800],
      title: Text(
        "Exams 25%",
        style: Theme.of(context).textTheme.headline2,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: addButton,
              ),
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
    );

    ExpansionTile e3 = ExpansionTile(
      backgroundColor: Colors.grey[800],
      //expandedCrossAxisAlignment,
      title: Text(
        "Project 10%",
        style: Theme.of(context).textTheme.headline2,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: addButton,
              ),
              Text("Assignment 1", textScaleFactor: 1.5,),
              Text("Assignment 2", textScaleFactor: 1.5,),
              Text("Assignment 3", textScaleFactor: 1.5,),
            ],),
        )
      ],
    );

    ExpansionTile e4 = ExpansionTile(
      backgroundColor: Colors.grey[800],
      title: Text(
          "Quizzes 15%",
          style: Theme.of(context).textTheme.headline2,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: addButton,
              ),
              Text("Quiz 1", textScaleFactor: 1.5,),
              Text("Quiz 2", textScaleFactor: 1.5,),
              Text("Quiz 3", textScaleFactor: 1.5,),
              Text("Quiz 4", textScaleFactor: 1.5,),
            ],
          ),
        )
      ],
    );

    ExpansionTile e5 = ExpansionTile(
      backgroundColor: Colors.grey[800],
      //expandedCrossAxisAlignment,
      title: Text(
          "Homework 20%" ,
          style: Theme.of(context).textTheme.headline2,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: addButton,
              ),
              Text("HW 1", textScaleFactor: 1.5,),
              Text("HW 2", textScaleFactor: 1.5,),
              Text("HW 3", textScaleFactor: 1.5,),
            ],),
        )
      ],
    );

    ExpansionTile e6 = ExpansionTile(
      backgroundColor: Colors.grey[800],
      title: Text(
          "Other 5%",
          style: Theme.of(context).textTheme.headline2,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: addButton,
              ),
              Text("test ", textScaleFactor: 1.5,),
              Text("test ", textScaleFactor: 1.5,),
              Text("test ", textScaleFactor: 1.5,),
              Text(" ", textScaleFactor: 1.5,),
            ],
          ),
        )
      ],
    );

    expansionList.clear();

    expansionList.add(e1);
    expansionList.add(e2);
    expansionList.add(e3);
    expansionList.add(e4);
    expansionList.add(e5);
    expansionList.add(e6);

    return Scaffold(
      key: scaffoldKey,
      drawer: MenuDrawer(),
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
                iconWidget: Icon(Icons.more_vert, color: Colors.white, size: 35,),
                onTap: () => null,
              ),
              IconSlideAction(
                color: Colors.transparent,
                closeOnTap: true,
                iconWidget: Icon(Icons.delete, color: Colors.white, size: 35,),
              )
            ],
            child: expansionList[index],
          ),
        ),
      )
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
