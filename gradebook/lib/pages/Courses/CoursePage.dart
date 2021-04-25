import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gradebook/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradebook/model/Term.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/services/course_service.dart';
import '../Category/CategoryPage.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';
import 'package:gradebook/model/Course.dart';
import 'DeleteCourseConfirmation.dart';
import 'CourseOptions.dart';
import 'package:gradebook/utils/IconOptions.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/model/Grade.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:google_fonts/google_fonts.dart';

import 'NewCourse.dart';
import 'UpdateIcon.dart';

class TermClassesPageWrap extends StatelessWidget {
  Term term;
  TermClassesPageWrap({Key key, @required this.term}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Course>>.value(
      value: CourseService(term.termID).courses,
      child: TermCoursePage(term: term),
    );
  }
}

// ignore: must_be_immutable
class TermCoursePage extends StatefulWidget {
  Term term;
  TermCoursePage({Key key, @required this.term}) : super(key: key);

  @override
  _TermCoursePageState createState() => _TermCoursePageState(term);
}

class _TermCoursePageState extends State<TermCoursePage> {
  final SlidableController slidableController = new SlidableController();
  final GlobalKey scaffoldKey = new GlobalKey();
  Term term;

  @override
  _TermCoursePageState(Term tID) {
    this.term = tID;
  }

  @override
  Widget build(BuildContext context) {

    Icon courseIcon;

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

            courseIcon = IconOptions(term.termID, classes[index].id)
                .getIconFromString(classes[index].iconName);

            return Column(
              children: [
                Padding(
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
                          color: Theme.of(context).dividerColor,
                          size: 35,
                        ),
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CourseOptions(
                                    term.termID, classes[index]);
                              });
                        },
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteCourseConfirmation(
                                  term.termID, classes, index);
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
                            child: IconButton(
                              iconSize: 45,
                              icon: courseIcon,
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdateIcon(
                                          term.termID,
                                          classes[index].id
                                      );
                                  },
                                );
                              },
                            ),
                            padding: EdgeInsets.all(10.0),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryPageWrap(
                                            term: term,
                                            course: classes[index])));
                              },
                              child: new Padding(
                                padding: new EdgeInsets.all(20.0),
                                child: Text(
                                  "${classes[index].name}",
                                  style: Theme.of(context).textTheme.headline6,
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
                                      child: Text(
                                        "${classes[index].letterGrade}",
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
                                  child: Text(
                                    "${classes[index].getFormattedNumber(double.parse(classes[index].gradePercent))}%",
                                      style: TextStyle(
                                        color: Theme.of(context).dividerColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20.0,
                                        ),
                                ),
                                )],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      listView = Loading();
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
                      NewCourse(context, classes, term.termID),
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
