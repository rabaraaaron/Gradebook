import 'dart:math';
import 'package:flutter/material.dart';

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
                    newClassPopUp(context, terms),
              );
              setState(() {});
            }
        )],
      ),
      body: Center(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemCount: terms.length,
          itemBuilder: (context, index) => Container(
            child: Center(child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.ac_unit, color: Colors.black,),
                      iconSize: 35.0,
                      onPressed: (){
                        print("Icons pressed");
                      },
                    ),
                    padding: EdgeInsets.all(10.0),),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, "/home");
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
            )),
          ),
        )
      ),
    );
  }
}



Widget newClassPopUp(BuildContext context, List<String> terms) {
  var term;
  List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer", ""];
  List<DropdownMenuItem> listOfTerms = [];
  for(var l = 0; l < listOfTermsRaw.length; l++){
    listOfTerms.insert(0, DropdownMenuItem(child: Text("${listOfTermsRaw[l]}")));
  }
  List<DropdownMenuItem> listOfYears = [];
  for(var i = 2015; i <= DateTime.now().year; i++){
    listOfYears.insert(0, DropdownMenuItem(child: Text("$i")));
  }

  return AlertDialog(
    title: Text("Add a new Term"),
    content: SizedBox(
      child: Form(
          child: Column(children: [
            DropdownButton(
              hint: Text(""),
              onChanged: (str) {
                setState(var str){
                  term = str;
                }
                setState((str) { });
              },
              value: term,
              isExpanded: true,
              items: listOfTerms,
            ),
            DropdownButton(
              hint: Text("Year"),
              onChanged: (value) {
                setState(var value){
                  term = value;
                }
                setState((value) { });
              },
              value: term,
              isExpanded: true,
              items: listOfYears,
            ),
            RaisedButton(onPressed: (){
              terms.insert(0, "$term");
              Navigator.pop(context);
              }, child: Text("Add"))
          ])),
      width: 100,
      height: 175,
    ));
}

