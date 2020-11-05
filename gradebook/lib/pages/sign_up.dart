import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {

  @override
  Widget build(BuildContext context) {

    final nameField = TextField(
      obscureText: false,
      style: Theme.of(context).textTheme.headline3,
      decoration: InputDecoration(
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );

    final emailField = TextField(
      obscureText: false,
      style: Theme.of(context).textTheme.headline3,
      decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: Theme.of(context).textTheme.headline3,
      decoration: InputDecoration(
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );
    final renterPasswordField = TextField(
      obscureText: true,
      style: Theme.of(context).textTheme.headline3,
      decoration: InputDecoration(
          hintText: "Enter password again",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );
    final registerBtn = SizedBox(
      width: 400,
        child: RaisedButton(
      child: Text('Register',
        style: Theme.of(context).textTheme.headline4,),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(),
      onPressed: () {Navigator.pushNamed(context, '/Terms');},
      padding: const EdgeInsets.all(18.0),

    )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up", style: Theme.of(context).textTheme.headline1,),
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
                nameField,
                SizedBox(height: 25.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 25.0,),
                renterPasswordField,
                SizedBox(height: 25.0,),
                registerBtn,

              ],
            ),
          ),
        ),
      ),
    );
  }
}