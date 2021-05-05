import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gradebook/api/FirebaseApi.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:gradebook/utils/loading.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class PickFileToUploadWrapper extends StatelessWidget {
  String termID;
  String courseID;
  String catID;
  int index;
  PickFileToUploadWrapper({this.termID, this.courseID, this.catID, this.index});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Assessment>>.value(
      value: AssessmentService(termID, courseID, catID).assessments,
      child:
          PickFileToUpload(this.termID, this.courseID, this.catID, this.index),
    );
  }
}

// ignore: must_be_immutable
class PickFileToUpload extends StatefulWidget {
  String termID;
  String courseID;
  String catID;
  int index;

  PickFileToUpload(String termID, String courseID, String catID, int index) {
    this.termID = termID;
    this.courseID = courseID;
    this.catID = catID;
    this.index = index;
  }

  @override
  _PickFileToUploadState createState() => _PickFileToUploadState(
      this.termID, this.courseID, this.catID, this.index);
}

class _PickFileToUploadState extends State<PickFileToUpload> {
  File file;
  AssessmentService assService;
  UploadTask task;
  List<Assessment> a;
  String termID;
  String courseID;
  String catID;
  int index;
  String fileName;
  bool selectingFile = false;
  bool urlBeingSelected = false;
  Widget urlFieldWidget;
  Widget selectFileWidget;
  TextEditingController urlController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  _PickFileToUploadState(
      String termID, String courseID, String catID, int index) {
    this.termID = termID;
    this.courseID = courseID;
    this.catID = catID;
    this.index = index;
  }

  Future selectFile({bool gallery}) async {
    var result;
    if (gallery != null) {
      result = await ImagePicker.platform.pickImage(source: ImageSource.camera);
    } else {
      result =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    }

    if (result == null) return;
    final path = result.path;

    file = File(path);
    setState(() {});
  }

  Future uploadFile([String url]) async {
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    String oldPath = a[index].downloadURL;
    bool oldIsPicture = false;

    if (oldPath != null) {
      oldIsPicture = oldPath.contains(new RegExp(".png")) ||
          oldPath.contains(new RegExp(".jpg")) ||
          oldPath.contains(new RegExp(".jpeg"));
    }

    if (selectingFile) {
      if (file == null) return null;

      String filename = basename(file.path);
      final destination = '${auth.currentUser.uid}/$now$filename';
      String path = file.path;
      bool isPicture = path.contains(new RegExp(".png")) ||
          path.contains(new RegExp(".jpg")) ||
          path.contains(new RegExp(".jpeg"));

      if (path != null) {
        if (isPicture) {
          task = FirebaseApi.uploadFile(destination, file);
        }
        if (a[index].downloadURL != null) {
          FirebaseApi.deleteFile(a[index].downloadURL);
        }
      } else {
        print("URL is null for assessment ${a[index].name}");
      }
      setState(() {});
      if (task == null) return null;

      assService.updateDownloadURL(a[index], '$now$filename');
    } else {
      assService.updateDownloadURL(a[index], '$now$url');
      if (oldIsPicture) {
        FirebaseApi.deleteFile(a[index].downloadURL);
      }
      urlController.text = "";
      print("This is a url");
    }
  }

