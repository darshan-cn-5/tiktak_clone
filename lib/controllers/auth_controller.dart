// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, unnecessary_null_comparison, avoid_print, prefer_const_constructors, prefer_typing_uninitialized_variables, unused_local_variable

import "dart:io";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "package:tiktak/constants/constants.dart";
import "package:tiktak/models/user.dart" as model;
import "package:tiktak/views/screens/auth/login_screen.dart";
import "package:tiktak/views/screens/home_screen.dart";

class AuthController extends GetxController{
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;

  @override
  void onReady() {
    super.onReady();
    var firebaseAuth;
    _user = Rx<User?>(firebaseAUth.currentUser);
    _user.bindStream(firebaseAUth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  Future<String> UploadPhoto(File image) async {
    Reference storageref = firebaseStorage
        .ref()
        .child("profilepics")
        .child("${firebaseAUth.currentUser!.uid}");

    UploadTask uploadTask = storageref.putFile(image);

    TaskSnapshot snap = await uploadTask;

    String photoUrl = await snap.ref.getDownloadURL();

    return photoUrl;
  }

  void RegisterUser(
      String username, String email, String password, File image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await firebaseAUth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await UploadPhoto(image);

        model.User user = model.User(
            username: username,
            email: email,
            password: password,
            photoUrl: photoUrl,
            uid: firebaseAUth.currentUser!.uid);

        await fireStore
            .collection("users")
            .doc("${cred.user!.uid}")
            .set(user.tojson());

        print("successfully registered the user");
      }
    } catch (err) {
      Get.snackbar("Error resgitering user", "${err.toString()}");
    }
  }

  void LoginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAUth.signInWithEmailAndPassword(
            email: email, password: password);
        print("login Success through getx");
      } else {
        Get.snackbar("Error", "please fill all the fields");
      }
    } catch (err) {
      Get.snackbar("Error", "${err.toString()}");
    }
  }

  void signOutUser() async{
    try {
      await firebaseAUth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (err) {
      Get.snackbar("Error", "${err.toString()}");
    }
  }
}
