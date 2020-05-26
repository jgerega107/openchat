import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text('openchat'),
          backgroundColor: Color(0xff5100e8),
        ),
        body: Center(child: Text("Hello World!"),),
    );
  }
}