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
                _ProfileBackgroundSelection(),
                Align(
                  alignment: Alignment(-.7, -.5), //TODO: need to fix alignment bs
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
        _HandleSelection(),
        _UsernameSelection()
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
            return Text(
              userinfo.data["uname"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
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
          return Text(
            userinfo.data["handle"],
            style: TextStyle(fontSize: 18),
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
