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
        title: Text("Terms", textScaleFactor: 1.75,),
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), iconSize: 30,
            onPressed: null, color: Colors.black,),
        actions: [IconButton(icon: Icon(Icons.add), iconSize: 30, color: Colors.white,
            onPressed: () async{
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    newTermPopUp(context, terms),
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
                    child: Icon(Icons.ac_unit, size: 40,),
                    padding: EdgeInsets.all(10.0),),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: (){
                          print("${terms[index]} tapped");
                        },
                        child: new Padding(
                          padding: new EdgeInsets.all(20.0),
                          child: Text("${terms[index]}", textScaleFactor: 2,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: DropdownButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded,),
                      iconEnabledColor: Colors.grey,
                      iconDisabledColor: Colors.black,
                      iconSize: 30,
                      onTap: (){},
                    ),
                    padding: EdgeInsets.all(5.0),
                  ),
                ],
              )
            )),
          ),
        )

        // child: ListView.builder(
        //   itemBuilder: (context, index){
        //     return ListTile(
        //       title: Text(terms[index],
        //         textAlign: TextAlign.center,
        //         textScaleFactor: 1.5,
        //       ),
        //       tileColor: Theme.of(context).primaryColorLight,
        //       leading: Icon(Icons.ac_unit, color: Colors.black, size: 30,),
        //       onTap: (null),
        //       trailing: DropdownButton(
        //         icon: Icon(Icons.arrow_forward_ios_rounded,),
        //         iconEnabledColor: Colors.grey,
        //         iconDisabledColor: Colors.black,
        //         iconSize: 25,
        //         onTap: (){
        //         },
        //       ),
        //     );
        //   },
        //   itemExtent: 75.0,
        //   itemCount: terms.length,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (null),
        tooltip: 'Next page',
        child: Icon(
            Icons.add,
            color: Colors.black,
        ),
      ), //
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

