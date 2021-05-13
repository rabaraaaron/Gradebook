import 'package:flutter/material.dart';
import 'package:gradebook/services/auth_service.dart';
import 'package:gradebook/services/user_service.dart';
import 'package:gradebook/services/validator_service.dart';
import 'package:gradebook/utils/messageBar.dart';

class ChangePasswordTile extends StatefulWidget {
  @override
  _ChangePasswordTileState createState() => _ChangePasswordTileState();
}

class _ChangePasswordTileState extends State<ChangePasswordTile> {

  final TextEditingController repeatPswdController = TextEditingController();
  final TextEditingController newPswdController = TextEditingController();
  final TextEditingController currentPswdController = TextEditingController();
  String error = '';
  bool checkCurrentPasswordValid = true;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final FocusScopeNode focusScopeNode = FocusScopeNode();

  void handleSubmitted(){
    focusScopeNode.nextFocus();
  }

  void clearText() {
    repeatPswdController.clear();
    newPswdController.clear();
    currentPswdController.clear();
  }


  @override
  Widget build(BuildContext context) {

    final submitBtn =
    Center(
      child: RaisedButton(
        color:Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
            //side: BorderSide(color: Theme.of(context).primaryColor, width: 4)
        ),
        onPressed: () async {
          // Navigator.pushNamed(context, '/Terms');

            checkCurrentPasswordValid = await UserService().validateCurrentPassword(currentPswdController.text);
            setState(() => loading = true);

            if (_formKey.currentState.validate() && checkCurrentPasswordValid) {
              //change the password
             await  _auth.updateUserPassword(newPswdController.text);
             print('password has been changed');
             MessageBar(msg: "You can use the new password now.", title: "Successful Change!", context: context).show();
             clearText();
             setState(() {});
          }
          else
            setState(() => error = '');
        },
        padding: const EdgeInsets.all(18.0),
        child: Text('Change Password',
          style: Theme.of(context).textTheme.bodyText1,),
      ),
    );

    final FocusScope focusScope = FocusScope(
      node: focusScopeNode,
      child: Container(
        //color: Theme.of(context).accentColor,
        padding: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: currentPswdController,
                obscureText: true,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                    hintText: "Current Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0)),
                  errorText: checkCurrentPasswordValid ? null : "Please double check your current password",
                ),

                onEditingComplete: handleSubmitted,
              ),
              SizedBox(height: 25.0),
              TextFormField(
                controller: newPswdController,
                obscureText: true,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                    hintText: "New Password",
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
                validator: (val) =>
                    ValidatorService().validatePassword(val),
                onEditingComplete: handleSubmitted,
              ),
              SizedBox(height: 25.0),
              TextFormField(
                controller: repeatPswdController,
                obscureText: true,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                    hintText: "Re-enter Password",
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))),
                validator: (value){
                 return ValidatorService().validateRepeatPassword(newPswdController.text, value);
                },
              ),
              SizedBox(height: 25.0),
              submitBtn,
            ],
          ),
        ),
      ),
    );
    return Container(child: focusScope,);
  }


}
  
