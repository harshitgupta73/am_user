import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerController extends GetxController {
  RxString imagePath = ''.obs;
  RxString licenceImage=''.obs;
  RxString rcImage = ''.obs;
  RxString videoPath = ''.obs;

  Future<bool> requestImagePickerPermissions() async {
    // final cameraStatus = await Permission.camera.request();
    // final storageStatus = await Permission.storage.request();
    final imageRequest = await Permission.photos.request();

    if (imageRequest.isDenied) {
      return true;
    }

    // 📌 Handle permanently denied case
    if (imageRequest.isPermanentlyDenied || imageRequest.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  Future getImage() async {

    if (!await requestImagePickerPermissions()) return;

    final ImagePicker _picker = ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      imagePath.value= image.path;
    }
  }

  Future getLicenceImage() async {
    if (!await requestImagePickerPermissions()) return;
    final ImagePicker _picker = ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      licenceImage.value= image.path;
    }
  }

  Future getRCImage() async {
    if (!await requestImagePickerPermissions()) return;
    final ImagePicker _picker = ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      rcImage.value= image.path;
    }
  }

  Future getVideo() async {
    if (!await requestImagePickerPermissions()) return;
    final ImagePicker _picker = ImagePicker();
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      videoPath.value = video.path;
    }
  }
}