import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  List<String> terms = ["Fall 2020", "J-term 2021", "Spring 2021", "Summer 2021"];
  final SlidableController slidableController = SlidableController();
  final GlobalKey scaffoldKey = new GlobalKey();

  Center drawerMenu = new Center(

  );

  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Text("Header")),
            ListTile(title: Text("Settings"),),
            ListTile(title: Text("Membership"),),
            ListTile(title: Text("Help")),
            ListTile(title: Text("Log Out")),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Terms",
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) =>
          Center(
            child: IconButton(
                icon: Icon(Icons.menu_sharp, color: Colors.white,),
                iconSize: 30,
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                  print("Menu Selected");
                }),
          ),
        ),
        actions: [IconButton(icon: Icon(Icons.add_sharp), iconSize: 35, color: Colors.white,
            onPressed: () async{
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    NewTermsPopUp(context, terms),
              );
              setState(() {});
            }
        )],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.white,
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
                iconWidget: Icon(Icons.edit, color: Colors.white, size: 35,),
                onTap: () => null,
              ),
              IconSlideAction(
                color: Colors.transparent,
                closeOnTap: true,
                iconWidget: Icon(Icons.delete, color: Colors.white, size: 35,),
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
                      child: IconButton(
                        icon: Icon(Icons.ac_unit),
                        iconSize: 35.0,
                        onPressed: (){
                        print("Icons pressed");
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, "/Home");
                      },
                        child: new Padding(
                          padding: new EdgeInsets.all(20.0),
                          child: Text(
                          "${terms[index]}",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      ),
                    ),
                    Text("4.0", style: Theme.of(context).textTheme.headline3, textScaleFactor: 2,),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}


class NewTermsPopUp extends StatefulWidget {
  var c;
  var termsList;

  NewTermsPopUp(context, terms){
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

  _NewTermsPopUpState(context, terms){
    thisContext = context;
    thisTerms = terms;
  }


  @override
  Widget build(BuildContext context) {

    List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer"];
    List<DropdownMenuItem> listOfTerms = [];
    for(var l = 0; l < listOfTermsRaw.length; l++){
      listOfTerms.insert(0, DropdownMenuItem(
        child: Text("${listOfTermsRaw[l]}"),
        value: listOfTermsRaw[l],
      ));
    }
    List<DropdownMenuItem> listOfYears = [];
    for(var i = 2015; i <= DateTime.now().year; i++){
      listOfYears.insert(0, DropdownMenuItem(
        child: Text("$i"),
        value: i,
      ));
    }

    return AlertDialog(
        title: Text("Add a new Term", style: Theme.of(context).textTheme.headline2,),
        content: SizedBox(
          child: Form(
              child: Column(children: [
                DropdownButton(
                  hint: Text("Term", style: Theme.of(context).textTheme.headline3,),
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
                  hint: Text("Year", style: Theme.of(context).textTheme.headline3,),
                  onChanged: (newYear) {
                    setState(() {
                      termYear = newYear;
                    });
                  },
                  value: termYear,
                  isExpanded: true,
                  items: listOfYears,
                ),
                RaisedButton(onPressed: (){
                  thisTerms.insert(0, "$addedTerm" + " " + "$termYear");
                  Navigator.pop(context);
                }, child: Text("Add",),)
              ])),
          width: 100,
          height: 175,
        ));
  }
}


