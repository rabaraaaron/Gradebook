import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';
import 'CategoryOptions.dart';
import 'DeleteCategoryConfirmation.dart';
import 'NewCategory.dart';
import '../Assessment/AssessmentTile.dart';


// ignore: must_be_immutable
class CategoryPageWrap extends StatelessWidget {
  Term term;
  Course course;

  CategoryPageWrap({Key key, @required this.term, this.course})
      : super(key: key);

  @override
  // ignore: non_constant_identifier_names
   Widget build(BuildContext) {

    return StreamProvider<List<Course>>.value(
      value: CourseService(term.termID).courses,
      child: StreamProvider<List<Category>>.value(
        value: CategoryService(term.termID, course.id).categories,
        child: CategoriesPage(term: term, course: course),
      )
    );
  }
}

// ignore: must_be_immutable
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
    CategoryService catServ = new CategoryService(term.termID, course.id);

    final List categories = Provider.of<List<Category>>(context);
    final List courses = Provider.of<List<Course>>(context);

    //to get the width of the screen
    //final double width = MediaQuery.of(context).size.width;

    if(courses != null) {
      for (Course c in courses) {
        if (c.id == course.id) {course = c;}
      }
    }
    double allocatedWeight = 100;
    if(categories != null){
      for(Category c in categories){
        allocatedWeight -= double.parse(c.categoryWeight);
      }
    }

    Widget listView;


    if (Provider.of<List<Category>>(context) != null) {
      listView = ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Theme.of(context).dividerColor,
                indent: 25.0,
                endIndent: 25.0,
              ),
          itemCount: categories.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              child: StreamProvider.value(
                value: AssessmentService(
                        term.termID, course.id, categories[index].id)
                    .assessments,
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
                        color: Theme.of(context).dividerColor,
                        size: 35,
                      ),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CategoryOptions(
                                  categories[index], term, course);
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
                            return DeleteCategoryConfirmation(
                                catServ, categories, index);
                          },
                        );
                      },
                    )
                  ],
                  child: AssessmentTile(
                    termID: term.termID,
                    courseID: course.id,
                    index: index,
                    courseName: course.name,
                  ),
                ),
              ),
            );
          });
    } else {
      listView = Container();
    }

    Color color = Theme.of(context).primaryColor.withOpacity(.4);
    //color = color - 200;

    Color cardColor = Theme.of(context).primaryColor.withOpacity(.6);
    String percent = double.parse((course.gradePercent)).toStringAsFixed(2);
    String letterGrade = course.letterGrade;
    //TextStyle styleInCard = Theme.of(context).textTheme.bodyText2;


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
      body: Column(
        children: [
          Card(
            //color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),


            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              // border: TableBorder.symmetric(
              //     inside: BorderSide(width: 1, color: Colors.blue),
              //     outside: BorderSide(width: 1)),
              columnWidths: {
                0: FractionColumnWidth(0.2),
                1: FractionColumnWidth(0.2),
                2: FractionColumnWidth(0.45),
                3: FractionColumnWidth(0.15),
              },
              children: [
                TableRow(
                    children: [
                  Text(" Grade:",),
              Center(child: Text(course.letterGrade, style: TextStyle(fontWeight: FontWeight.bold),)),
              Container(child: Row(children:[Expanded(flex: 3, child: Container(height: 30,),),Text('Unallocated: ')])),
              Center(child: Text(allocatedWeight.toString() + "%",style: TextStyle(fontWeight: FontWeight.bold))),
              ]),
          TableRow(
              children: [
                Text(" Percent:",),
                Center(child: Text(course.gradePercent, style: TextStyle(fontWeight: FontWeight.bold),)),
                Container(child: Row(children:[Expanded(flex: 3, child: Container(height: 30,),),Text('Incomplete items:')])),

                //todo: count the number of incomplete assessment and display them here.
                Center(child: Text("5", style: TextStyle(fontWeight: FontWeight.bold),)),
              ]
          )
        ],
      ),
    ),
          Expanded(flex: 1,child: listView),
        ],
      )
    );
  }
}
