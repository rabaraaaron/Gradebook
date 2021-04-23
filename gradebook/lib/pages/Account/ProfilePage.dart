import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradebook/model/User.dart';
import 'package:gradebook/pages/loading.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:gradebook/services/user_service.dart';
import 'package:gradebook/services/validator_service.dart';
import 'package:gradebook/utils/LinearLoading.dart';
import 'package:gradebook/utils/messageBar.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String uID;
  String userName;
   final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    uID = FirebaseAuth.instance.currentUser.uid;

    return StreamProvider<GradeBookUser>.value(
      value: _auth.gradebookuser,
      child: ProfileView(),
    );
  }
}
class ProfileView extends StatelessWidget {

  String userName = "";
  String displayName = "";
  GradeBookUser user;

  Future<String> getDisplayName() async{
    displayName = await UserService(uid: user.uid).getDisplayName(user.uid);
    return displayName;
  }

  Future<String> getUserName() async{
    userName = await UserService(uid: user.uid).getUserName(user.uid);
    return userName;
  }

  @override
  Widget build(BuildContext context) {

    if(Provider.of<GradeBookUser>(context) != null) {
      user = Provider.of<GradeBookUser>(context);

      return FutureBuilder(
        initialData: Loading(),
        future: getDisplayName(),
        builder: (context, snapShot) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Theme
                        .of(context)
                        .accentColor, Theme
                        .of(context)
                        .primaryColor
                    ],
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          //todo: here is where we can add profile image
                          //backgroundImage: FileImage(Image.asset("assets/profile_image.png")),
                        ),
                        SizedBox(height: 10,),
                        /// User's display name
                        Text( snapShot.data.toString(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline5,),
                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 260,
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Display Name:'),
                            SizedBox(height: 10,),
                            Text("Username:"),
                            SizedBox(height: 10,),
                            Text("Email:"),
                            SizedBox(height: 10,),
                          ],
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(displayName),
                            SizedBox(height: 10,),
                            FutureBuilder(
                              future: getUserName(),
                              builder: (context, snapShot){
                                if(snapShot.hasData)
                                  return Text(snapShot.data);
                                else
                                  return LinearLoading();
                              },
                            ),
                            SizedBox(height: 10,),
                            Text(user.email),


                            //Text(getUserName().toString()),
                          ],
                        ),
                      ],
                    ),
                    RaisedButton(
                      child: Text('Edit'),
                    )
                  ],
                ),
              )
            ],
          );
        }

      );
    } else{
      return Loading();
    }
  }
}
  
