import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openchat/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
final Firestore _firestore = Firestore.instance;

class ProfileEditScreen extends StatefulWidget {
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File backgroundImage;
  File profilePicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            _ProfileBackgroundSelection(
              getImageSource: (File image) {
                backgroundImage = image;
              },
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _ProfilePictureSelection(
                    getImageSource: (File image) {
                      profilePicture = image;
                    },
                  ),
                  RaisedButton(
                    onPressed: () {
                      //don't do anything to firestore, no changes were made.
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
                      //push updated images to firebase storage, grab URLs, and push into firestore
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        _uploadBackground(backgroundImage);
                        _uploadProfilePicture(profilePicture);
                        return ProfileScreen();
                      }));
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
          padding: EdgeInsets.only(bottom: 20),
          child: _UsernameSelection(),
        ),
        _HandleSelection(),
      ],
    ));
  }
}

class _ProfilePictureSelection extends StatefulWidget {
  final Function(File) getImageSource;
  _ProfilePictureSelection({this.getImageSource});

  _ProfilePictureSelectionState createState() =>
      _ProfilePictureSelectionState();
}

class _ProfilePictureSelectionState extends State<_ProfilePictureSelection> {
  File _image;
  int location = -1;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null){
              _image = File(pickedFile.path);
      }
    });

    widget.getImageSource(_image);
  }

  ImageProvider getImageFromResource(
      int location, AsyncSnapshot<DocumentSnapshot> userinfo) {
    if (location == 0) {
      return Image.file(
        _image,
        fit: BoxFit.fill,
      ).image;
    } else if (location == 1) {
      return Image.network(userinfo.data["pfp"], fit: BoxFit.fill).image;
    } else {
      return null;
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserInfo(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
          if (userinfo.hasData) {
            if (userinfo.hasData) {
              if (_image != null) {
                location = 0;
              } else if (userinfo.data["pfp"] != "") {
                location = 1;
              } else {
                location = 2;
              }
            }
            return Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: getImageFromResource(location, userinfo),
                  radius: 50,
                ),
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      splashColor:
                          Theme.of(context).primaryColor, // inkwell color
                      child: SizedBox(
                          width: 35, height: 35, child: Icon(Icons.edit)),
                      onTap: () {
                        getImage();
                      },
                    ),
                  ),
                )
              ],
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

class _ProfileBackgroundSelection extends StatefulWidget {
  final Function(File) getImageSource;
  _ProfileBackgroundSelection({this.getImageSource});

  _ProfileBackgroundSelectionState createState() =>
      _ProfileBackgroundSelectionState();
}

class _ProfileBackgroundSelectionState
    extends State<_ProfileBackgroundSelection> {
  File _image;
  int location = -1;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null){
              _image = File(pickedFile.path);
      }
    });

    widget.getImageSource(_image);
  }

  Widget getImageFromResource(
      int location, AsyncSnapshot<DocumentSnapshot> userinfo) {
    if (location == 0) {
      return Image.file(
        _image,
        fit: BoxFit.fill,
      );
    } else if (location == 1) {
      return Image.network(userinfo.data["bgurl"], fit: BoxFit.fill);
    } else {
      return null;
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
        if (userinfo.hasData) {
          if (_image != null) {
            location = 0;
          } else if (userinfo.data["bgurl"] != "") {
            location = 1;
          } else {
            location = 2;
          }
        }
        return Stack(
          children: <Widget>[
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: getImageFromResource(location, userinfo),
            ),
            Container(
              height: 250,
              alignment: Alignment(.9,
                  -.6), //don't know if stuff like this is good convention, too used to android
              child: ClipOval(
                child: Material(
                  color: Colors.white, // button color
                  child: InkWell(
                    splashColor:
                        Theme.of(context).primaryColor, // inkwell color
                    child: SizedBox(
                        width: 35, height: 35, child: Icon(Icons.edit)),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
              ),
            )
          ],
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
                            borderSide: new BorderSide(
                                color: Theme.of(context).primaryColor)),
                        hintText: 'Can\'t be blank'),
                    controller:
                        TextEditingController(text: userinfo.data['uname']),
                  )
                ],
              ),
            );
          }
          return CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor),
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
                          borderSide: new BorderSide(
                              color: Theme.of(context).primaryColor))),
                  controller:
                      TextEditingController(text: userinfo.data['handle']),
                )
              ],
            ),
          );
        } else {
          return CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor),
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

void _uploadProfilePicture(File image) async {
  String bgurl;
  FirebaseUser user = await _auth.currentUser();
  DocumentReference userRef = _firestore.collection("users").document(user.uid);
  await userRef.get().then((DocumentSnapshot ds) async {
    //upload to firestore
    StorageReference backgroundLoc =
        _storage.ref().child(user.uid).child("pfp.jpg");
    StorageUploadTask task = backgroundLoc.putFile(image);
    bgurl = await (await task.onComplete).ref.getDownloadURL();
  });
  //now update user reference
  _firestore.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(userRef);
    if (postSnapshot.exists) {
      await tx.update(userRef, <String, String>{'pfp': bgurl});
    }
  });
}

void _uploadBackground(File image) async {
  String bgurl;
  FirebaseUser user = await _auth.currentUser();
  DocumentReference userRef = _firestore.collection("users").document(user.uid);
  await userRef.get().then((DocumentSnapshot ds) async {
    //upload to firestore
    StorageReference backgroundLoc =
        _storage.ref().child(user.uid).child("background.jpg");
    StorageUploadTask task = backgroundLoc.putFile(image);
    bgurl = await (await task.onComplete).ref.getDownloadURL();
  });
  //now update user reference
  _firestore.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(userRef);
    if (postSnapshot.exists) {
      await tx.update(userRef, <String, String>{'bgurl': bgurl});
    }
  });
}
