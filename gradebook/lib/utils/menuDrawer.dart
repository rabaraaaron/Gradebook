import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gradebook/services/auth_service.dart';

class MenuDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    TextStyle t = Theme.of(context).textTheme.headline4;

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              child: Text("Menu", style: t),
          ),
          ListTile(
            title: Text("Settings", style: t,),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, '/Settings');
            }
          ),
          Divider(thickness: .5,),
          ListTile(title: Text("Membership", style: t,),),
          Divider(thickness: .5,),
          ListTile(
              title: Text(
                "Upcoming Assignments",
                style: t,
              ),
            onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Upcoming');
            },
          ),
          Divider(thickness: .5,),
          ListTile(
            title: Text("Log Out", style: t,),
            onTap: () async {
              while (Navigator.canPop(context))
                if(Navigator.canPop(context))
                  Navigator.pop(context);
              await AuthService().signOut(context);
            },
          ),
          Divider(thickness: .5,),
        ],
      ),
    );
  }
}
