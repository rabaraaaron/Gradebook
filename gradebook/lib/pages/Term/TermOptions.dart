import 'package:flutter/material.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/utils/customDialog.dart';


// ignore: must_be_immutable
class TermOptions extends StatefulWidget {
  var termsList;

  TermOptions(t) {
    termsList = t;
  }
  @override
  _TermOptionsState createState() => _TermOptionsState(termsList);
}

class _TermOptionsState extends State<TermOptions> {
  Term term;
  var termYear;
  var addedTerm;
  var isCompletedTerm = false;
  Form form;

  _TermOptionsState(t) {
    term = t;
    addedTerm = term.name;
    termYear = term.year;
    //TODO: add hypothetical field?
    // this.isHypothetical = term.isHypothetical;
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
                      value: isCompletedTerm,
                      onChanged: (updateisHypothetical) {
                        setState(() {
                          isCompletedTerm = updateisHypothetical;
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

    SizedBox confirmButton = SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          onPressed: () async {
            //TODO: send update to database
            // print(addedTerm); To get the term name
            // print(termYear); To get the term year
            // print(isHypothetical); Bool for if this is a hypothetical term
            // await term.addTerm(addedTerm, termYear);
            // Navigator.pop(context);
          },
          child: Text("Confirm",  style: Theme.of(context).textTheme.headline3,)
      ),
    );

    return CustomDialog(title: "Term Options", context: context, form: form, button: confirmButton).show();
  }
}
