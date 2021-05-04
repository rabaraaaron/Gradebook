import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gradebook/services/auth_service.dart';

class MenuDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    TextStyle t = Theme.of(context).textTheme.headline5;
    Color color = Theme.of(context).primaryColor;

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              child: Text("Menu", style: t),
          ),
          ListTile(
              leading: Icon(Icons.settings, size: 38, color: color),
              horizontalTitleGap: 5,
              title: Text("Settings", style: t,),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, '/Settings');
            }
          ),
          Divider(thickness: .5,),
          ListTile(
              horizontalTitleGap: 5,
              leading: Icon(Icons.supervisor_account_outlined, size: 40, color: color,),
              title: Text("Membership", style: t,),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/MembershipPage');
              }
          ),
          Divider(thickness: .5,),
          ListTile(
              horizontalTitleGap: 5,
              leading: Icon(Icons.toc_outlined, size: 40, color: color,),
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
            horizontalTitleGap: 5,
            leading: Icon(Icons.logout, size: 35, color: color,),
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
