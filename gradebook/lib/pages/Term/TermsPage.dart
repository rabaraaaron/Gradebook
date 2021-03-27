import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/pages/Term/TermOptions.dart';
import '../Courses/CoursePage.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';
import 'DeleteTermConfirmation.dart';
import 'NewTerm.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:gradebook/services/user_service.dart';
import 'package:gradebook/utils/MyAppTheme.dart';


class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Term>>.value(
      value: TermService().terms,
      child: TermsList(),
    );
  }
}

class TermsList extends StatefulWidget {
  @override
  _TermsListState createState() => _TermsListState();
}

class _TermsListState extends State<TermsList> {
  final SlidableController slidableController = SlidableController();
  final GlobalKey scaffoldKey = new GlobalKey();
  List<Image> seasonIcons = [];


  @override
  Widget build(BuildContext context) {
    List terms;
    Widget listView;

    if(Provider.of<List<Term>>(context) != null){
      terms = Provider.of<List<Term>>(context);
      listView = ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).dividerColor,
          indent: 25.0,
          endIndent: 25.0,
        ),
        itemCount: terms.length,
        itemBuilder: (context, index) => Container(
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
                  Term t = terms[index];
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TermOptions(t);
                    },
                  );
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
                      return DeleteTermConfirmation(terms, index);
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
                      padding: EdgeInsets.all(10.0),
                      child: seasonIcons[index],
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, "/Home");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermClassesPageWrap(term: terms[index])));
                        },
                        child: new Padding(
                          padding: new EdgeInsets.all(20.0),
                          child: Text(
                            "${terms[index].name} ${terms[index].year}",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${terms[index].gpa}",
                      style: Theme.of(context).textTheme.headline5,
                      textScaleFactor: 2,
                    ),
                  ],
                )),
          ),
        ),
      );
    } else{
      terms = [];
    }



    seasonIcons.clear();
    double scale = 9.5;
    for(int i = 0; i < terms.length; i++){
      if(terms[i].name == "Fall"){
        seasonIcons.add(Image.asset('assets/Fall_icon.png', scale: scale, color: Theme.of(context).dividerColor,));
      } else if(terms[i].name == "Winter"){
        seasonIcons.add(Image.asset('assets/Winter.png', scale: scale, color: Theme.of(context).dividerColor,));
      } else if(terms[i].name == "Spring"){
        seasonIcons.add(Image.asset('assets/Flower.png', scale: scale, color: Theme.of(context).dividerColor,));
      } else{
        seasonIcons.add(Image.asset('assets/Sun.png', scale: scale, color: Theme.of(context).dividerColor));
      }
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text(
          "Terms",
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
              icon: Icon(Icons.add_sharp),
              iconSize: 35,
              color: Colors.white,
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      NewTerm(context, terms),
                );
                setState(() {});
              })
        ],
      ),
      body: listView,
    );
  }
}

