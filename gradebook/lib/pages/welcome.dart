import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Gradebook",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            heightFactor: 2,
            child: Image.asset('assets/icon.png'),
          ),
          Stack(
            children: [
              Positioned(
                top: 600,
                left: 20,
                right: 20,
                bottom: 100,
                child: RaisedButton(
                  child: Text('Sign up', style: Theme.of(context).textTheme.headline4,
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Sign_up');
                  },
                  padding: const EdgeInsets.all(18.0),
                ),
              ),
              Positioned(
                top: 500,
                left: 20,
                right: 20,
                bottom: 200,
                child: RaisedButton(
                  child: Text('login', style: Theme.of(context).textTheme.headline4,
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    //borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    // side: BorderRadius(color: Colors.black),
                  ),
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
