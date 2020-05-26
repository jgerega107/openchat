import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
/*
Here we will authenticate the user.

Theme ideas: Possibly solid background with a nice animation or something? Buttons centered, minimal text.
*/
class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('openchat'),
          backgroundColor: Color(0xff5100e8),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("welcome to openchat.", textAlign: TextAlign.center, style: TextStyle(fontFamily: "inconsolata"), textScaleFactor: 2,),
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
        SignInButton(Buttons.Google, onPressed: () {
          _handleSignIn();
        })
      ],
    ));
  }

  void _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
  }
}