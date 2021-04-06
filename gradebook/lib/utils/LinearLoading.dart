import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradebook/utils/MyAppTheme.dart';


class LinearLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      //padding: EdgeInsets.only(left: 50, right: 50),
      color: Colors.transparent,
      child: Center(
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
            //size: 90,
          )
      ),
    );
  }
}
