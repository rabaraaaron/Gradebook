import 'dart:math';
import 'package:flutter/material.dart';

class TermClasses extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermClasses> {
  List<String> classes = ["CS 371", "CS 499", "GEOS 201", "MILS 401"];

  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    return Scaffold(
      appBar: AppBar(
        title: Text("Fall 2020", textScaleFactor: 1.75,),
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), iconSize: 30,
          onPressed: (){Navigator.pop(context);}, color: Colors.black,),
        actions: [IconButton(icon: Icon(Icons.add), iconSize: 30, color: Colors.white,
            onPressed: () async{
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    newTermPopUp(context, classes),
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
            itemCount: classes.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(0.0),
              child: Center(child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Icon(Icons.chevron_right, size: 50,),
                        padding: EdgeInsets.all(10.0),),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: (){
                              // Navigator.push(context, )
                            },
                            child: new Padding(
                              padding: new EdgeInsets.all(20.0),
                              child: Text("${classes[index]}", textScaleFactor: 2,),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "A+",
                          textScaleFactor: 2.0,

                        ),
                        padding: EdgeInsets.all(5.0),
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



Widget newTermPopUp(BuildContext context, List<String> terms) {
  var termYear;
  var term;
  List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer", "Other"];
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
                hint: Text("Term"),
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
              }, child: Text("Submit"))
            ])),
        width: 100,
        height: 175,
      ));
}

