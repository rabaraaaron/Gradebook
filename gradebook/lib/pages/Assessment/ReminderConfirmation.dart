import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
              'Day: ${d.toString().substring(0, 10)}'
              '\nTime: ${d.toString().substring(10, 16)}',
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 25.0
          ),
        ),
        SizedBox(height: 20),
      ]),
    );
  }
}