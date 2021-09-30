import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MessageBar{
  String title, msg;
  BuildContext context;

  MessageBar({this.title, this.msg, this.context});


  void show(){
    Flushbar(
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      icon: Icon(
            Icons.info_outline,
            size: 38,
            color: Colors.red.shade900,
      ),
      //leftBarIndicatorColor: Theme.of(context).primaryColor,
      title: title,
      message: msg,
      borderRadius: 10,
      maxWidth: MediaQuery.of(context).size.width -30,
      padding: EdgeInsets.all(20),
      duration: Duration(seconds: 6),
      flushbarPosition: FlushbarPosition.BOTTOM,
      forwardAnimationCurve: Curves.easeIn,
      borderWidth: 4,
      backgroundGradient: LinearGradient(
       colors: [ Theme.of(context).primaryColor, Theme.of(context).accentColor],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(4, 4),
          blurRadius: 3,
        )
      ],


    ).show(context);
  }

}