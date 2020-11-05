
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      obscureText: false,
      style: Theme.of(context).textTheme.headline2,
      decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: Theme.of(context).textTheme.headline2,
      decoration: InputDecoration(
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );

    final loginButton = RaisedButton(
            child: SizedBox(
              width: 305.0,
              height: 55.0,
              child: Center(
                child: Text('login',
                style: Theme.of(context).textTheme.headline4,),
              ),
            ),
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(),
            onPressed: () {
              Navigator.pushNamed(context, '/Terms');
              Navigator.pushNamed(context, '/Home');
              },
            padding: const EdgeInsets.all(18.0),
          );

    bool _checked = true;
    final checkbox = CheckboxListTile(
      title: Text("Keep me logged in", style: Theme.of(context).textTheme.headline3,),
      //secondary: Icon(Icons.beach_access),
      controlAffinity:
      ListTileControlAffinity.leading,
      value: _checked,
      onChanged: (bool value) {
        setState(() {

          //todo: this is not working, needs to be fixed
          _checked = true; //this is not working
        });
      },
      //controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );


    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: Theme.of(context).textTheme.headline1,),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                checkbox,
                SizedBox(height: 45.0),
                loginButton,
                SizedBox(height: 15.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}