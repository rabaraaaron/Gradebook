import 'package:flutter/material.dart';
import 'package:gradebook/model/Term.dart';
import 'package:gradebook/services/term_service.dart';


// ignore: must_be_immutable
class DeleteTermConfirmation extends StatelessWidget{
  List<Term> terms;
  int index;

  DeleteTermConfirmation(List<Term> list, int i){
    terms = list;
    index = i;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Delete Term",
              style: Theme.of(context).textTheme.headline4,
            ),
            Divider(color: Theme.of(context).dividerColor,),
            Text(
              "Are you sure you want to delete the ${terms[index].name} ${terms[index].year} term?",
              style: Theme.of(context).textTheme.headline3,
            ),
          ]
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.red,
          height: 40,
          onPressed: () {
            TermService().deleteTerm("${terms[index].name}", terms[index].year);
            Navigator.pop(context);
          },
          child: Text(
            "Delete",
            textScaleFactor: 1.25,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

}