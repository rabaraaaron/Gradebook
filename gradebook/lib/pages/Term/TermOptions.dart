import 'package:flutter/material.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/utils/customDialog.dart';


// ignore: must_be_immutable
class TermOptions extends StatefulWidget {
  Term term;

  TermOptions(t) {
    term = t;
  }
  @override
  _TermOptionsState createState() => _TermOptionsState(term);
}

class _TermOptionsState extends State<TermOptions> {
  Term term;
  var termYear;
  var addedTerm;
  var isCompletedTerm = false;
  // TODO: add isCompleted to terms
  Form form;
  TextEditingController gpaController = TextEditingController();

  _TermOptionsState(t) {
    term = t;
    addedTerm = term.name;
    termYear = term.year;
    //TODO: add hypothetical field?
    // isCompletedTerm = term.isCompletedTerm;
  }

  @override
  Widget build(BuildContext context) {
    TermService termService = new TermService();

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

    Row row = Row(
        children: [
          Switch(
            activeColor: Theme.of(context).accentColor,
            value: isCompletedTerm,
            onChanged: (updateIsHypothetical) {
              setState(() {
                isCompletedTerm = updateIsHypothetical;
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
      width: 154.00,
      child: gpaFormField,
    );

    if(isCompletedTerm) {
      form = Form(
          child: Column(
              children: [
                container,
                row,
                gpaBox,
                SizedBox(height: 15,),
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

    SizedBox confirmButton = SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          onPressed: () async {
            //TODO: send update to database --- (By Mohd) this is done but the switch for completed term is still not doing anything
            //TODO: add isCompleted to the updateTerm method
            
            termService.updateTerm(term.termID, addedTerm, termYear);
            // print(addedTerm); To get the term name
            // print(termYear); To get the term year
            // print(isHypothetical); Bool for if this is a hypothetical term
            // await term.addTerm(addedTerm, termYear);
            // Navigator.pop(context);
            Navigator.pop(context);
            setState(() {});

          },
          child: Text("Confirm",  style: Theme.of(context).textTheme.headline3,)
      ),
    );

    return CustomDialog(title: "Term Options", context: context, form: form, button: confirmButton).show();
  }
}
