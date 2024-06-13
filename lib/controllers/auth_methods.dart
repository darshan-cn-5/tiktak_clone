// ignore_for_file: non_constant_identifier_names, empty_catches, prefer_final_fields

import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:tiktak/controllers/storage_methods.dart";

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseStorageMethods _storageMethods = FirebaseStorageMethods();

  Future<bool> SignupUser(
      String username, String password, String email, Uint8List file) async {
    bool result = false;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await _storageMethods.uploadPhoto(
            "profilepics", "${cred.user!.uid}", file);

        await _fireStore.collection("users").doc("${cred.user!.uid}").set({
          "username": username,
          "uid": cred.user!.uid,
          "password": password,
          "email": email,
          "photoUrl": photoUrl,
        });

        print("successfully registered the user ");

        result = true;
      } else {
        print("else error occcured while registering the user");
        result = false;
      }
    } catch (err) {
      print("catch error occured while registering the suer");
      result = false;
    }
    return result;
  }

  Future<bool> LoginUser(String email, String password) async {
    bool result = false;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = true;

        print("successfully logged in ");
      }
    } catch (err) {
      print("catch error occured while logging in");
      result = false;
    }
    return result;
  }

  Future<bool> logoutUser() async{
    bool result = false;
    try {
      await _auth.signOut();
      result = true;
      print("successfully logged our from the app");
    } catch (err) {
      print("catch error occured while logging out");
      result = false;
    }
    return result;
  }
}
