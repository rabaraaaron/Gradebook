import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradebook/utils/AppTheme.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.appBar,
      child: Center(
        child: SpinKitDualRing(
        color: AppTheme.accent,
        size: 90,
         )
      ),
    );
  }
}
