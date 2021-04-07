import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Gradebook", style: Theme.of(context).textTheme.headline1,),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            transform: Matrix4.rotationZ(.5),
            //padding: EdgeInsets.only(right: 540),
            width: 300,
            height: 700,
            decoration: BoxDecoration(
              color: Colors.brown[50],
              //Theme.of(context).primaryColor,
              // borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 20,
                  offset: Offset(4, 10), // Shadow position
                ),
              ],
            ),
          ),
          Container(
            transform: Matrix4.rotationZ(.6),
            //padding: EdgeInsets.only(right: 540),
            width: 300,
            height: 700,
            //color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              color: Colors.brown[50],
              //Theme.of(context).accentColor,
             // borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  //offset: Offset(4, 8), // Shadow position
                ),
              ],
            ),
          ),
          Center(
            heightFactor: 2,
           // child: Image.asset('assets/icon.png'),
          ),
          Stack(
            children: [
              Positioned(
                //top: 20,
                left: 20,
                right: 20,
                bottom: 40,
                child: RaisedButton(
                  child: Text(
                    'Sign up',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Sign_up');
                  },
                  padding: const EdgeInsets.all(18.0),
                ),
              ),
              Positioned(
                //top: 20,
                left: 20,
                right: 20,
                bottom: 130,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                  child: Text('Login', style: Theme.of(context).textTheme.headline2,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, '/Login');
                  },
                  padding: const EdgeInsets.all(18.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
