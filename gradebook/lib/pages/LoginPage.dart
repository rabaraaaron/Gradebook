import 'package:gradebook/pages/resetPasswrd.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:gradebook/services/validator_service.dart';
import 'package:gradebook/utils/AppTheme.dart';
import '../text_input_decoration.dart';
import 'loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String email = '';
  String password = '';
  String error = '';

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    var emailField = TextFormField(

      obscureText: false,
      style: Theme.of(context).textTheme.headline4,
      validator: (val) => ValidatorService().validateEmail(val),
      decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
      onChanged: (val) {
        setState(() => email = val);
      },
    );
    var passwordField = TextFormField(
      obscureText: true,
      style: Theme.of(context).textTheme.headline4,
      validator: (val) => ValidatorService().validatePassword(val),
      decoration: InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
      onChanged: (val) {
        setState(() => password = val);
      },
    );

    final loginButton = RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      child: SizedBox(
        width: 305.0,
        height: 55.0,

        child: Center(
          child: Text(
            'Enter',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
      color: Theme.of(context).primaryColor,

      onPressed: () async {
        if (_formKey.currentState.validate()) {
          print("validation passed");
          setState(() => loading = true);
          dynamic result = await _auth.signInEmailPass(context, email, password);
          if(result != null)
            Navigator.pop(context);

          if (result == null) {
            setState(() {
            error = 'There was an error with your login. Please try again.';
            loading = false;
            });
          }
        } else
          //loading = false;
          setState(
            () {}
          );
      },
      padding: const EdgeInsets.all(18.0),
    );

    bool _checked = true;
    final forgotPasswordButton = FlatButton(
      child: Text("Forgot password?"),
      onPressed: (){
        Navigator.pushNamed(context, '/resetPassword');
      },
    );

    Widget _login(context) {
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
                          emailField,
                          SizedBox(height: 25.0),
                          passwordField,
                          //checkbox,
                          forgotPasswordButton,
                          SizedBox(height: 45.0),
                          loginButton,
                          SizedBox(height: 15.0),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ]);
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Login",
            style: Theme.of(context).textTheme.headline1,
          ),
          centerTitle: true,
        ),
        body: _login(context));
  }
}
//
// final AuthService _auth = AuthService();
// final _formKey = GlobalKey<FormState>();
// bool loading = false;
//
// String email = '';
// String password = '';
// String error = '';
//
// Widget _signInForm(context){
//   return loading ? Loading() :  Container(
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
//       child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 10),
//               TextFormField(
//                 style:Theme.of(context).textTheme.headline2,
//                 decoration: TextFieldDecoration("Email").getTextFieldDecoration(),
//                 validator: (val) => ValidatorService().validateEmail(val),
//                 onChanged: (val) {
//                   setState(() => email=val);
//                 },
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 style: Theme.of(context).textTheme.headline2,
//                 decoration: TextFieldDecoration("Password").getTextFieldDecoration(),
//                 validator: (val) => ValidatorService().validatePassword(val),
//                 obscureText: true,
//                 onChanged: (val) {
//                   setState(()=> password=val);
//                 },
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   RaisedButton(
//                       color: Colors.black,
//                       child: Text(
//                         'Sign in',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () async {
//                         if (_formKey.currentState.validate()) {
//                           print("validation passed");
//                           setState(() => loading = true);
//                           dynamic result = await _auth.signInEmailPass(email, password);
//                           loading = false;
//                           if (result == null) {
//                             setState(() => error = 'There was an error with your login. Please try again.');
//                           }
//                         }
//                         else
//                           setState(() {
//
//                           },);
//                       }
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20,),
//               Text(
//                 error,
//                 style: TextStyle(color: Colors.red, fontSize: 14),
//               ),
//               SizedBox(height: 60,),
//             ],
//           )
//       ),
//     );
//   }
// }
