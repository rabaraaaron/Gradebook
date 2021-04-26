import 'package:flutter/material.dart';

class NotificationsSettingsTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle_H5 = Theme.of(context).textTheme.headline5;


    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20,),
      child: ListView(
      children: [
        ListTile(
          title: Text('Allow Notifications', style: textStyle_H5,),
        )
      ],
      )
    );
  }
}
