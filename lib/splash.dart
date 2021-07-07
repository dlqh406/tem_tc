import 'dart:async';

import 'package:flutter/material.dart';
import 'package:team_call/root.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  void initState() {
    super.initState();
    startTime();
  }


  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {


    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) =>
            Root()), (route) => false);

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context){
    //       return Root();
    //     }));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('logo')
            ],
          ),
        ),
      ),

    );
  }
}
