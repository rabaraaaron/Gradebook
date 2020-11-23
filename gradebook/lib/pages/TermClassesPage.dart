import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradebook/utils/menuDrawer.dart';
import 'package:provider/provider.dart';


class TermClassesPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermClassesPage> {
  StreamProvider<List<Course>>

  // final List<String> classes = ["CS 371", "CS 499", "GEOS 201", "MILS 401"];
  final SlidableController slidableController = new SlidableController();
  final GlobalKey scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    //Random rand = new Random();
    return Scaffold(
      key: scaffoldKey,
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text(
          "Fall 2020",
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        leading:
          Builder(
            builder: (context) =>
                Center(
                  child: IconButton(
                      icon: Icon(Icons.menu_sharp, color: Colors.white,),
                      iconSize: 30,
                      onPressed: (){
                        Scaffold.of(context).openDrawer();
                      }),
                ),
          ),
        actions: [IconButton(icon: Icon(Icons.add), iconSize: 35, color: Colors.white,
            onPressed: () async{
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    newClassPopUp(context, classes),
              );
              setState(() {});
            }
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details){
          if(details.primaryVelocity > 0){
            Navigator.pop(context);
          }
        },
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
            indent: 25.0,
            endIndent: 25.0,
          ),
          itemCount: classes.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(0.0),
            child: Slidable(
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: .2,
              secondaryActions: [
                IconSlideAction(
                  color: Colors.transparent,
                  closeOnTap: true,
                  iconWidget: Icon(Icons.more_vert, color: Colors.white, size: 35,),
                  onTap: () => null,
                ),
                IconSlideAction(
                  color: Colors.transparent,
                  closeOnTap: true,
                  iconWidget: Icon(Icons.delete, color: Colors.white, size: 35,),
                )
              ],
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Icon(Icons.computer, size: 50,),
                        padding: EdgeInsets.all(10.0),),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, '/Categories');
                          },
                          child: new Padding(
                            padding: new EdgeInsets.all(20.0),
                            child: Text(
                              "${classes[index]}",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              child: Text("A", textScaleFactor: 2, style: Theme.of(context).textTheme.headline3,),
                            ),
                            Container(
                              child: Text("97%", textScaleFactor: 2, style: Theme.of(context).textTheme.headline3,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}



Widget newClassPopUp(BuildContext context, List<String> terms) {
  final classTitleController = TextEditingController();
  final creditHoursController = TextEditingController();

  List<String> listOfTermsRaw = ["Fall", "Winter", "Spring", "Summer", "Other"];
  List<DropdownMenuItem> listOfTerms = [];
  for(var l = 0; l < listOfTermsRaw.length; l++){
    listOfTerms.insert(0, DropdownMenuItem(child: Text("${listOfTermsRaw[l]}")));
  }
  List<DropdownMenuItem> listOfYears = [];
  for(var i = 2015; i <= DateTime.now().year; i++){
    listOfYears.insert(0, DropdownMenuItem(child: Text("$i")));
  }


  return AlertDialog(
      title: Text("Add a new Class", style: Theme.of(context).textTheme.headline2,),
      content: SizedBox(
        child: Form(
            child: Column(children: [
              TextFormField(
                controller: classTitleController,
                decoration: const InputDecoration(
                  hintText: "ex CS 101",
                  labelText: 'Class Title',
                ),
              ),
              TextFormField(
                controller: creditHoursController,
                decoration: const InputDecoration(
                  hintText: "ex 4",
                  labelText: 'Credit Hours',
                ),
              ),
              RaisedButton(
                  onPressed: (){
                    terms.insert(0, classTitleController.text);
                    if(int.parse(creditHoursController.text) is int){
                      print(creditHoursController.text);
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Add")
              )
            ])
        ),
        width: 100,
        height: 175,
      ));
}