  Future deleteFile() async {
    String url = a[index].downloadURL;
    bool isPicture = url.contains(new RegExp(".png")) ||
        url.contains(new RegExp(".jpg")) ||
        url.contains(new RegExp(".jpeg"));

    if (url != null) {
      if (isPicture) {
        FirebaseApi.deleteFile(a[index].downloadURL);
      }
      assService.updateDownloadURL(a[index], null);
    } else {
      print("URL is null for assessment ${a[index].name}");
    }
    setState(() {});
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data;
          double progress = snap.bytesTransferred / snap.totalBytes;
          String progressStr = (progress * 100).toStringAsFixed(2);
          return progress != 1.0
              ? Text(
                  '$progressStr %',
                )
              : Icon(
                  Icons.check,
                  color: Colors.green,
                );
        } else {
          return Container();
        }
      });

  @override
  Widget build(BuildContext context) {
    a = Provider.of<List<Assessment>>(context);
    assService = AssessmentService(termID, courseID, catID);
    fileName = file != null ? basename(file.path) : "No image selected";
    String str = "";

    if (Provider.of<List<Assessment>>(context) != null) {
      Assessment assessment = a.elementAt(index);
      str = assessment != null ? assessment.name : 'Picture';
    }

    var isThere;
    if (a != null) {
      if (a.elementAt(index).downloadURL != null) {
        isThere = a.elementAt(index).downloadURL;
      }
    }

    RaisedButton enterURLButton = RaisedButton(
      color: Theme.of(context).accentColor.withOpacity(.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0)),
        side: BorderSide(
            width: 2, color: Theme.of(context).dividerColor.withOpacity(.3)),
      ),
      onPressed: () {
        setState(() {
          urlBeingSelected = true;
          selectingFile = false;
        });
      },
      child: Row(
        children: [
          Text(
            "URL   ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.link,
              color: Colors.white,
            ),
            iconSize: 35,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );

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
              (states) => Theme.of(context).accentColor.withOpacity(.7))),
      onPressed: () {
        if (selectingFile) {
          uploadFile();
        } else {
          uploadFile(urlController.text);
        }
      },
      child: Icon(
        Icons.upload_outlined,
        color: Colors.white,
        size: 35,
      ),
    );
    Widget takeImageButton = selectingFile
        ? ElevatedButton(
            onPressed: () {
              selectFile(gallery: true);
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                alignment: Alignment.centerLeft,
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).accentColor.withOpacity(.7))),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Camera ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 35,
                  ),
                ],
              ),
            ),
          )
        : Container();

    Widget getFromGalleryButton = selectingFile
        ? ElevatedButton(
            onPressed: () {
              selectFile();
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                alignment: Alignment.centerLeft,
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).accentColor.withOpacity(.7))),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Gallery  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 35,
                  ),
                ],
              ),
            ),
          )
        : Container();

    Widget selectImageButton = Expanded(
      child: RaisedButton(
        color: Theme.of(context).accentColor.withOpacity(.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(32.0)),
          side: BorderSide(
              width: 2, color: Theme.of(context).dividerColor.withOpacity(.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Image ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.image,
                color: Colors.white,
              ),
              iconSize: 35,
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            urlBeingSelected = false;
            selectingFile = true;
          });
        },
      ),
    );

    selectFileWidget = selectingFile
        ? Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                getFromGalleryButton,
                SizedBox(
                  height: 10,
                ),
                takeImageButton,
                SizedBox(
                  height: 20,
                ),
                isThere != null
                    ? Row(
                        children: [
                          SizedBox(
                              height: 75,
                              width: 200,
                              child: Text(
                                "Uploaded: ${a.elementAt(index).downloadURL.substring(13)}",
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 2,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                              child: Icon(
                                Icons.delete,
                                size: 35,
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context)
                                              .accentColor
                                              .withOpacity(.7))),
                              onPressed: () {
                                deleteFile();
                                setState(() {});
                              })
                        ],
                      )
                    : Text("No image uploaded "),
                Row(
                  children: [
                    SizedBox(
                      height: 75,
                      width: 200,
                      child: Text(
                        "Chosen image: \n" + fileName,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    uploadButton,
                  ],
                ),
                task != null ? buildUploadStatus(task) : Container(),
              ],
            ),
          )
        : Container();

    ElevatedButton deleteButton = ElevatedButton(
        child: Icon(
          Icons.delete,
          size: 35,
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          alignment: Alignment.centerLeft,
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => Theme.of(context).accentColor.withOpacity(.7)),
        ),
        onPressed: () {
          deleteFile();
          setState(() {});
        });

    urlFieldWidget = urlBeingSelected
        ? Container(
            padding: EdgeInsets.only(right: 15, left: 15, bottom: 5),
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
                    SizedBox(
                      width: 10,
                    ),
                    uploadButton,
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                isThere != null
                    ? Row(
                        children: [
                          SizedBox(
                              height: 75,
                              width: 200,
                              child: Text(
                                "Uploaded: ${a.elementAt(index).downloadURL.substring(13)}",
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 2,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          deleteButton,
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(flex: 2, child: Text("No url uploaded")),
                          deleteButton,
                        ],
                      ),
              ],
            ),
          )
        : Container();

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 0.0),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0)),
            ),
            child: Center(
              child: Text(
                "Content Uploader",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Attach content to: $str",
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(
            height: 20,
          ),
          urlFieldWidget,
          selectFileWidget,
          Row(
            children: [
              enterURLButton,
              selectImageButton,
            ],
          ),
        ]),
      ),
    );
  }
}
