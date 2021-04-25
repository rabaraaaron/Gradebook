import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradebook/utils/MyAppTheme.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitWave(
        color: Theme.of(context).primaryColor,
        size: 90,
         )
      ),
    );
  }
}
