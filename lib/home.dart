import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: userinfo.data["pfp"] != ""
                      ? Image(
                              image: CachedNetworkImageProvider(
                                  userinfo.data["pfp"]),
                              fit: BoxFit.fill)
                          .image
                      : Image.asset('assets/images/placeholder.png').image),
              decoration: userinfo.data["bgurl"] != ""
                  ? BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              userinfo.data["bgurl"]),
                          fit: BoxFit.fill))
                  : null);
        } else {
          return new Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 195,
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ));
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
      print("Read firestore");
      return ds;
    });
  }
}
