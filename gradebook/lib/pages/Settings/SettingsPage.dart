import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/pages/Settings/ChangePasswordPage.dart';
import 'package:gradebook/pages/Settings/ProfilePage.dart';
import 'package:gradebook/utils/MyAppTheme.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool dMode;
  MyAppTheme theme;

  @override
  build(BuildContext context) {

    theme = Provider.of<MyAppTheme>(context);

    if(Theme.of(context).brightness == Brightness.dark)
      dMode = true;
    else
      dMode = false;


    final List<AppTheme> themeList = theme.getThemes();

    final Divider divider =  Divider(
      color: Theme.of(context).dividerColor,
      indent: 25.0,
      endIndent: 25.0,
    );

    final Container themeContainer = Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
          children: List.generate(themeList.length, (index) {

            Color brightness;
            if(themeList[index].data.brightness == Brightness.dark){
              brightness = Colors.black;
            } else{
              brightness = Colors.white;
            }

            return SizedBox(
              //width: 100,
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: (){
                    ThemeProvider.controllerOf(context).setTheme(themeList[index].id);
                  },
                  child: MaterialButton(
                     child: Container(
                      height: 90,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(13),
                        gradient: LinearGradient(
                          stops: [0.19, 0.4, 0.6,],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            themeList[index].data.primaryColor,
                            themeList[index].data.accentColor,
                            brightness,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
      ),
    );

    final ListView settingsList = ListView(
      scrollDirection: Axis.vertical,
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.all(10),
          title:  Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5.0, left: 5, bottom: 10),
                child:  Container(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(Icons.account_circle, size: 45,)
                ),
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
                child:  Container(
                  padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                  child: Image.asset('assets/password.png', scale: 12, color: Theme.of(context).dividerColor,),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text("Password", style: Theme.of(context).textTheme.headline5,),
                ),
              ),
            ],
          ),
          children: [ChangePasswordPage(),],
        ),

        divider,

        ExpansionTile(
          tilePadding: EdgeInsets.all(10),
          title:  Row(
            children: [
              Container(
                child:  Container(
                  padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                  child: Icon(Icons.format_paint_rounded, size: 37,),
                  //Image.asset('assets/password.png', scale: 12, color: Theme.of(context).dividerColor,),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('App Theme', style: Theme.of(context).textTheme.headline5,),
                ),
              ),
            ],
          ),
          children: [themeContainer,],
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
