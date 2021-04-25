import 'package:flutter/material.dart';
import 'package:gradebook/utils/MyAppTheme.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeSelectionTile extends StatelessWidget {
  bool dMode;
  MyAppTheme theme;

  @override
  build(BuildContext context) {
    theme = Provider.of<MyAppTheme>(context);

    if (Theme
        .of(context)
        .brightness == Brightness.dark)
      dMode = true;
    else
      dMode = false;


    final List<AppTheme> themeList = theme.getThemes();


    final Container themeContainer = Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(themeList.length, (index) {
          Color brightness;
          if (themeList[index].data.brightness == Brightness.dark) {
            brightness = Colors.black;
          } else {
            brightness = Colors.white;
          }
          return SizedBox(
            //width: 100,
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  ThemeProvider.controllerOf(context).setTheme(
                      themeList[index].id);
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

    return themeContainer;
  }
}
