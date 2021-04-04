import 'package:flutter/material.dart';

class CustomDialog{
  Form form;
  Widget button;
  BuildContext context;


  CustomDialog({this.button, this.form, this.context});


  Widget show(){
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      content: Container(
        width: 3300.0,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
              ),
              child: Center(child: Text("Add Course", style: Theme.of(context).textTheme.bodyText1,),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: form,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              height: 2.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                //color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0)),
              ),
              child: button,
            ),
          ],
        ),
      ),
    );

  }
}



