import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gradebook/api/FirebaseApi.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';


class PickFileToUploadWrapper extends StatelessWidget {
  String termID;
  String courseID;
  String catID;
  int index;
  PickFileToUploadWrapper(
      {this.termID, this.courseID, this.catID, this.index});


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Assessment>>.value(
      value: AssessmentService(termID, courseID, catID).assessments,
      child: PickFileToUpload(this.termID, this.courseID, this.catID, this.index),
    );
  }
}

// ignore: must_be_immutable
class PickFileToUpload extends StatefulWidget{
  String termID;
  String courseID;
  String catID;
  int index;

  PickFileToUpload(String termID, String courseID,
      String catID, int index){
    this.termID = termID;
    this.courseID = courseID;
    this.catID = catID;
    this.index = index;
  }

  @override
  _PickFileToUploadState createState() =>
      _PickFileToUploadState(this.termID, this.courseID, this.catID, this.index);
}

class _PickFileToUploadState extends State<PickFileToUpload> {
  File file;
  AssessmentService assService;
  UploadTask task;
  List<Assessment> a;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String termID;
  String courseID;
  String catID;
  int index;


  _PickFileToUploadState(  String termID, String courseID, String catID,
      int index){
    this.termID = termID;
    this.courseID = courseID;
    this.catID = catID;
    this.index = index;
  }

  Future selectFile() async {
    print("reached select file ");
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if(result == null) return;
    final path = result.files.single.path;

    file = File(path);
    setState(() {

    });
  }

  Future uploadFile() async {
    if(file == null) return null;

    String url = a[index].downloadURL;

    final filename = basename(file.path);
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    final destination = '${auth.currentUser.uid}/$now$filename';


    task = FirebaseApi.uploadFile(destination, file);
    if(url != null){
      FirebaseApi.deleteFile(a[index].downloadURL);
    } else{
      print("URL is null for assessment ${a[index].name}");
    }
    setState(() {});
    if(task == null) return null;

    final snapshot = await task.whenComplete((){});
    final urlDownload = await snapshot.ref.getDownloadURL();
    // print('Download-Link: $urlDownload');
    assService.updateDownloadURL(a[index], '$now$filename');
  }

  Future deleteFile() async {

    String url = a[index].downloadURL;

    if(url != null){
      FirebaseApi.deleteFile(a[index].downloadURL);
      assService.updateDownloadURL(a[index], null);
      print('Successful delete');
    } else{
      print("URL is null for assessment ${a[index].name}");
    }
    setState(() {});


  }
  
  Widget buildUploadStatus(UploadTask task) =>
      StreamBuilder<TaskSnapshot>(
          stream: task.snapshotEvents,
          builder: (context, snapshot){
            if(snapshot.hasData){
              final snap = snapshot.data;
              double progress = snap.bytesTransferred / snap.totalBytes;
              String progressStr = (progress * 100).toStringAsFixed(2);
              return progress != 1.0 ?
                Text('$progressStr %',) :
                  Icon(Icons.check, color: Colors.green,);

            } else{return Container();}
          }

      );



  @override
  Widget build(BuildContext context) {
    a = Provider.of<List<Assessment>>(context);
    assService = AssessmentService(termID, courseID, catID);
    final fileName = file != null ? basename(file.path) : "No file selected";

    String str = "";
    if(Provider.of<List<Assessment>>(context) != null){
      Assessment assessment = a.elementAt(index);
      str = assessment != null ? assessment.name : 'Picture';
    }

    var isThere;
    if(a != null){
      if(a.elementAt(index).downloadURL != null){
        isThere = a.elementAt(index).downloadURL;
      }
    }

    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "File Uploader",
              style: Theme.of(context).textTheme.headline6,
            ),
            Divider(color: Theme.of(context).dividerColor,),
            Text(
              "Upload a file to assessment $str?",
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).accentColor.withOpacity(.7)
                  )
              ),
              onPressed: () {
                selectFile();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Select File ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.folder, color: Colors.white,),
                    iconSize: 35,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            isThere != null ?
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                        height: 75,
                        child: Text(
                            "Uploaded: ${a.elementAt(index).downloadURL}"
                        )
                    ),
                    ElevatedButton(
                        child: Icon(Icons.delete, size: 35,),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Theme.of(context).accentColor.withOpacity(.7))
                        ),
                        onPressed: (){
                          deleteFile();

                          setState(() {
                          });
                        }
                    )
                  ],
                ) :
                Text("No file uploaded"),

            SizedBox(height: 20,),

            Row(
              children: [
                SizedBox(
                  height: 75,
                  width: 200,
                  child: Text(
                    "Chosen file: "+fileName,
                    style: TextStyle(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).accentColor.withOpacity(.7)
                      )
                  ),
                  onPressed: () {
                    uploadFile();
                    // assService.uploadFile(assessments[index].id, assessments[index]);
                  },
                  child: Icon(Icons.cloud_upload,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
            task != null ? buildUploadStatus(task) : Container(),
          ]
      ),

    );


  }
}