import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'splash.dart';

void main() {
  runApp(MyApp());
}

//Start of app sequence, specifying the home screen of app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      title: "openchat",
      theme: ThemeData(primaryColor: Color(0xff691b99)),
    );
  }
}
