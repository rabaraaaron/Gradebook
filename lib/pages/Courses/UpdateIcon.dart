

// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/utils/IconOptions.dart';

class UpdateIcon extends StatefulWidget {
  String termID;
  String courseID;

  UpdateIcon(String tID, String c){
    termID = tID;
    courseID = c;
  }


  @override
  _UpdateIcon createState() => _UpdateIcon(termID, courseID);

}

class _UpdateIcon extends State<UpdateIcon> {
  String termID;
  String courseID;

  _UpdateIcon(String tID, String cID){
    termID = tID;
    courseID = cID;
  }


  @override
  Widget build(BuildContext context) {

    IconOptions options = IconOptions(termID, courseID);

    return AlertDialog(
      content: SingleChildScrollView(
        child: SizedBox(
          height: 250,
          width: 150,
          child: GridView.count(
            crossAxisCount: 4,
            children: options.getAllIcons(),
          ),
        ),
      ),

    );
  }

}
