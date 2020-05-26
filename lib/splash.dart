import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';

class SplashScreen extends StatefulWidget{
  SplashState createState() => SplashState();
}

class SplashState extends State<SplashScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xff5100e8),
      body: Center(child: Image(image: AssetImage("assets/images/placeholder.png"))
    ));
  }

  void initState(){
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => LoginScreen()
      )
    ); 
  }
}