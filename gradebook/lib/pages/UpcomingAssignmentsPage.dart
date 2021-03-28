import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/pages/Category/CategoryPage.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/services/dueDateQuery.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpcomingTerms extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return StreamProvider<List<Term>>.value(
      value: TermService().terms,
      child: UpcomingCourses(),
    );
  }
}

class UpcomingCourses extends StatelessWidget {
  Term term;
  UpcomingCourses({Key key, @required this.term}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // return StreamProvider<List<Course>>.value(
    //     value: CourseService(term.termID).courses,
    //     child: StreamProvider<List<Category>>.value(
    //       value: CategoryService(term.termID, course.id).categories,
    //       child: CategoriesPage(term: term, course: course),
    //     )
    // );
  }
}





class UpcomingAssignments extends StatefulWidget {
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
  _UpcomingAssignments createState() => _UpcomingAssignments();
}

class _UpcomingAssignments extends State<UpcomingAssignments> {

  @override
  build(BuildContext context) {
    // final List<Assessment> assessments = Provider.of<List<Assessment>>(context);
    // final List<Category> categories = Provider.of<List<Category>>(context);
    // final List<Course> course = Provider.of<List<Course>>(context);
    // final List<Term> terms = Provider.of<List<Term>>(context);


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).buttonColor,
          iconSize: 25,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Upcoming", style: Theme.of(context).textTheme.headline1,),
      ),
      body: FutureBuilder(
        future: DueDateQuery().getAssesmentsDue(),
          builder: (context, snapshot){
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              return ListTile(
                leading: Icon(Icons.album_sharp),
                title: Text(snapshot.data[index].name),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(snapshot.data[index].dueDate)),

              );
            },
          );
          })
    );
  }
}
