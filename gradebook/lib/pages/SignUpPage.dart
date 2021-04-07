
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

  final FocusScopeNode focusScopeNode = FocusScopeNode();


  void handleSubmitted(){
    focusScopeNode.nextFocus();
  }

  @override
  Widget build(BuildContext context) {

    final FocusScope focusScope = FocusScope(
      node: focusScopeNode,
      child: Column(
        children: [
          TextFormField(
            obscureText: false,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
            validator: (val) =>
                ValidatorService().validateName(val),
            onChanged: (val) =>
                setState(() => name = val),
            onEditingComplete: handleSubmitted,
          ),
          SizedBox(height: 25.0),
          TextFormField(
            obscureText: false,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
            validator: (val) =>
                ValidatorService().validateEmail(val),
            onChanged: (val) =>
                setState(() => email = val),
            onEditingComplete: handleSubmitted,
          ),
          SizedBox(height: 25.0),
          TextFormField(
            obscureText: true,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
            validator: (val) =>
                ValidatorService().validatePassword(val),
            onChanged: (val) =>
                setState(() => password = val),
            onEditingComplete: handleSubmitted,
          ),
          SizedBox(height: 25.0),
          TextField(
            obscureText: true,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Re-enter Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
          ),
          SizedBox(height: 25.0),
        ],
      ),
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
                    focusScope,
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 35,
          onPressed: (){
            Navigator.pop(context);
          },
        ),      ),
      body: _register(context)
    );

  }

}