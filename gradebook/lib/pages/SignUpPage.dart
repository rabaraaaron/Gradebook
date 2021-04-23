
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String error = '';

  bool usernameIsUnique = true;

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
            controller: nameController,
            obscureText: false,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
            validator: (val) =>
                ValidatorService().validateName(val),

            onEditingComplete: handleSubmitted,
          ),
          SizedBox(height: 25.0),
          TextFormField(
            controller: emailController,
            obscureText: false,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
            validator: (val) =>
                ValidatorService().validateEmail(val),
            onEditingComplete: handleSubmitted,
          ),
          SizedBox(height: 25.0),
          TextFormField(
            controller: usernameController,
            obscureText: false,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Username (optional)",
                errorText: usernameIsUnique ? null : "This username is taken. Try another.",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
             //validator: (val) => ValidatorService().usernameCheck(val),
            onEditingComplete: handleSubmitted,
          ),
          SizedBox(height: 25.0),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
            validator: (val) =>
                ValidatorService().validatePassword(val),
            onEditingComplete: handleSubmitted,
          ),
          SizedBox(height: 25.0),
          TextFormField(
            obscureText: true,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
                hintText: "Re-enter Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
            validator: (value) => ValidatorService().validateRepeatPassword(passwordController.text, value),
          ),
          SizedBox(height: 25.0),
        ],
      ),
    );

    final registerBtn =
    RaisedButton(
      child: Center(
        child: Text('Register',
          style: Theme.of(context).textTheme.headline2,),
      ),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      onPressed: () async {

        if(usernameController.text.isNotEmpty) {
          usernameIsUnique =
          await ValidatorService().usernameCheck(usernameController.text);
        }

        // Navigator.pushNamed(context, '/Terms');
        if (_formKey.currentState.validate() && usernameIsUnique) {
          setState(() => loading = true);


          dynamic result =
          await _auth.regEmailPass(
              context,
              emailController.text,
              passwordController.text,
              nameController.text,
              usernameController.text);
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