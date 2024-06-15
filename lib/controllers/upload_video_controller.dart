// // ignore_for_file: unused_local_variable, avoid_print, await_only_futures

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:tiktak/constants/constants.dart';
// import 'package:tiktak/models/video.dart';
// import 'package:video_compress/video_compress.dart';

// class UploadVideoController extends GetxController {
//   _compressVideo(String videoPath) async {
//     final compressedVideo = await VideoCompress.compressVideo(videoPath,
//         quality: VideoQuality.MediumQuality);
//     return compressedVideo!.file;
//   }

//   Future<String> _uploadVideoToStorage(String id, String videoPath) async{
//     Reference ref = firebaseStorage.ref().child("videos").child(id);

//     UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));

//     TaskSnapshot snap = await uploadTask;

//     String downloadUrl = await snap.ref.getDownloadURL();

//     return downloadUrl;
//   }

//   _getThumbnail(String videoPath) async {
//     final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
//     return thumbnail;
//   }

//   Future<String> _uploadImageToStorage(String id, String videoPath) async {
//     Reference ref = firebaseStorage.ref().child("thumbnails").child(id);

//     UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));

//     TaskSnapshot snap = await uploadTask;

//     String downloadUrl = await snap.ref.getDownloadURL();

//     return downloadUrl;
//   }

//   uploadVideo(String songName, String caption, String videoPath) async {
//     try {
//       String uid = await firebaseAUth.currentUser!.uid;
//       DocumentSnapshot userDoc =
//           await fireStore.collection("users").doc(uid).get();

//       final allDocs = await fireStore.collection("videos").get();
//       int len = allDocs.docs.length;
//       String videoUrl = await _uploadVideoToStorage("video $len", videoPath);
//       String thumbnail = await _uploadImageToStorage("video $len", videoPath);

//       Video video = Video(
//         username: (userDoc.data()! as Map<String, dynamic>)['name'],
//         uid: uid,
//         id: "Video $len",
//         likes: [],
//         commentCount: 0,
//         shareCount: 0,
//         songName: songName,
//         caption: caption,
//         videoUrl: videoUrl,
//         profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
//         thumbnail: thumbnail,
//       );
//     } catch (err){
//       print("catch error occured while uploading the video");
//     } finally {
  
//     }
//   }
// }
