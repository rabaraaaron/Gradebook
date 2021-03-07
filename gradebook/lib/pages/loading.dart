import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradebook/utils/MyAppTheme.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      child: Center(
        child: SpinKitDualRing(
        color: Theme.of(context).primaryColor,
        size: 90,
         )
      ),
    );
  }
}
