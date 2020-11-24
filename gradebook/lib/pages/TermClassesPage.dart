import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/services/term_service.dart';
import 'CategoriesPage.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';
import 'package:gradebook/model/Course.dart';


class TermClassesPageWrap extends StatefulWidget {
  String termID;
  TermClassesPageWrap({Key key, @required this.termID}) : super(key: key);

  @override
  _TermClassesPageWrapState createState() => _TermClassesPageWrapState(termID);
}

class _TermClassesPageWrapState extends State<TermClassesPageWrap> {
  String termID;

  @override
  _TermClassesPageWrapState(String tID) {
    this.termID = tID;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Course>>.value(
      value: CourseService(termID).courses,
      child: TermClassesPage(termID: termID,),
    );
  }
}

class TermClassesPage extends StatefulWidget {
  String termID;
  TermClassesPage({Key key, @required this.termID}) : super(key: key);

  @override
  _TermsPageState createState() => _TermsPageState(termID);
}

class _TermsPageState extends State<TermClassesPage> {

  //final List<String> classes = ["CS 371", "CS 499", "GEOS 201", "MILS 401"];
  final SlidableController slidableController = new SlidableController();
  final GlobalKey scaffoldKey = new GlobalKey();
  String termID;

  @override
  _TermsPageState(String tID) {
    this.termID = tID;
  }



  @override
  Widget build(BuildContext context) {
    final classes = Provider.of<List<Course>>(context);
    //Random rand = new Random();
    return Scaffold(
      key: scaffoldKey,
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: FutureBuilder(
          future: TermService().termsCollection.doc(termID).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            Map<String, dynamic> data = snapshot.data.data();
            return Text("${data['name']} ${data['year']}",style: Theme.of(context).textTheme.headline1,);
          }


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
                      newClassPopUp(context, classes, termID),
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
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
            indent: 25.0,
            endIndent: 25.0,
          ),
          itemCount: classes.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(0.0),
            child: Slidable(
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: .2,
              secondaryActions: [
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
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DeleteConfirmation(termID, classes, index);
                      },
                    );
                  },
                )
              ],
              child: Container(
                  width: MediaQuery.of(context).size.width,
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
                            //Navigator.pushNamed(context, '/Categories');
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => CategoriesPageWrap(
                          termID: termID, courseID: classes[index].id)));

                          },
                          child: new Padding(
                            padding: new EdgeInsets.all(20.0),
                            child: Text(
                              "${classes[index].name}",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "A",
                                textScaleFactor: 2,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            Container(
                              child: Text(
                                "97%",
                                textScaleFactor: 2,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

Widget newClassPopUp(BuildContext context, List<Course> terms, String termID) {
  CourseService courseServ = new CourseService(termID);

  final classTitleController = TextEditingController();
  final creditHoursController = TextEditingController();

  List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer", "Other"];
  List<DropdownMenuItem> listOfTerms = [];
  for (var l = 0; l < listOfTermsRaw.length; l++) {
    listOfTerms.insert(
        0, DropdownMenuItem(child: Text("${listOfTermsRaw[l]}")));
  }
  List<DropdownMenuItem> listOfYears = [];
  for (var i = 2015; i <= DateTime.now().year; i++) {
    listOfYears.insert(0, DropdownMenuItem(child: Text("$i")));
  }

  return AlertDialog(
      title: Text(
        "Add a new Class",
        style: Theme.of(context).textTheme.headline2,
      ),
      content: SizedBox(
        child: Form(
            child: Column(children: [
          TextFormField(
            controller: classTitleController,
            decoration: const InputDecoration(
              hintText: "ex CS 101",
              labelText: 'Class Title',
            ),
          ),
          TextFormField(
            controller: creditHoursController,
            decoration: const InputDecoration(
              hintText: "ex 4",
              labelText: 'Credit Hours',
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: SizedBox(
              width: 300,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                  onPressed: () async {
                    await courseServ.addCourse(classTitleController.text,creditHoursController.text);
                    if (int.parse(creditHoursController.text) is int) {
                      print(creditHoursController.text);
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Add",  style: Theme.of(context).textTheme.headline6,))),
            ),

        ])),
        width: 100,
        height: 195,
      ));
}


class DeleteConfirmation extends StatelessWidget{
  String termID;
  List<Course> termCourses;
  int index;

  DeleteConfirmation(String id, List<Course> courses, int i){
    termID = id;
    termCourses = courses;
    index = i;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Delete Course",
        style: Theme.of(context).textTheme.headline2,
      ),
      content: Text("Are you sure you want to delete this Course?",),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            CourseService(termID).deleteCourse(termCourses[index].id);
            Navigator.pop(context);
          },
          child: Text("Delete", textScaleFactor: 1.25,),
        ),
        FlatButton(
          onPressed: (){Navigator.pop(context);},
          child: Text("Close", textScaleFactor: 1.25,),
        ),
      ],
    );
  }

}