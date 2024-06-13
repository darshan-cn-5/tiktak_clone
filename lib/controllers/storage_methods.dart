import "dart:typed_data";

import "package:firebase_storage/firebase_storage.dart";

class FirebaseStorageMethods {
  FirebaseStorage _fireStore = FirebaseStorage.instance;

  Future<String> uploadPhoto(String path, String uid, Uint8List file) async {
    Reference storageRef = await _fireStore.ref().child("$path").child("$uid");

    UploadTask uploadTask = storageRef.putData(file);
    TaskSnapshot snap = await uploadTask;

    String photoUrl = await snap.ref.getDownloadURL();

    return photoUrl;
  }
}
