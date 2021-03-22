import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Grade.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'CategoriesPage.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';
import 'package:gradebook/model/Course.dart';

class TermClassesPageWrap extends StatelessWidget {
  Term term;
  TermClassesPageWrap({Key key, @required this.term}) : super(key: key);

//   @override
//   _TermClassesPageWrapState createState() => _TermClassesPageWrapState(term);
// }

// class _TermClassesPageWrapState extends State<TermClassesPageWrap> {
//   Term term;
//
//   @override
//   _TermClassesPageWrapState(Term tID) {
//     this.term = tID;
//   }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Course>>.value(
      value: CourseService(term.termID).courses,
      child: TermClassesPage(term: term),
    );
  }
}

class TermClassesPage extends StatefulWidget {
  Term term;
  TermClassesPage({Key key, @required this.term}) : super(key: key);

  @override
  _TermsPageState createState() => _TermsPageState(term);
}

class _TermsPageState extends State<TermClassesPage> {
  //final List<String> classes = ["CS 371", "CS 499", "GEOS 201", "MILS 401"];
  final SlidableController slidableController = new SlidableController();
  final GlobalKey scaffoldKey = new GlobalKey();
  Term term;

  @override
  _TermsPageState(Term tID) {
    this.term = tID;
  }

  @override
  Widget build(BuildContext context) {
    //final course = Provider.of<Course>(context);

    final classes = Provider.of<List<Course>>(context);
    Widget listView;
    //Widget test = ChangeNotifierProvider(create: (context) => Course(),);

    if (Provider.of<List<Course>>(context) != null) {
      listView = ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).dividerColor,
          indent: 25.0,
          endIndent: 25.0,
        ),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          // Grade(classes[index], term.termID);
          // print(classes[index].gradePercent);
          classes[index].updateGradeLetter(classes[index].gradePercent);
          return Column(
            children: [
              // Grade(classes[index], term.termID),
              Padding(
                padding: EdgeInsets.all(0.0),
                child: Slidable(
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: .2,
                  secondaryActions: [
                    IconSlideAction(
                      foregroundColor: Colors.transparent,
                      closeOnTap: true,
                      iconWidget: Icon(
                        Icons.more_horiz,
                        color: Theme
                            .of(context)
                            .dividerColor,

                        size: 35,
                      ),
                      onTap: () => null,
                    ),
                    IconSlideAction(
                      foregroundColor: Colors.transparent,
                      closeOnTap: true,
                      iconWidget: Icon(
                        Icons.delete,
                        color: Theme
                            .of(context)
                            .dividerColor,
                        size: 35,
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteConfirmation(term.termID, classes, index);
                          },
                        );
                      },
                    )
                  ],
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Icon(
                            Icons.computer,
                            size: 50,
                          ),
                          padding: EdgeInsets.all(10.0),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CategoriesPageWrap(
                                              term: term, course: classes[index])));
                            },
                            child: new Padding(
                              padding: new EdgeInsets.all(20.0),
                              child: Text(
                                "${classes[index].name}",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: Text("A",
                                      // "${classes[index].getGradeLetter}",
                                      textScaleFactor: 2,
                                      style: TextStyle(
                                        color: Theme.of(context).dividerColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 60,
                                child: Text( "1"
                                    // "${classes[index].gradePercent}"
                                ),

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );

        }
      );
    } else {
      listView = Container();
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text("${term.name} ${term.year}",
            style: Theme.of(context).textTheme.headline1),
        // FutureBuilder(
        //   future: TermService().termsCollection.doc(termID).get(),
        //     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        //     Map<String, dynamic> data = snapshot.data.data();
        //     return Text("${data['name']} ${data['year']}",style: Theme.of(context).textTheme.headline1,);
        //   }

        //),
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
                      newClassPopUp(context, classes, term.termID),
                );
                setState(() {});
              }),
        ],
      ),
      body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity > 0) {
              Navigator.pop(context);
            }
          },
          child: listView),
    );
  }
}

class newClassPopUp extends StatefulWidget {
  BuildContext context;
  List<Course> terms;
  String termID;

  newClassPopUp(BuildContext c, List<Course> t, String tID) {
    context = c;
    terms = t;
    termID = tID;
  }

  @override
  _newClassPopUpState createState() =>
      _newClassPopUpState(context, terms, termID);
}

class _newClassPopUpState extends State<newClassPopUp> {
  String termID;

  _newClassPopUpState(BuildContext c, List<Course> t, String tID) {
    this.termID = tID;
  }


  final classTitleController = TextEditingController();
  final creditHoursController = TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer", "Other"];
  List<DropdownMenuItem> listOfTerms = [];

  void handleSubmitted() {
    focusScopeNode.nextFocus();
  }

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    for (var l = 0; l < listOfTermsRaw.length; l++) {
      listOfTerms.insert(
          0, DropdownMenuItem(child: Text("${listOfTermsRaw[l]}")));
    }
    List<DropdownMenuItem> listOfYears = [];
    for (var i = 2015; i <= DateTime.now().year; i++) {
      listOfYears.insert(0, DropdownMenuItem(child: Text("$i")));
    }

    return AlertDialog(
        content: SizedBox(
      child: FocusScope(
        node: focusScopeNode,
        child: Form(
            child: Column(children: [
          Text(
            "Add new Class",
            style: Theme.of(context).textTheme.headline4,
          ),
          Divider(color: Theme.of(context).dividerColor),
          TextFormField(
            controller: classTitleController,
            decoration: const InputDecoration(
              hintText: "ex CS 101",
              labelText: 'Class Title',
            ),
            onEditingComplete: handleSubmitted,
          ),
          TextFormField(
            controller: creditHoursController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "ex 4",
              labelText: 'Credit Hours',
            ),
            onEditingComplete: handleSubmitted,
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
              Text("Pass/Fail", style: Theme.of(context).textTheme.headline3),
            ],
          ),
          Expanded(
            child: SizedBox(
                width: 300,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Theme.of(context).primaryColor),
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0)))),
                    onPressed: () async {
                      await CourseService(termID).addCourse(classTitleController.text,
                          creditHoursController.text);
                      if (int.parse(creditHoursController.text) is int) {
                        print(creditHoursController.text);
                      }
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text(
                      "Add",
                      style: Theme.of(context).textTheme.headline2,
                    ))),
          ),
        ])),
      ),
      width: 100,
      height: 260,
    ));
  }
}

class DeleteConfirmation extends StatelessWidget {
  String termID;
  List<Course> termCourses;
  int index;

  DeleteConfirmation(String id, List<Course> courses, int i) {
    termID = id;
    termCourses = courses;
    index = i;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          "Delete Course",
          style: Theme.of(context).textTheme.headline4,
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        Text(
          "Are you sure you want to delete the ${termCourses[index].name} class?",
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(height: 20),
        FlatButton(
          color: Colors.red,
          height: 40,
          onPressed: () {
            CourseService(termID).deleteCourse(termCourses[index].id);
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
      ]),
    );
  }
}
