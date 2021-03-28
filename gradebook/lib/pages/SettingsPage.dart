import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final GridView colorGrid = GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 40,
      shrinkWrap: true,
      children: List.generate(themeList.length, (index) {

        Color brightness;
        double width = 60;
        double primaryHeight = 50;
        double secondaryHeight = 20;

        if(themeList[index].data.brightness == Brightness.dark){
          brightness = Colors.black;
        } else{
          brightness = Colors.white;
        }

        return SingleChildScrollView(
          child: GestureDetector(
            onTap: (){
              ThemeProvider.controllerOf(context).setTheme(themeList[index].id);
            },
            child: SizedBox(
              child: Center(
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
                      height: 5,
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
            ),
          ),
        );
      }),
    );

    final ExpansionTile themeCustomizationTile = ExpansionTile(
      title: Text("Theme Customization", style: Theme.of(context).textTheme.headline4,),
      children: [colorGrid],
    );


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
        title: Text("Settings", style: Theme.of(context).textTheme.headline1,),
      ),
      body: themeCustomizationTile,
    );
  }
}
