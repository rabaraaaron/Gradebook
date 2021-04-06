import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class CustomDialog{
  String title;
  Form form;
  Widget button;
  BuildContext context;


  CustomDialog({this.button, this.form, this.title, this.context});


  Widget show(){
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      content: SingleChildScrollView(
        child: Container(
          //width: 20.0,
          //height: MediaQuery.of(context).size.height*.3,
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
                child: Center(child: Text(title, style: Theme.of(context).textTheme.bodyText1,),),
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
      ),
    );

  }
}



