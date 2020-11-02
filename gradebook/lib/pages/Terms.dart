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
        leading: IconButton(
            icon: Icon(Icons.donut_small, color: Colors.white,),
            iconSize: 0,
            onPressed: (){}),
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
                          Navigator.pushNamed(context, "/Home");
                        },
                        child: new Padding(
                          padding: new EdgeInsets.all(20.0),
                          child: Text("${terms[index]}", textScaleFactor: 2,),
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



// Widget newClassPopUp(BuildContext context, List<String> terms) {
//   var termYear;
//   var term;
//   List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer", "Other"];
//   List<DropdownMenuItem> listOfTerms = [];
//   for(var l = 0; l < listOfTermsRaw.length; l++){
//     listOfTerms.insert(0, DropdownMenuItem(child: Text("${listOfTermsRaw[l]}")));
//   }
//   List<DropdownMenuItem> listOfYears = [];
//   for(var i = 2015; i <= DateTime.now().year; i++){
//     listOfYears.insert(0, DropdownMenuItem(child: Text("$i")));
//   }
//
//   return AlertDialog(
//     title: Text("Add a new Term"),
//     content: SizedBox(
//       child: Form(
//           child: Column(children: [
//             DropdownButton(
//               hint: Text(""),
//               onChanged: (str) {
//                 setState(var str){
//                   term = str;
//                 }
//                 setState((str) { });
//               },
//               value: term,
//               isExpanded: true,
//               items: listOfTerms,
//             ),
//             DropdownButton(
//               hint: Text("Year"),
//               onChanged: (value) {
//                 setState(var value){
//                   term = value;
//                 }
//                 setState((value) { });
//               },
//               value: term,
//               isExpanded: true,
//               items: listOfYears,
//             ),
//             RaisedButton(onPressed: (){
//               terms.insert(0, "$term");
//               Navigator.pop(context);
//               }, child: Text("Add"))
//           ])),
//       width: 100,
//       height: 175,
//     ));
// }



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
  var term;

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
                  value: term,
                  items: listOfTerms,
                  onChanged: (newTerm) {
                    setState(() {
                      term = newTerm;
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
                  thisTerms.insert(0, "$term" + " " + "$termYear");
                  Navigator.pop(context);
                }, child: Text("Add"))
              ])),
          width: 100,
          height: 175,
        ));
  }
}


