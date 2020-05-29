import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final Firestore _firestore = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('openchat'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.add),
        label: Text("new conversation"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            FutureBuilder(
              future: _getCurrentUser(),
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
                if (user.hasData) {
                  return new UserAccountsDrawerHeader(
                    accountEmail: Text(user.data.email),
                    accountName: Text(user.data.displayName),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: Image.network(user.data.photoUrl).image,
                    ),
                  );
                } else {
                  return new UserAccountsDrawerHeader(
                    accountEmail: SpinKitWave(
                      color: Theme.of(context).primaryColor,
                    ),
                    accountName: SpinKitWave(
                      color: Theme.of(context).primaryColor,
                    ),
                    currentAccountPicture: CircleAvatar(
                      child: SpinKitWave(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
              },
            )
            
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _getCurrentUser() async {
    return await _auth.currentUser();
  }
}
