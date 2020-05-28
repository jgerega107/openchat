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
          backgroundColor: Color(0xff691b99),
        ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff691b99),
        icon: Icon(Icons.add), 
        label: Text("new conversation"),
        ),
    );
  }
}