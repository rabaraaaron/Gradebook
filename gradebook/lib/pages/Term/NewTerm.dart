import 'package:flutter/material.dart';
import 'package:gradebook/services/term_service.dart';
import 'package:gradebook/utils/customDialog.dart';
import 'package:gradebook/utils/messageBar.dart';


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
  var manuallySetGPA = false;
  Form form;
  TextEditingController gpaController = TextEditingController();
  TextEditingController creditController = TextEditingController();

  _NewTermState(context, terms) {
    thisContext = context;
    thisTerms = terms;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField(
              validator: (value) {
                if(value == null){
                  return "Required Field";
                }
                return null;
              },
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

    SizedBox gpaBox = SizedBox(
      child: gpaFormField,
    );

    TextFormField creditFormField = TextFormField(
      autofocus: true,
      textAlign: TextAlign.center,
      controller: creditController,
      keyboardType: TextInputType.number,
      validator:
          (value) {
        if (value == null || value.isEmpty || double.tryParse(value) == null) {
          MessageBar(
            context: context,
            title: 'Invalid Term Credits',
            msg: 'Please enter a valid number of Credits.',
          ).show();
          return 'Required field.';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "ex 16.0",
        labelText: 'Term Credits',
      ),
    );

    SizedBox creditsBox = SizedBox(
      child: creditFormField,
    );


    Row row = Row(
        children: [
          Switch(
            activeColor: Theme.of(context).accentColor,
            value: manuallySetGPA,
            onChanged: (updateTermIsCompleted) {
              setState(() {
                manuallySetGPA = updateTermIsCompleted;
              });
            },
          ),
          Text(
            "Manually enter GPA",
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 10,),
        ]
    );


    if(manuallySetGPA){
      form = Form(
        key: _formKey,
          child: Column(
              children: [
                container,
                gpaBox,
                creditsBox,
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



    SizedBox addButton = SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
          //color: Theme.of(context).primaryColor,
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          onPressed: () async {
            //TODO: add manually entered term gpa to database using gpaController.text
            if(_formKey.currentState.validate()){
              await term.addTerm(addedTerm, termYear, manuallySetGPA, double.tryParse(gpaController.text), double.tryParse(creditController.text) );
              Navigator.pop(context);
            }

          },
          child: Text("Add",  style: Theme.of(context).textTheme.headline3,)
      ),
    );

    return CustomDialog(title: 'Add Term', context: context, form: form, button: addButton).show();

  }
}
