
import 'package:flutter/material.dart';
import 'package:gradebook/pages/loading.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:gradebook/services/validator_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // From and page init state
  String email = '';
  String password = '';
  String name = '';
  String error = '';



  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;


  @override
  Widget build(BuildContext context) {

    final nameField = TextFormField(
      obscureText: false,
      style: Theme.of(context).textTheme.headline4,
      decoration: InputDecoration(
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
      validator: (val) =>
          ValidatorService().validateName(val),
      onChanged: (val) =>
          setState(() => name = val),
    );

    final emailField = TextFormField(
      obscureText: false,
      style: Theme.of(context).textTheme.headline4,
      decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
      validator: (val) =>
          ValidatorService().validateEmail(val),
      onChanged: (val) =>
          setState(() => email = val),
    );
    final passwordField = TextFormField(
      obscureText: true,
      style: Theme.of(context).textTheme.headline4,
      decoration: InputDecoration(
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
      validator: (val) =>
          ValidatorService().validatePassword(val),
      onChanged: (val) =>
          setState(() => password = val),

    );
    final renterPasswordField = TextField(
      obscureText: true,
      style: Theme.of(context).textTheme.headline4,
      decoration: InputDecoration(
          hintText: "Enter password again",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
    );
    final registerBtn =
    RaisedButton(
      child: Center(
        child: Text('Confirm',
          style: Theme.of(context).textTheme.headline2,),
      ),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      onPressed: () async {
        // Navigator.pushNamed(context, '/Terms');
        if (_formKey.currentState.validate()) {
          setState(() => loading = true);
          dynamic result =
          await _auth.regEmailPass(
              context, email, password, name);
          if(result != null)
            Navigator.pop(context);
          loading = false;
          if (result == null) {
            setState(() => error =
            'Something went wrong. Please try again.');
          }
        }
        else
          setState(() => error = '');
        },
      padding: const EdgeInsets.all(18.0),

    );




    Widget _register(context){
      return loading ? Loading() : ListView(
        children:[ Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
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
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Sign up",
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
      ),
      body: _register(context)
    );

  }

}