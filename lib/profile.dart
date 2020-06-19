import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openchat/profileedits.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            _ProfileBackgroundSelection(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _ProfilePictureSelection(),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileEditScreen()));
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text("Edit"),
                  )
                ],
              ),
              alignment: Alignment(0, -.2),
              padding: EdgeInsets.only(top: 200),
              margin: EdgeInsets.only(bottom: 30),
            )
          ],
        ),
        _UsernameSelection(),
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
            child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
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
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Image.network(userinfo.data["bgurl"], fit: BoxFit.fill,),
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
          return CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  );
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
          return CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  );
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
