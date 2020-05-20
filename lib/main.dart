import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'openchat',
      home: Scaffold(
        appBar: AppBar(
          title: Text('openchat'),
          backgroundColor: Color(0xff5100e8),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("openchat", textAlign: TextAlign.center, style: TextStyle(fontFamily: "inconsolata"), textScaleFactor: 2,),
              ),
              Image(image: AssetImage("assets/images/placeholder.png"),)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        ),
      ),
    );
  }
}