

import 'package:flutter/material.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          color: Theme.of(context).buttonColor,
          iconSize: 25,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Membership", style: Theme.of(context).textTheme.headline1,),
      ),
      body: Center(
        child:  Image.asset('assets/under-construction.png', scale: 3,),
      ),
    );
  }
}
