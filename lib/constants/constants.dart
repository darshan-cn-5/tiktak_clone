// ignore_for_file: prefer_const_constructors

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:tiktak/controllers/auth_controller.dart";
import "package:tiktak/views/screens/add_video_screen.dart";
import "package:tiktak/views/screens/profile_screen.dart";
import "package:tiktak/views/screens/video_screen.dart";

// COLORS

const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//FIREBASE

final FirebaseAuth firebaseAUth = FirebaseAuth.instance;
final FirebaseFirestore fireStore = FirebaseFirestore.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

// CONTROLLER

final authController = AuthController.instance;

// PAGES

List pages = [
  // Text("Home Screen"),
  VideoScreen(),
  Text("Search Screen"),
  // Text("Add Video Screen"),
  AddVideoScreen(),
  Text('Messages Screen'),
  // Text("Profile Screen"),
  ProfileScreen(),
];
