import 'package:flutter/material.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/utils/customDialog.dart';


// ignore: must_be_immutable
class NewTerm extends StatefulWidget {
  var c;
  var termsList;

  NewTerm(context, terms) {
    c = context;
    termsList = terms;
  }
  @override
  _NewTermState createState() => _NewTermState(c, termsList);
}

class _NewTermState extends State<NewTerm> {
  var thisContext;
  var thisTerms;
  var termYear = DateTime.now().year;
  var addedTerm;
  var termIsCompleted = false;
  Form form;
  TextEditingController gpaController = TextEditingController();



  _NewTermState(context, terms) {
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
    for (var i = 2015; i <= DateTime.now().year + 1; i++) {
      listOfYears.insert(
          0,
          DropdownMenuItem(
            child: Text("$i"),
            value: i,
          ));
    }

    Container container = Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton(
              hint: Center(
                child: Text(
                  "Term",
                  style: Theme.of(context).textTheme.headline3,
                ),
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
          ),
          SizedBox(width: 20,),
          Expanded(
            child: DropdownButton(
              hint: Center(
                child: Text(
                  "Year",
                  style: Theme.of(context).textTheme.headline3,
                ),
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
          ),
        ],
      ),
    );

    TextFormField gpaFormField = TextFormField(
      textAlign: TextAlign.center,
      controller: gpaController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: "ex 4.00",
        labelText: 'Term GPA',
      ),
    );

    SizedBox gpaBox = SizedBox(
      width: 155.00,
      child: gpaFormField,
    );


    Row row = Row(
        children: [
          Switch(
            activeColor: Theme.of(context).accentColor,
            value: termIsCompleted,
            onChanged: (updatetermIsCompleted) {
              setState(() {
                termIsCompleted = updatetermIsCompleted;
              });
            },
          ),
          Text(
            "Completed term",
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 20,),
        ]
    );


    if(termIsCompleted){
      form = Form(
          child: Column(
              children: [
                container,
                row,
                gpaBox,
                SizedBox(height: 15,)
              ]
          )
      );

    } else{
      form = Form(
          child: Column(
              children: [
                container,
                row,
              ]
          )
      );
    }



    SizedBox addButton = SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
          //color: Theme.of(context).primaryColor,
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          onPressed: () async {
            //TODO: add termIsComplete to the addTerm method
            await term.addTerm(addedTerm, termYear);
            Navigator.pop(context);
          },
          child: Text("Add",  style: Theme.of(context).textTheme.headline3,)
      ),
    );

    return CustomDialog(title: 'Add Term', context: context, form: form, button: addButton).show();

  }
}
