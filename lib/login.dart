import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:openchat/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/*
Here we will authenticate the user.

Theme ideas: Possibly solid background with a nice animation or something? Buttons centered, minimal text.
*/

final Firestore _firestore = Firestore.instance;


class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('openchat'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("welcome to openchat.", textAlign: TextAlign.center, textScaleFactor: 2,),
              ),
              Image(image: AssetImage("assets/images/placeholder.png"),
              ),
              _GoogleSignInSection()
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        ),
      );
  }
}


class _GoogleSignInSection extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection>{
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.all(30),
     child: Column(
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            _handleGoogleSignIn();
          },
          color: Colors.white,
          child: Text("sign in with google"),
        ),
        RaisedButton(
          onPressed: () {},
          color: Colors.white,
          child: Text("sign in with apple"),
        )
      ],
    ));
  }

  void _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("Successfully signed in " + user.displayName);

    //create firestore reference
    _firestore.collection("users").document(user.uid).setData({'uname':user.displayName, 'email':user.email, 'pfp':"https://firebasestorage.googleapis.com/v0/b/openchat-19dd2.appspot.com/o/placeholder%2Fpogman_alt.png?alt=media&token=b6a9d14f-e445-42dc-b066-a9933383c782", "bgurl":"", "chatscore": 0, "handle" : user.displayName.toLowerCase().replaceAll(" ", "")}); //TODO: fix this stupidity to an icon or something

    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => HomeScreen()
      )
    ); 
  }
}