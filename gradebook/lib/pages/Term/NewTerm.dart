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
  var termYear;
  var addedTerm;
  var checked = false;
  Form form;

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
    for (var i = 2015; i <= DateTime.now().year; i++) {
      listOfYears.insert(
          0,
          DropdownMenuItem(
            child: Text("$i"),
            value: i,
          ));
    }

    form = Form(
        child: Column(
            children: [
              Container(
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
              ),

              Row(
                  children: [
                    Switch(
                      activeColor: Theme.of(context).accentColor,
                      value: checked,
                      onChanged: (updateChecked) {
                        setState(() {
                          checked = updateChecked;
                        });
                      },
                    ),
                    Text(
                      "Completed term",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(height: 20,),
                  ]
              ),
            ]
        )
    );

    SizedBox addButton = SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
          //color: Theme.of(context).primaryColor,
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          onPressed: () async {
            await term.addTerm(addedTerm, termYear);
            Navigator.pop(context);
          },
          child: Text("Add",  style: Theme.of(context).textTheme.headline3,)
      ),
    );

    return CustomDialog(title: 'Add Term', context: context, form: form, button: addButton).show();

      AlertDialog(
      title: Column(children: [
        Text("Add Term",
          style: Theme.of(context).textTheme.headline4,
        ),
        Divider(color: Theme.of(context).dividerColor),
      ],),
        content: SizedBox(
          child: form,
          width: 100,
          height: 145,
        ),
      actions: [addButton],
    );
  }
}
