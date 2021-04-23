import 'package:flutter/material.dart';
import 'package:gradebook/pages/Account/ChangePasswordPage.dart';
import 'package:gradebook/pages/Account/ProfilePage.dart';

class AccountManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    double scale = 9.5;



    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            iconSize: 35,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Account Management",
            style: Theme.of(context).textTheme.headline6,
          ),
          centerTitle: true,
        ),
        body:  ListView(
          children: [
            ExpansionTile(
              tilePadding: EdgeInsets.all(10),
              title:  Row(
                children: [
                  Container(
                    child:  Container(
                      padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                      child: Image.asset('assets/password.png', scale: scale, color: Theme.of(context).dividerColor,),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                        title: Text("Manage Password", style: Theme.of(context).textTheme.headline5,),
                        // onTap: (){
                        //   //Navigator.pop(context);
                        //   Navigator.pushNamed(context, '/Settings');
                        // }
                    ),
                  ),
                ],
              ),
              //shrinkWrap: true,
              children: [
                ChangePasswordPage(),
              ],

            ),
            Divider(
              color: Theme.of(context).dividerColor,
              indent: 25.0,
              endIndent: 25.0,
            ),
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
                //SizedBox(width: 10,),
                Expanded(
                  child: ListTile(
                      title: Text("Profile", style: Theme.of(context).textTheme.headline5,),
                      // onTap: (){
                      //   Navigator.pop(context);
                      //   Navigator.pushNamed(context, '/Settings');
                      // }
                  ),
                ),

              ],
            ),
              children: [
                //todo: implement profile image add/update
                ProfilePage(), // this is only for testing the scrollable view of the page and it should be changed later.
              ],

            )
          ],
        ),

    );
  }
}
