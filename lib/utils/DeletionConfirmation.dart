import 'package:flutter/material.dart';

class DeletionConfirmation extends StatelessWidget{
  String title;
  String content;

  DeletionConfirmation(String titleText, String contentText){
    title = titleText;
    content = contentText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
      content: Text(content,),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            return true;
          },
          child: Text("Delete", textScaleFactor: 1.25,),
        ),
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
            return false;
            },
          child: Text("Close", textScaleFactor: 1.25,),
        ),
      ],
    );
  }
}
