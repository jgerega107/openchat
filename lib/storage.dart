import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload,
    @required String title,
  }) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("users")
        .child(currentUser.uid)
        .child(imageFileName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }

    return null;
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}
