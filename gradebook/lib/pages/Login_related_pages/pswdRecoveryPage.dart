import 'package:flutter/material.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:gradebook/services/validator_service.dart';
import '../../utils/loading.dart';


class ResetPassword extends StatefulWidget {


  @override
  _resetPageState createState() => _resetPageState();
}

class _resetPageState extends State<ResetPassword> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String error = '';

  final TextEditingController emailController = TextEditingController();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    var emailField = TextFormField(
      controller: emailController,
      obscureText: false,
      style: Theme.of(context).textTheme.headline6,
      validator: (val) => ValidatorService().validateEmail(val),
      decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final submitButton = RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      child: SizedBox(
        width: 305.0,
        height: 40.0,

        child: Center(
          child: Text(
            'Submit',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
      color: Theme.of(context).primaryColor,

      onPressed: () async {
        if (_formKey.currentState.validate()) {
          print("validation passed");
          setState(() => loading = true);
          dynamic successful = await _auth.resetPassword(context, emailController.text);
          if (successful){
            Navigator.pop(context);
            _auth.displayMessage(context,
                "Reset link has been sent to " + emailController.text,
                "Successful request");
          } else {
            setState(() { loading = false; });
          }
        }
        else
          //loading = false;
          setState(() {});
      },
      padding: const EdgeInsets.all(18.0),
    );

    Widget _resetPassword(context) {
      return loading ? Loading() : ListView(
          children:[ Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 250, left:36, right: 36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      emailField,
                      SizedBox(height: 320.0),
                      submitButton,
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            iconSize: 35,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Reset Password",
            style: Theme.of(context).textTheme.headline1,
          ),
          centerTitle: true,
        ),
        body: _resetPassword(context));
  }
}