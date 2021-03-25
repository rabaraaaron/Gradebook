import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Category.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/category_service.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';
import 'CategoryOptions.dart';
import 'DeleteCategoryConfirmation.dart';
import 'NewCategory.dart';
import '../Assessment/AssessmentTile.dart';


// ignore: must_be_immutable
class CategoryPageWrap extends StatefulWidget {
  Term term;
  Course course;

  CategoryPageWrap({Key key, @required this.term, this.course})
      : super(key: key);

  @override
  _CategoryPageWrapState createState() =>
      _CategoryPageWrapState(term, course);
}

class _CategoryPageWrapState extends State<CategoryPageWrap> {
  Term term;
  Course course;

  @override
  _CategoryPageWrapState(Term term, Course course) {
    this.term = term;
    this.course = course;
  }

  @override
  // ignore: non_constant_identifier_names
  Widget build(BuildContext) {
    return StreamProvider<List<Category>>.value(
      value: CategoryService(term.termID, course.id).categories,
      child: CategoriesPage(term: term, course: course),
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
    Widget listView;

    if(categories != null){
      listView = ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Theme.of(context).dividerColor,
            indent: 25.0,
            endIndent: 25.0,
          ),
          itemCount: categories.length,
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
                          builder: (BuildContext context){
                            return CategoryOptions(categories[index], term, course);
                          }
                        );
                      },
                      //TODO: Add alert box for the category settings
                    ),
                    IconSlideAction(
                      color: Colors.transparent,
                      closeOnTap: true,
                      iconWidget: Icon(
                        Icons.delete,
                        color: Theme.of(context).dividerColor,
                        size: 35,
                      ),
                      onTap: ()async {
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
                      cat: categories[index],
                      courseName: course.name,
                    ),
                ),
              ),
            );
          }
      );
    } else{
      listView = Container();
    }

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
        body: listView,
    );
  }
}