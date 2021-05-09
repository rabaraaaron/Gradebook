import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/model/User.dart';
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
import 'package:gradebook/model/User.dart';

class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
    StreamProvider<List<Term>>.value(
        value: TermService().terms,
    ),
      StreamProvider<GradeBookUser>.value(
        value: UserService(uid:FirebaseAuth.instance.currentUser.uid).user,
      ),
    ],
    child: TermsList(),);
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
    Widget listView = Container();
    GradeBookUser user = Provider.of<GradeBookUser>(context);
    print("USERID::::::"+ user.toString());

    if (Provider.of<List<Term>>(context) != null) {
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
                                  builder: (context) =>
                                      TermClassesPageWrap(term: terms[index])));
                        },
                        child: new Padding(
                          padding: new EdgeInsets.all(20.0),
                          child: Text(
                            "${terms[index].name} ${terms[index].year}",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${terms[index].gpa.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.headline5,
                      textScaleFactor: 2,
                    ),
                  ],
                )),
          ),
        ),
      );
    } else {
      terms = [];
    }

    seasonIcons.clear();
    double scale = 9.5;
    for (int i = 0; i < terms.length; i++) {
      if (terms[i].name == "Fall") {
        seasonIcons.add(Image.asset(
          'assets/Fall_icon.png',
          scale: scale,
          color: Theme.of(context).dividerColor,
        ));
      } else if (terms[i].name == "Winter") {
        seasonIcons.add(Image.asset(
          'assets/Winter.png',
          scale: scale,
          color: Theme.of(context).dividerColor,
        ));
      } else if (terms[i].name == "Spring") {
        seasonIcons.add(Image.asset(
          'assets/Flower.png',
          scale: scale,
          color: Theme.of(context).dividerColor,
        ));
      } else {
        seasonIcons.add(Image.asset('assets/Sun.png',
            scale: scale, color: Theme.of(context).dividerColor));
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
                  builder: (BuildContext context) => NewTerm(context, terms),
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
              columnWidths: {
                0: FractionColumnWidth(0.5),
                1: FractionColumnWidth(0.2),
                2: FractionColumnWidth(0.43),
                3: FractionColumnWidth(0.17),
              },
              children: [
                TableRow(
                    children: [
                      Text(" Cumulative GPA:",),
                      Center(child: Text("${user.cumulativeGPA}", style: TextStyle(fontWeight: FontWeight.bold),)),
                      Container(child: Row(children:[Expanded(flex: 2, child: Container(height: 30,),),])),

                    ]),
                TableRow(
                    children: [
                      Text(" Cumulative Credits",),
                      Center(
                          child: Text("${user.cumulativeCredits}", style: TextStyle(fontWeight: FontWeight.bold),)),
                      Container(child: Row(children:[Expanded(flex: 3, child: Container(height: 30,),),])),
                    ]
                )
              ],
            ),
          ),
          Expanded(flex:1, child: listView),
        ],
      ),
    );
  }
}
