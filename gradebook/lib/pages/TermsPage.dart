import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/pages/TermCoursesPage.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/services/user_service.dart';
import 'package:gradebook/utils/AppTheme.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';

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
          color: AppTheme.bodyIconColor,
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
                  color: AppTheme.bodyIconColor,
                  size: 35,
                ),
                onTap: () => null,
              ),
              IconSlideAction(
                color: Colors.transparent,
                closeOnTap: true,
                iconWidget: Icon(
                  Icons.delete,
                  color: AppTheme.bodyIconColor,
                  size: 35,
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteConfirmation(terms, index);
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
                      style: Theme.of(context).textTheme.headline3,
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
        seasonIcons.add(Image.asset('assets/Fall_icon.png', scale: scale, color: AppTheme.bodyIconColor,));
      } else if(terms[i].name == "Winter"){
        seasonIcons.add(Image.asset('assets/Winter.png', scale: scale, color: AppTheme.bodyIconColor,));
      } else if(terms[i].name == "Spring"){
        seasonIcons.add(Image.asset('assets/Flower.png', scale: scale, color: AppTheme.bodyIconColor,));
      } else{
        seasonIcons.add(Image.asset('assets/Sun.png', scale: scale, color: AppTheme.bodyIconColor));
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
                      NewTermsPopUp(context, terms),
                );
                setState(() {});
              })
        ],
      ),
      body: listView,
    );
  }
}

class NewTermsPopUp extends StatefulWidget {
  var c;
  var termsList;

  NewTermsPopUp(context, terms) {
    c = context;
    termsList = terms;
  }
  @override
  _NewTermsPopUpState createState() => _NewTermsPopUpState(c, termsList);
}

class _NewTermsPopUpState extends State<NewTermsPopUp> {
  var thisContext;
  var thisTerms;
  var termYear;
  var addedTerm;
  var checked = true;

  _NewTermsPopUpState(context, terms) {
    thisContext = context;
    thisTerms = terms;
  }

  @override
  Widget build(BuildContext context) {
    TermService term = new TermService();

    List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer"];
    List<DropdownMenuItem> listOfTerms = [];
    for (var l = 0; l < listOfTermsRaw.length; l++) {
      listOfTerms.insert(
          0,
          DropdownMenuItem(
            child: Text("${listOfTermsRaw[l]}"),
            value: listOfTermsRaw[l],
          ));
    }
    List<DropdownMenuItem> listOfYears = [];
    for (var i = 2015; i <= DateTime.now().year; i++) {
      listOfYears.insert(
          0,
          DropdownMenuItem(
            child: Text("$i"),
            value: i,
          ));
    }

    return AlertDialog(
        title: Text(
          "Add a new Term",
          style: Theme.of(context).textTheme.headline4,
        ),
        content: SizedBox(
          child: Form(
              child: Column(
                  children: [
                    Divider(color: AppTheme.bodyText),
                    DropdownButton(
                      hint: Text(
                        "Term",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      value: addedTerm,
                      items: listOfTerms,
                      onChanged: (newTerm) {
                        setState(() {
                          addedTerm = newTerm;
                        });
                        },
                      isExpanded: true,
                    ),
                    DropdownButton(
                      hint: Text(
                        "Year",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      onChanged: (newYear) {
                        setState(() {
                          termYear = newYear;
                        });
                        },
                      value: termYear,
                      isExpanded: true,
                      items: listOfYears,
                    ),
                    SizedBox(height: 20,),
                    Row(
                        children: [
                          Switch(
                            activeColor: AppTheme.accent,
                            value: checked,
                            onChanged: (updateChecked) {
                              setState(() {
                                checked = updateChecked;
                              });
                              },
                          ),
                          Text(
                            "Will you edit courses?",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ]
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        width: 300,
                        child: RaisedButton(
                            color: AppTheme.appBar,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                            onPressed: () async {
                              await term.addTerm(addedTerm, termYear);
                              Navigator.pop(context);
                              },
                            child: Text("Add",  style: Theme.of(context).textTheme.headline2,)
                        ),
                      ),
                    ),
                  ]
              )
          ),
          width: 100,
          height: 225,
        )
    );
  }
}

class DeleteConfirmation extends StatelessWidget{
  List<Term> terms;
  int index;

  DeleteConfirmation(List<Term> list, int i){
    terms = list;
    index = i;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Delete Term",
        style: Theme.of(context).textTheme.headline4,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: AppTheme.bodyText,),
          Text(
            "Are you sure you want to delete ${terms[index].name} ${terms[index].year} ?",
            style: Theme.of(context).textTheme.headline3,
          ),
        ]
      ),
      actions: <Widget>[
        FlatButton(

          color: Colors.red,
          onPressed: () {
            TermService().deleteTerm("${terms[index].name}", terms[index].year);
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
      ],
    );
  }

}