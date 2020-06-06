import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final Firestore _firestore = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: Padding(
              padding: EdgeInsets.to,
            ),
          ),
        )
    );
  }
}

class _profilePictureSection extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo){
        if(userinfo.hasData){
          return CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: Image.network(userinfo.data["pfp"]).image,
            radius: 120,
          );
        }
        return CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: SpinKitWanderingCubes(color: Colors.white, size: 15),
          radius: 120,
        );
      }
    );
  }
}

class _profileBackgroundSelection extends StatelessWidget{
    Widget build(BuildContext context){
      return FutureBuilder(
        future: _getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo){
          if(userinfo.hasData){
            if(userinfo.data["bgurl"] != ""){
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
                child: Image.network(userinfo.data["bgurl"]),
              );
            }
          }
          return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
              );
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
