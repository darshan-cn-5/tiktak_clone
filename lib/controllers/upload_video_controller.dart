// ignore_for_file: unused_local_variable, avoid_print, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktak/constants/constants.dart';
import 'package:tiktak/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  var isUploading = false.obs;

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("videos").child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    print("successfully uploaded video to storage");

    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("thumbnails").child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();
    print("successfully uploaded image to storage");
    return downloadUrl;
  }

  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      isUploading.value = true;

      String uid = await firebaseAUth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await fireStore.collection("users").doc(uid).get();

      final allDocs = await fireStore.collection("videos").get();
      int len = allDocs.docs.length;
      print("executing uploading video to storage");
      String videoUrl = await _uploadVideoToStorage("video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("video $len", videoPath);

      print("going for uploading final data to firebase firestore");
      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['photoUrl'],
        thumbnail: thumbnail,
      );

      await fireStore
          .collection("videos")
          .doc("video $len")
          .set(video.toJson());
      isUploading.value = false;
    } catch (err) {
      print("catch error occured while uploading the video");
    } finally {
      isUploading.value = false;
      print("finally uploading the video");
    }
  }
}
