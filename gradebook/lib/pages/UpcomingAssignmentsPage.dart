import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingAssignments extends StatefulWidget {
  @override
  _UpcomingAssignments createState() => _UpcomingAssignments();
}

class _UpcomingAssignments extends State<UpcomingAssignments> {



  @override
  build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).buttonColor,
          iconSize: 25,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Upcoming", style: Theme.of(context).textTheme.headline1,),
      ),
      // body: TODO: add list of upcoming assignments,
    );
  }
}
