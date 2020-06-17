import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:openchat/profile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  child: _ProfileBackgroundSelection(),
                ),
                Container(
                  height: 250,
                  alignment: Alignment(.9, -.6),
                  child: ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor:
                            Theme.of(context).primaryColor, // inkwell color
                        child: SizedBox(
                            width: 35, height: 35, child: Icon(Icons.edit)),
                        onTap: () {},
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _ProfilePictureSelection(),
                      ClipOval(
                        child: Material(
                          color: Colors.white, // button color
                          child: InkWell(
                            splashColor:
                                Theme.of(context).primaryColor, // inkwell color
                            child: SizedBox(
                                width: 35, height: 35, child: Icon(Icons.edit)),
                            onTap: () {},
                          ),
                        ),
                      )
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text("Cancel"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text("Save"),
                  ),
                ],
              ),
              alignment: Alignment(0, -.2),
              padding: EdgeInsets.only(top: 200),
              margin: EdgeInsets.only(bottom: 30),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom:20),
          child: _UsernameSelection(),
        ),
        _HandleSelection(),
      ],
    ));
  }
}

class _ProfilePictureSelection extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserInfo(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
          if (userinfo.hasData) {
            return CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: Image.network(userinfo.data["pfp"]).image,
              radius: 50,
            );
          }
          return CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: SpinKitWanderingCubes(color: Colors.white, size: 15),
            radius: 50,
          );
        });
  }
}

class _ProfileBackgroundSelection extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
        if (userinfo.hasData) {
          if (userinfo.data["bgurl"] != "") {
            return Container(
              height: 250,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Image.network(userinfo.data["bgurl"]),
            );
          }
        }
        return Container(
          height: 250,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        );
      },
    );
  }
}

class _UsernameSelection extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserInfo(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
          if (userinfo.hasData) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: <Widget>[
                  Align(
                    child: Text(
                      "Nickname",
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).primaryColor),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(color:Theme.of(context).primaryColor)),
                        hintText: 'Can\'t be blank'),
                    controller:
                        TextEditingController(text: userinfo.data['uname']),
                  )
                ],
              ),
            );
          }
          return SpinKitWanderingCubes(color: Colors.white, size: 15);
        });
  }
}

class _HandleSelection extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
        if (userinfo.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: <Widget>[
                Align(
                  child: Text(
                    "Username",
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).primaryColor),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                TextField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      border: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Theme.of(context).primaryColor))),
                  controller:
                      TextEditingController(text: userinfo.data['handle']),
                )
              ],
            ),
          );
        } else {
          return SpinKitWanderingCubes(color: Colors.white, size: 15);
        }
      },
    );
  }
}

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
