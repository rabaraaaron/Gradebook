import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/pages/Assessment/AssessmentCompleted.dart';
import 'package:gradebook/pages/Assessment/AssessmentOptions.dart';
import 'package:gradebook/pages/Category/CategoryPage.dart';
import 'package:gradebook/pages/loading.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/services/dueDateQuery.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/utils/LinearLoading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// class UpcomingTerms extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//       return StreamProvider<List<Term>>.value(
//       value: TermService().terms,
//       child: UpcomingCourses(),
//     );
//   }
// }
//
// class UpcomingCourses extends StatelessWidget {
//   Term term;
//   UpcomingCourses({Key key, @required this.term}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     // return StreamProvider<List<Course>>.value(
//     //     value: CourseService(term.termID).courses,
//     //     child: StreamProvider<List<Category>>.value(
//     //       value: CategoryService(term.termID, course.id).categories,
//     //       child: CategoriesPage(term: term, course: course),
//     //     )
//     // );
//   }
// }





class UpcomingAssignments extends StatefulWidget {
  final String termID;

  const UpcomingAssignments({Key key, this.termID}) : super(key: key);

 // String termID, courseID, categoryID, courseName;


  @override
  // ignore: non_constant_identifier_names
  Widget build(BuildContext context) {

  return Container();

    // return StreamProvider<List<Course>>.value(
    //     value: CourseService(term.termID).courses,
    //     child: StreamProvider<List<Category>>.value(
    //       value: CategoryService(term.termID, course.id).categories,
    //       child: CategoriesPage(term: term, course: course),
    //     )
    // );
  }


  @override
  _UpcomingAssignments createState() => _UpcomingAssignments(termID);
}

class _UpcomingAssignments extends State<UpcomingAssignments> {
  final String termID;

  _UpcomingAssignments(this.termID);

  @override
  build(BuildContext context) {
    // final List<Assessment> assessments = Provider.of<List<Assessment>>(context);
    // final List<Category> categories = Provider.of<List<Category>>(context);
    // final List<Course> course = Provider.of<List<Course>>(context);
    // final List<Term> terms = Provider.of<List<Term>>(context);
    //CourseService courseService = CourseService(termID);
    DueDateQuery dueDateQuery = new DueDateQuery();
    final SlidableController slidableController = new SlidableController();

    //String termID, courseID, catID, id;

    // var loading = true;
    // if(dueDateQuery.getAssessmentsDue() != null ){
    //   loading = false;
    // }
    //


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
        future: dueDateQuery.getAssessmentsDue(),
          builder: (context, snapshot){

          if(snapshot.connectionState != ConnectionState.done){
            return Loading();
          }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {

            return Slidable(
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: .2,
              secondaryActions: <Widget>[
                IconSlideAction(
                  color: Colors.transparent,
                  closeOnTap: true,
                  iconWidget: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Theme.of(context).dividerColor,
                      size: 35,
                    ),
                    onPressed: ()async{
                      //TODO: implement updating assessments from here
                      // await showDialog(
                      //     context: context,
                      //     builder: (BuildContext context){
                      //       return AssessmentCompleted(
                      //           termID,
                      //           snapshot.data[index].courseID,
                      //           snapshot.data[index].catID,
                      //           snapshot.data[index]);
                      //     }
                      // );
                    },
                  ),
                  // onTap: () async {
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         // return AssessmentOptions(context, termID,
                  //         //     courseID, categoryID, element);
                  //         return null;
                  //       });
                  // },
                ),
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

                    AssessmentService aServ = AssessmentService(termID, courseID, catID);

                    await aServ.deleteAssessment(id);
                    setState(() {

                    });
                  },
                )
              ],
              child: Card(
                color: Theme.of(context).accentColor.withOpacity(.2),
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
                              Text('Course: ', style: TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.bold),),
                              FutureBuilder(
                                initialData: "--",
                                //future: dueDateQuery.getAssesmentsDue(),
                                future: CourseService(snapshot.data[index].termID)
                                    .getCourseName(
                                    snapshot.data[index].courseID),
                                builder: (context, courseNameSnap) {
                                  //print(snap.data);
                                  if(courseNameSnap.connectionState != ConnectionState.done){
                                    return LinearLoading();
                                  }
                                  return Text(courseNameSnap.data);
                                },

                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Due on: ", style: TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.bold),),
                              Text(DateFormat('yyyy-MM-dd').format(
                                  snapshot.data[index].dueDate)),
                              //test(snapshot.data[index]),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: Container(),flex: 10,),
                      IconButton(
                        icon: Icon(Icons.check),
                        color: Colors.white,
                        onPressed: ()  {
                          showDialog(
                              context: context,
                              builder: (BuildContext context){

                                //todo: =======================================================

                                /// By Mohd:  this button works but I couldn't find a way to rebuild this page
                                /// after updating an assessment as complete. I think this is becouse we are not using
                                /// a steam. The changes to the assessments will not be reflected on the list of
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
                                  snapshot.data[index]);// Here

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => CategoryPageWrap(
                                //             term: term,
                                //             course: classes[index])));
                                // return;
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
        })
    );
  }

  Widget test(Assessment a){
    //
    // AssessmentCompleted(
    //     a.termID,
    //     a.courseID,
    //     a.catID,
    //     a);// Here

    if(a.isCompleted)
    // setState(() {
    //
    // });
      return Text(a.isCompleted.toString());

    else return Text(a.isCompleted.toString());




  }
}
