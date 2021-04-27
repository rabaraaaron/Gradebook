import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/api/FirebaseApi.dart';
import 'package:gradebook/api/FirebaseFile.dart';
import 'package:gradebook/model/Assessment.dart';
import 'package:gradebook/services/assessment_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;

class ImagePageWrap extends StatelessWidget {
  String termID;
  String courseID;
  String catID;
  Assessment a;
  ImagePageWrap(
      {Key key, @required this.termID, this.courseID, this.catID, this.a}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Assessment>>.value(
      value: AssessmentService(termID, courseID, catID).assessments,
      child: ImagePage(a: this.a,),
    );
  }
}



class ImagePage extends StatefulWidget{
  final Assessment a;

  const ImagePage({this.a});

  @override
  _ImagePageState createState() => _ImagePageState(this.a);
}

class _ImagePageState extends State<ImagePage> {

  Assessment a;
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<List<FirebaseFile>> futureFiles;
  FirebaseFile f;

  _ImagePageState(Assessment a){
    this.a = a;
  }

  @override
  void initState(){
    super.initState();
    futureFiles = FirebaseApi
        .listAll('${auth.currentUser.uid}/');
    futureFiles.then((value) {
      print("Length: " + value.length.toString());
      // value.forEach((element) {print(element.url + " " + element.name);});
    });

  }

  @override
  Widget build(BuildContext context) {

  PDFViewController _controller;
  int _currentPage = 0;
  int _totalPages = 0;
  bool pdfReady = false;

    FutureBuilder<List<FirebaseFile>> futureBuilder = FutureBuilder(
      future: futureFiles,
      builder: (context, snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).accentColor,
            ),);
          default:
            if(snapshot.hasError){
              return Center(child: Text('Some error occurred!'),);
            } else{
              int i;
              List<FirebaseFile> fileList = snapshot.data;
              for(i = 0; i < fileList.length; i++) {
                print(fileList[i].url);
                print(a.downloadURL);
                if(fileList[i].url.contains(new RegExp(a.downloadURL))){
                  print("Found!!!");
                  f = fileList[i];
                  i = fileList.length;


                  if(a.downloadURL.contains(new RegExp('.png'))
                   || a.downloadURL.contains(new RegExp('.jpg'))
                   || a.downloadURL.contains(new RegExp('.jpeg'))){
                    return Image.network(
                      f.url,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    );
                  } else{
                    // return Text('Will show pdf soon.');
                    print("From here: "+f.url);

                    return Stack(
                      children: <Widget>[
                        // Text('Will show pdf soon.'),
                        PDFView(
                          filePath: f.url,
                          enableSwipe: true,
                          autoSpacing: true,
                          pageSnap: true,
                          swipeHorizontal: true,
                          onRender: (_pages){
                            setState(() {
                              _totalPages = _pages;
                              pdfReady = true;
                            });
                          },
                          onPageChanged: (int page, int total){
                            setState(() {});
                          },
                          onViewCreated: (PDFViewController vc){
                            _controller = vc;
                          },
                          onPageError: (page, e){},
                        ),

                      ],
                    );

                    //read as pdf
                  }
                }
              }
              return Container(color: Colors.blue,);
            }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          iconSize: 35,
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(a.name, style: Theme.of(context).textTheme.headline1,),
        centerTitle: true,
      ),
      body: futureBuilder,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _currentPage > 0
              ? FloatingActionButton.extended(
            backgroundColor: Colors.red,
            label: Text("Go to ${_currentPage - 1}"),
            onPressed: () {
              _currentPage -= 1;
              _controller.setPage(_currentPage);
            },
          )
              : Offstage(),
          _currentPage+1 < _totalPages
              ? FloatingActionButton.extended(
            backgroundColor: Colors.green,
            label: Text("Go to ${_currentPage + 1}"),
            onPressed: () {
              _currentPage += 1;
              _controller.setPage(_currentPage);
            },
          )
              : Offstage(),
        ],
      ),
    );
  }
}
