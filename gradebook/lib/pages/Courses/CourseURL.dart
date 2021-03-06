import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/api/FirebaseApi.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/model/Course.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/services/course_service.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';



class CourseURLWrapper extends AlertDialog {
  String termID;
  int index;

  CourseURLWrapper(
      {this.termID, this.index});


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Course>>.value(
      value: CourseService(termID).courses,
      child: CourseURL(this.termID, this.index),
    );
  }
}

// ignore: must_be_immutable
class CourseURL extends StatefulWidget{
  String termID;
  int index;

  CourseURL(String termID, int i){
    this.termID = termID;
    this.index = i;

  }

  @override
  _CourseURLState createState() =>
      _CourseURLState(this.termID, this.index);
}

class _CourseURLState extends State<CourseURL> {
  File file;
  CourseService courseService;
  List<Course> c;
  String termID;
  Widget urlFieldWidget;
  TextEditingController urlController = TextEditingController();
  int index;


  _CourseURLState(  String termID, int i){
    this.termID = termID;
    this.index = i;
  }


  Future uploadURL(String url) async {
    courseService.updateCourseURL(c[index].id, '$url');
    urlController.text = "";
    print("This is a url");
  }


  @override
  Widget build(BuildContext context) {
    c = Provider.of<List<Course>>(context);
    courseService = CourseService(termID);
    String str = "";

    if(Provider.of<List<Course>>(context) != null){
      Course course = c.elementAt(index);
      str = course.name;
    }

    var isThere;
    if(c != null){
      if(c.elementAt(index).url != null){
        isThere = c.elementAt(index).url;
      }
    }

    ElevatedButton uploadButton = ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          alignment: Alignment.centerLeft,
          backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).accentColor.withOpacity(.7)
          )
      ),
      onPressed: () {
        uploadURL(urlController.text);
      },
      child: Icon(Icons.upload_outlined,
        color: Colors.white,
        size: 35,
      ),
    );



    urlFieldWidget =
    Padding(
      padding: const EdgeInsets.only(left:15, right: 15, bottom: 20, top: 0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 200,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                  ),
                ),
              ),
              SizedBox(width: 5,),
              uploadButton,
            ],
          ),
          SizedBox(height: 10,),
          isThere != null ?
          Row(
            children: [
              SizedBox(
                  width: 200,
                  height: 75,
                  child: Text(
                      "Uploaded: ${c.elementAt(index).url}"
                  )
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).accentColor.withOpacity(.7)
                      )
                  ),
                  child: Icon(Icons.delete, size: 35,),
                  onPressed: (){
                    setState(() {
                    });
                  }
              )
            ],
          ) :
          Text("No url uploaded"),
        ],
      ),
    );




    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   "Content Uploader",
              //   style: Theme.of(context).textTheme.headline5,
              // ),
              // Divider(color: Theme.of(context).dividerColor,),
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                decoration: BoxDecoration(

                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                ),
                child: Center(child: Text("Content Uploader", style: Theme.of(context).textTheme.bodyText1,),),
              ),
              SizedBox(height: 20,),
              Text(
                "Attach content to: $str",
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 20,),

              Row(
                children: [
                  urlFieldWidget,
                ],
              ),
            ]
        ),
      ),

    );


  }
}