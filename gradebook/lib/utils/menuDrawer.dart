import 'package:flutter/material.dart';
import 'package:gradebook/services/auth_service.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(child: Text("Menu", style: Theme.of(context).textTheme.headline2,)),
          ListTile(title: Text("Settings", style: Theme.of(context).textTheme.headline5,),),
          ListTile(title: Text("Membership", style: Theme.of(context).textTheme.headline5,),),
          ListTile(title: Text("Help", style: Theme.of(context).textTheme.headline5,)),
          ListTile(
            title: Text("Log Out", style: Theme.of(context).textTheme.headline5,),
            onTap: () async {
              while (Navigator.canPop(context))
                if(Navigator.canPop(context))
                  Navigator.pop(context);
              await AuthService().signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
