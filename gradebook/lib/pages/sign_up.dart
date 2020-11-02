
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    final nameField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );

    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );
    final renterPasswordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          hintText: "Enter password again",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(0.0))),
    );
    final registerBtn = SizedBox(
      width: 400,
        child: RaisedButton(
      child: Text('Register',
        style: TextStyle(fontSize: 30),),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(),
      onPressed: () {Navigator.pushNamed(context, '/Terms');},
      padding: const EdgeInsets.all(18.0),

    )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
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