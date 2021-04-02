import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

    final Container themeContainer = Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
          children: List.generate(themeList.length, (index) {

            Color brightness;
            double width = 90;
            double primaryHeight = 50;
            double secondaryHeight = 20;

            if(themeList[index].data.brightness == Brightness.dark){
              brightness = Colors.black;
            } else{
              brightness = Colors.white;
            }

            return SizedBox(
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: (){
                    ThemeProvider.controllerOf(context).setTheme(themeList[index].id);
                  },
                  child: ElevatedButton(
                    child: ClipOval(
                      child: Column(
                        children: [
                          Container(
                            height: primaryHeight,
                            width: width,
                            color: themeList[index].data.primaryColor,
                          ),
                          Container(
                            height: secondaryHeight,
                            width: width,
                            color: themeList[index].data.accentColor,
                          ),
                          Container(
                            height: secondaryHeight,
                            width: width,
                            decoration: BoxDecoration(
                              color: brightness,
                              border: Border.all(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
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
        SizedBox(height: 15,),
        Row(
          children: [
            SizedBox(width: 15,),
          Text("Change Theme", style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.w300,
            fontFamily: GoogleFonts.quicksand().toStringShort(),
          )),
          ]
        ),
        themeContainer,

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
