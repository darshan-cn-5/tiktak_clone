import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

PickImage(ImageSource source) async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await  file.readAsBytes();
  }
}
