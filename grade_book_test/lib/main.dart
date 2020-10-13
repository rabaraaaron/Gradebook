import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Book Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Courses - Fall 2020'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> classes = ["CS 144", "CS 371", "CS 270", "MATH 245"];

  void _addClass() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _newClassPopUp(context, classes);
    });
  }

  @override
  Widget build(BuildContext context) {
    var rand = new Random();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: classes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 40,
            color: new Color.fromARGB(rand.nextInt(255), rand.nextInt(255),
                rand.nextInt(255), rand.nextInt(255)),
            child: Center(child: Text(classes[index])),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

           await showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _newClassPopUp(context, classes),
            );
         setState(() {
         });
        },
        tooltip: 'Add a Class',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget _newClassPopUp(BuildContext context, List<String> classes) {
  var newClass;
  return AlertDialog(
    title: Text("Add a new class"),
    content: Column(
      children: [
        Form(
            child: Column(children: [
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Class Name'),
            onChanged: (value) {
              setState(var value) { newClass = value;}
              setState(value);
            },
          ),
          RaisedButton(onPressed: (){classes.add(newClass);}, child: Text("Submit"))
        ]))
      ],
    ),

  );
}
