import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final Firestore _firestore = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileScreen extends StatelessWidget{
  @override
  Widget build(BuildContext){
    return null;
  }

  Widget _profilePictureSection(){
    Widget build(BuildContext context){
      return Container(
        child: CircleAvatar(
        child: FutureBuilder(
          future: _getUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo){
            if(userinfo.hasData){
              return Image.network(userinfo.data["pfp"]);
            }
            return SpinKitWanderingCubes(
                color: Colors.white,
                size: 15
              );
          }
        ),
        backgroundColor: Theme.of(context).primaryColor,
        ),
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
          print("Read firestore"); //TODO: fix redundant reads, possibly global variables? could mess up flow from profile page
      return ds;
    });
  }

}