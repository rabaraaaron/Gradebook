import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  List<String> terms = ["Fall 2020", "J-term 2021", "Spring 2021", "Summer 2021"];

  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms",
          textScaleFactor: 1.75,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.menu_rounded, color: Colors.white,),
            iconSize: 30,
            onPressed: (){
              print("Menu Selected");
            }),
        actions: [IconButton(icon: Icon(Icons.add), iconSize: 30, color: Colors.white,
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
          color: Colors.black,
        ),
        itemCount: terms.length,
        itemBuilder: (context, index) => Container(
          child: Slidable(
            closeOnScroll: true,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: .25,
            secondaryActions: <Widget>[
              IconSlideAction(
                closeOnTap: true,
                caption: 'Edit',
                color: Colors.grey[50],
                iconWidget: Icon(Icons.edit, color: Colors.blue,),
                onTap: () => null,
              ),
              IconSlideAction(
                closeOnTap: true,
                caption: 'Delete',
                color: Colors.grey[50],
                iconWidget: Icon(Icons.delete, color: Colors.red,),
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
                        icon: Icon(Icons.ac_unit, color: Colors.black,),
                        iconSize: 35.0,
                        onPressed: (){
                        print("Icons pressed");
                        },
                      ),
                    ),
                    Expanded(
                      child: Material(
                        child: InkWell(
                          onTap: (){
                          Navigator.pushNamed(context, "/Home");
                        },
                          child: new Padding(
                            padding: new EdgeInsets.all(20.0),
                            child: Text(
                            "${terms[index]}",
                            textScaleFactor: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
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
        title: Text("Add a new Term"),
        content: SizedBox(
          child: Form(
              child: Column(children: [
                DropdownButton(
                  hint: Text("Term"),
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
                  hint: Text("Year"),
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
                }, child: Text("Add"))
              ])),
          width: 100,
          height: 175,
        ));
  }
}


