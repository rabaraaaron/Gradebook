import 'package:flutter/material.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';


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
  var manuallyEnteredGPA = false;
  // TODO: add isCompleted to terms
  Form form;
  TextEditingController gpaController = TextEditingController();

  _TermOptionsState(t) {
    term = t;
    addedTerm = t.name;
    termYear = t.year;
    //TODO: add hypothetical field?
    // manuallyEnteredGPA = term.manuallyEnteredGPA;
    gpaController.text = t.gpa.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
      padding: EdgeInsets.only(top: 10),

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
            value: manuallyEnteredGPA,
            onChanged: (manuallyEntered) {
              setState(() {
                manuallyEnteredGPA = manuallyEntered;
              });
            },
          ),
          Text(
            "Manually enter GPA",
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 20,),
        ]
    );

    TextFormField gpaFormField = TextFormField(
      autofocus: true,
      textAlign: TextAlign.center,
      controller: gpaController,
      keyboardType: TextInputType.number,
      validator:
          (value) {
        if (value == null || value.isEmpty || double.tryParse(value) == null) {
          MessageBar(
            context: context,
            title: 'Invalid Term GPA',
            msg: 'Please enter a valid Term GPA.',
          ).show();
          return 'Required field.';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "ex 4.00",
        labelText: 'Term GPA',
      ),
    );


    if(manuallyEnteredGPA) {
      form = Form(
        key: _formKey,
          child: Column(
              children: [
                container,
                gpaFormField,
                SizedBox(height: 5,),
                row,
              ]
          )
      );
    } else{
      form = Form(
        key: _formKey,
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
            //TODO: add manually entered term gpa to database using gpaController.text
            if(_formKey.currentState.validate()){
              print(gpaController.text);
              termService.updateTerm(term.termID, addedTerm, termYear);
            }
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
