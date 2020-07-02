import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openchat/profile.dart';
import 'dart:io';

import 'package:openchat/storage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final CloudStorageService _service = CloudStorageService();
final Firestore _firestore = Firestore.instance;

File _pfp;
File _bg;

class ProfileEditScreen extends StatefulWidget {
  ProfileEditScreenState createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<ProfileEditScreen> {
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: uploading
            ? FutureBuilder(
                future: upload(),
                builder: (BuildContext context,
                    AsyncSnapshot<CloudStorageResult> upload) {
                  if (upload.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Profile has been updated.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          RaisedButton(
                            child: Text("OK"),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new ProfileScreen()));
                            },
                          )
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                })
            : Column(
                children: <Widget>[
                  ProfileBackground(),
                  ProfilePicture(),
                  RaisedButton(
                      onPressed: () {
                        if (_pfp != null || _bg != null) {
                          setState(() {
                            uploading = true;
                          });
                        }
                      },
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Finalize",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ))
                ],
              ));
  }
}

class ProfileBackground extends StatefulWidget {
  ProfileBackgroundState createState() => ProfileBackgroundState();
}

class ProfileBackgroundState extends State<ProfileBackground> {
  final picker = ImagePicker();

  Future getBackground() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _bg = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FutureBuilder(
          future: _getUserInfo(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
            //bg has been selected
            if (_bg != null) {
              return Container(
                child: Image.file(
                  _bg,
                  fit: BoxFit.fill,
                ),
                width: MediaQuery.of(context).size.width,
                height: 300,
              );
            } //no bg selected
            else if (userinfo.hasData) {
              //userinfo has data associated with it
              if (userinfo.data["bgurl"] != "") {
                //userinfo doesnt have a blank url
                return Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    child: CachedNetworkImage(
                      imageUrl: userinfo.data["bgurl"],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ));
              }
            }
            return Container(
              //return blank container
              color: Theme.of(context).primaryColor,
              width: MediaQuery.of(context).size.width,
              height: 300,
            );
          },
        ),
        Container(
            height: 250,
            alignment: Alignment(.9,
                -.6), //don't know if stuff like this is good convention, too used to android
            child: ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Theme.of(context).primaryColor, // inkwell color
                  child:
                      SizedBox(width: 35, height: 35, child: Icon(Icons.edit)),
                  onTap: () {
                    getBackground();
                  },
                ),
              ),
            ))
      ],
    );
  }
}

class ProfilePicture extends StatefulWidget {
  ProfilePictureState createState() => ProfilePictureState();
}

class ProfilePictureState extends State<ProfilePicture> {
  final picker = ImagePicker();
  Future getPfp() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pfp = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: <Widget>[
        FutureBuilder(
          future: _getUserInfo(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> userinfo) {
            if (_pfp != null) {
              return Container(
                padding: EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  child: FlatButton(
                    child: Icon(Icons.edit),
                    onPressed: () {
                      getPfp();
                    },
                  ),
                  backgroundImage: Image.file(
                    _pfp,
                    fit: BoxFit.fill,
                  ).image,
                  radius: 50,
                ),
              );
            } else if (userinfo.hasData) {
              if (userinfo.data["pfp"] != "") {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  child: CircleAvatar(
                    child: FlatButton(
                      child: Icon(Icons.edit),
                      onPressed: () {
                        getPfp();
                      },
                    ),
                    backgroundImage:
                        CachedNetworkImageProvider(userinfo.data["pfp"]),
                    radius: 50,
                  ),
                );
              }
            }
            return Container(
              padding: EdgeInsets.only(top: 20),
              child: CircleAvatar(
                child: FlatButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    getPfp();
                  },
                ),
                backgroundImage: Image.asset(
                  'assets/images/placeholder.png',
                  fit: BoxFit.fill,
                ).image,
                radius: 50,
              ),
            );
          },
        ),
      ],
    ));
  }
}

Future<CloudStorageResult> upload() async {
  CloudStorageResult pfpResult;
  CloudStorageResult bgResult;

  FirebaseUser user = await _auth.currentUser();
  DocumentReference userRef = _firestore.collection("users").document(user.uid);

  if (_pfp != null && _bg != null) {
    bgResult = await _service.uploadImage(imageToUpload: _bg, title: "bg");
    pfpResult = await _service.uploadImage(
      imageToUpload: _pfp,
      title: "pfp",
    );
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(userRef);
      if (postSnapshot.exists) {
        await tx.update(userRef, <String, String>{'pfp': pfpResult.imageUrl});
        await tx.update(userRef, <String, String>{'bgurl': bgResult.imageUrl});
      }
    });
    return bgResult;
  } else if (_pfp != null) {
    pfpResult = await _service.uploadImage(imageToUpload: _pfp, title: "pfp");

    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(userRef);
      if (postSnapshot.exists) {
        await tx.update(userRef, <String, String>{'pfp': pfpResult.imageUrl});
      }
    });
    return pfpResult;
  } else if (_bg != null) {
    bgResult = await _service.uploadImage(imageToUpload: _bg, title: "bg");
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(userRef);
      if (postSnapshot.exists) {
        await tx.update(userRef, <String, String>{'bgurl': bgResult.imageUrl});
      }
    });
    return bgResult;
  }
  return CloudStorageResult();
}

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
