import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/pages/Assessment/AssessmentCompleted.dart';
import 'package:gradebook/pages/loading.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/services/dueDateQuery.dart';
import 'package:gradebook/services/user_service.dart';
import 'package:gradebook/utils/LinearLoading.dart';
import 'package:intl/intl.dart';


class UpcomingAssignments extends StatefulWidget {
  final String termID;

  const UpcomingAssignments({Key key, this.termID}) : super(key: key);


  @override
  Widget build(BuildContext context) {

  return Container();

  }


  @override
  _UpcomingAssignments createState() => _UpcomingAssignments(termID);
}

class _UpcomingAssignments extends State<UpcomingAssignments> {
  String termID;
  int window;
  String uID ;
  UserService userService;
  DueDateQuery dueDateQuery = new DueDateQuery();



  _UpcomingAssignments(String termID){
    this.termID = termID;
    uID = FirebaseAuth.instance.currentUser.uid;
    userService = UserService(uid: uID);
  }

  Future<List<Assessment>> getWindow() async{
    print("Im inside getWindow " + window.toString());
    await userService.getUserWindow(uID).then((value) => window = value);
    return await dueDateQuery.getAssessmentsDue(window);
  }


  @override
  build(BuildContext context) {

    final SlidableController slidableController = new SlidableController();

    List<DropdownMenuItem> dayList = [];
    for(int i = 1; i < 32; i++){
      dayList.insert( i-1,
        DropdownMenuItem(
          child: Text("$i"),
          value: i,
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35,),
          color: Theme.of(context).buttonColor,
          iconSize: 25,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Upcoming", style: Theme.of(context).textTheme.headline1,),
      ),
      body: FutureBuilder(
        initialData: Loading(),
        future: getWindow(),
          builder: (context, snapshot){
          print("HELLO " + window.toString());
          if(snapshot.connectionState != ConnectionState.done){
            print("We are waiting at loading");
            return Loading();
          }
          print("No longer waiting");
          if(snapshot.data.length == 0){
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    Text('Window: '),
                    SizedBox(width: 15,),
                    DropdownButton(
                      style: Theme.of(context).textTheme.headline5,
                      hint: Center(
                        child: Text(
                          "days",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      value: window,

                      items: dayList,
                      onChanged: (days) async {
                        userService.setUserWindow(uID, days);

                        window = await Future.value(userService.getUserWindow(uID));
                        print(window.toString() + " changed");

                        setState(() {
                        });

                      },
                      isExpanded: false,
                    ),
                    Text('   days'),

                    SizedBox(width: 15,),
                    Icon(Icons.calendar_today, size: 35,),

                    Expanded(child: Container()),
                  ],
                ),
                Expanded(child: Container()),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Text('Window: '),
                        SizedBox(width: 15,),
                        DropdownButton(
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline5,
                          hint: Center(
                            child: Text(
                              "days",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline3,
                            ),
                          ),
                          value: window,

                          items: dayList,
                          onChanged: (days) async {
                            userService.setUserWindow(uID, days);

                            window =
                            await Future.value(userService.getUserWindow(uID));
                            print(window.toString() + " changed");

                            setState(() {});
                          },
                          isExpanded: false,
                        ),
                        Text('   days'),

                        SizedBox(width: 15,),
                        Icon(Icons.calendar_today, size: 35,),

                        Expanded(child: Container()),
                      ],
                    ),
                    Slidable(
                      controller: slidableController,
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: .2,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          color: Colors.transparent,
                          closeOnTap: true,
                          iconWidget: Icon(
                            Icons.delete,
                            color: Theme
                                .of(context)
                                .dividerColor,
                            size: 35,
                          ),
                          onTap: () async {
                            String courseID, termID, catID, id;
                            courseID = snapshot.data[index].courseID;
                            termID = snapshot.data[index].termID;
                            catID = snapshot.data[index].catID;
                            id = snapshot.data[index].id;

                            AssessmentService aServ = AssessmentService(
                                termID, courseID, catID);

                            await aServ.deleteAssessment(id);
                            setState(() {

                            });
                          },
                        )
                      ],
                      child: Card(
                        color: Theme
                            .of(context)
                            .accentColor
                            .withOpacity(.2),
                        child: ListTile(
                          leading: Icon(Icons.album_sharp),
                          title: Text(snapshot.data[index].name,),
                          subtitle: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Course: ',
                                        style: TextStyle(fontSize: 14,
                                            fontWeight: FontWeight.bold),),
                                      FutureBuilder(
                                        initialData: "--",
                                        //future: dueDateQuery.getAssesmentsDue(),
                                        future: CourseService(
                                            snapshot.data[index].termID)
                                            .getCourseName(
                                            snapshot.data[index].courseID),
                                        builder: (context, courseNameSnap) {
                                          //print(snap.data);
                                          if (courseNameSnap.connectionState !=
                                              ConnectionState.done) {
                                            return LinearLoading();
                                          }
                                          return Text(courseNameSnap.data);
                                        },

                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Due on: ",
                                        style: TextStyle(fontSize: 14,
                                            fontWeight: FontWeight.bold),),
                                      Text(DateFormat('M-d-yyyy, hh:mm a')
                                          .format(
                                          snapshot.data[index].dueDate)),
                                      //test(snapshot.data[index]),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(child: Container(), flex: 10,),
                              IconButton(
                                iconSize: 25,
                                icon: Icon(Icons.check),
                                color: Colors.white,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        //todo: =======================================================

                                        /// By Mohd:  this button works but I couldn't find a way to rebuild this page
                                        /// after updating an assessment as complete. I think this is becouse we are not using
                                        /// a stream. The changes to the assessments will not be reflected on the list of
                                        /// assessments used here in this page.
                                        ///
                                        /// Another solution:  Once the user taps on the tile, we could possible navigate the user
                                        /// the course/category where the assessment is. Then they can set it as complete from there.
                                        ///
                                        ///
                                        //todo: =======================================================

                                        return AssessmentCompleted(
                                            snapshot.data[index].termID,
                                            snapshot.data[index].courseID,
                                            snapshot.data[index].catID,
                                            snapshot.data[index]); // Here


                                      });
                                },
                              )
                            ],
                          ),

                        ),
                      ),
                    ),
                  ],);
                }


                return Slidable(
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: .2,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.transparent,
                      closeOnTap: true,
                      iconWidget: Icon(
                        Icons.delete,
                        color: Theme
                            .of(context)
                            .dividerColor,
                        size: 35,
                      ),
                      onTap: () async {
                        String courseID, termID, catID, id;
                        courseID = snapshot.data[index].courseID;
                        termID = snapshot.data[index].termID;
                        catID = snapshot.data[index].catID;
                        id = snapshot.data[index].id;

                        AssessmentService aServ = AssessmentService(
                            termID, courseID, catID);

                        await aServ.deleteAssessment(id);
                        setState(() {

                        });
                      },
                    )
                  ],
                  child: Card(
                    color: Theme
                        .of(context)
                        .accentColor
                        .withOpacity(.2),
                    child: ListTile(
                      leading: Icon(Icons.album_sharp),
                      title: Text(snapshot.data[index].name,),
                      subtitle: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Course: ', style: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.bold),),
                                  FutureBuilder(
                                    initialData: "--",
                                    //future: dueDateQuery.getAssesmentsDue(),
                                    future: CourseService(
                                        snapshot.data[index].termID)
                                        .getCourseName(
                                        snapshot.data[index].courseID),
                                    builder: (context, courseNameSnap) {
                                      //print(snap.data);
                                      if (courseNameSnap.connectionState !=
                                          ConnectionState.done) {
                                        return LinearLoading();
                                      }
                                      return Text(courseNameSnap.data);
                                    },

                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Due on: ", style: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.bold),),
                                  Text(DateFormat('M-d-yyyy, h:mm a').format(
                                      snapshot.data[index].dueDate)),
                                  //test(snapshot.data[index]),
                                ],
                              ),
                            ],
                          ),
                          Expanded(child: Container(), flex: 10,),
                          IconButton(
                            iconSize: 25,
                            icon: Icon(Icons.check),
                            color: Colors.white,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    //todo: =======================================================

                                    /// By Mohd:  this button works but I couldn't find a way to rebuild this page
                                    /// after updating an assessment as complete. I think this is becouse we are not using
                                    /// a stream. The changes to the assessments will not be reflected on the list of
                                    /// assessments used here in this page.
                                    ///
                                    /// Another solution:  Once the user taps on the tile, we could possible navigate the user
                                    /// the course/category where the assessment is. Then they can set it as complete from there.
                                    ///
                                    ///
                                    //todo: =======================================================

                                    return AssessmentCompleted(
                                        snapshot.data[index].termID,
                                        snapshot.data[index].courseID,
                                        snapshot.data[index].catID,
                                        snapshot.data[index]); // Here

                                  });

                            },
                          )
                        ],
                      ),

                    ),
                  ),
                );
              },
            );
          }
        }),
    );
  }

  Widget test(Assessment a){

    if(a.isCompleted)
      return Text(a.isCompleted.toString());
    else
      return Text(a.isCompleted.toString());
  }
}
