import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String password;
  String email;
  String uid;
  String photoUrl;

  User(
      {required this.username,
      required this.password,
      required this.email,
      required this.uid,
      required this.photoUrl});

 static User  fromjson(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return User(
      username: snap['username'],
      password: snap['password'],
      email: snap['email'],
      uid: snap['uid'],
      photoUrl: snap['photoUrl'],
    );

  }

  Map<String,dynamic> tojson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'uid': uid,
      'photoUrl': photoUrl,
    };
  }
}
