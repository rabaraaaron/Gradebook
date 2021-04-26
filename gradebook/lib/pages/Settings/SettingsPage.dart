import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/pages/Settings/ChangePasswordTile.dart';
import 'package:gradebook/pages/Settings/NotificationsSettingsTile.dart';
import 'package:gradebook/pages/Settings/ProfileTile.dart';
import 'package:gradebook/pages/Settings/ThemeSelectionTile.dart';

class SettingsPage extends StatelessWidget {


  @override
  build(BuildContext context) {

    final Divider divider =  Divider(
      color: Theme.of(context).dividerColor,
      indent: 25.0,
      endIndent: 25.0,
    );

    final ListView settingsList = ListView(
      scrollDirection: Axis.vertical,
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.all(10),
          title:  Row(
            children: [
              Container(
                  padding: EdgeInsets.all(1.0),
                  child: Icon(Icons.account_circle, size: 45,)
              ),
              Expanded(
                child: ListTile(
                  title: Text("Profile", style: Theme.of(context).textTheme.headline5,),
                ),
              ),
            ],
          ),
          children: [ProfilePage(),],
        ),
        divider,

        ExpansionTile(
          tilePadding: EdgeInsets.all(10),
          title:  Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                child: Image.asset('assets/password.png', scale: 12, color: Theme.of(context).dividerColor,),
              ),
              Expanded(
                child: ListTile(
                  title: Text("Password", style: Theme.of(context).textTheme.headline5,),
                ),
              ),
            ],
          ),
          children: [ChangePasswordTile(),],
        ),

        divider,
        ExpansionTile(
          tilePadding: EdgeInsets.all(10),
          title:  Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                child: Icon(Icons.notification_important_sharp, size: 37,)
                //Image.asset('assets/password.png', scale: 12, color: Theme.of(context).dividerColor,),
              ),
              Expanded(
                child: ListTile(
                  title: Text("Notifications", style: Theme.of(context).textTheme.headline5,),
                ),
              ),
            ],
          ),
          children: [NotificationsSettingsTile(),],
        ),

        divider,

        ExpansionTile(
          tilePadding: EdgeInsets.all(10),
          title:  Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                child: Image.asset('assets/brush_icon2.png', scale: 14, color: Theme.of(context).dividerColor,),
                //Icon(Icons.format_paint_rounded, size: 37,),
              ),
              Expanded(
                child: ListTile(
                  title: Text('App Theme', style: Theme.of(context).textTheme.headline5,),
                ),
              ),
            ],
          ),
          children: [ThemeSelectionTile(),],
        ),
      ],
    );



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
        title: Text("Settings", style: Theme.of(context).textTheme.headline1,),
      ),
      body: settingsList,
    );
  }
}
