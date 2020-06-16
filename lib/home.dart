import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:openchat/profile.dart';

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
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.add),
        label: Text("new conversation"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _DrawerHeader(),
            ListTile(
              leading:
                  Icon(Icons.person, color: Theme.of(context).primaryColor),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
        if (userinfo.hasData) {
          return new UserAccountsDrawerHeader(
            accountEmail: Text(userinfo.data["email"]),
            accountName: Text(userinfo.data["uname"]),
            currentAccountPicture: CircleAvatar(
              backgroundImage: Image.network(userinfo.data["pfp"]).image,
            ),
          );
        } else {
          return new UserAccountsDrawerHeader(
            accountEmail: SpinKitWanderingCubes(color: Colors.white, size: 15),
            accountName: SpinKitWanderingCubes(color: Colors.white, size: 15),
            currentAccountPicture: CircleAvatar(
              child: SpinKitWanderingCubes(color: Colors.white, size: 15),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  //use this for getting user info from firestore
  Future<DocumentSnapshot> _getUserInfo() async {
    FirebaseUser user = await _auth.currentUser();
    return Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      print(
          "Read firestore"); //TODO: fix redundant reads, possibly global variables? could mess up flow from profile page
      return ds;
    });
  }
}
