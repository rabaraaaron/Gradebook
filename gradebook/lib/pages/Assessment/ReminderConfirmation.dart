// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReminderConfirmation extends StatelessWidget {
  String assignmentName;
  DateTime d;

  ReminderConfirmation(String assignment, DateTime d) {
    this.assignmentName = assignment;
    this.d = d;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          "Reminder Confirmation",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        Text(
          '\n$assignmentName reminder was set for:\n\n'
              '${d.toString()}',
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20.0
          ),
        ),
        SizedBox(height: 20),
      ]),
    );
  }
}