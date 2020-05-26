import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:openchat/home.dart';
import 'dart:async';
import 'login.dart';
/*
Here within the SplashScreen, a number of operations will be happening. 
Firstly, we will check to see if a user is currently logged in, and if so, just progress to the home of the app.
If there is no user logged in, then push LoginScreen to the navigator.
As usual with all other screens within the app, time will be spent making it look nice.
*/
final FirebaseAuth _auth = FirebaseAuth.instance;

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
    if(await signedIn()){
      return new Timer(duration, toHomeScreen);
    }
    return new Timer(duration, toLoginScreen);
  }

  toLoginScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => LoginScreen()
      )
    ); 
  }

  toHomeScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => HomeScreen()
      )
    ); 
  }

  Future<bool> signedIn() async{
    if(await _auth.currentUser() != null){
      return true;
    }
    return false;
  }
}