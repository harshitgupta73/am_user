import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import '../controller/media_controllers/media_controller.dart';
import '../controller/user_provider/get_user_provider.dart';
import '../modals/userModal.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final ImagePicker picker = ImagePicker();
  final MediaController mediaController = Get.find();
  final UserModal user = Get.find<GetUserController>().myUser!;

  File? selectedFile;
  bool isVideo = false;

  Future<void> pickSingleFile() async {
    try {
      XFile? file;

      if (isVideo) {
        file = await picker.pickVideo(source: ImageSource.gallery);
        if (file != null) {
          await compressVideo(file.path);
          if (compressedVideo?.file != null) {
            selectedFile = compressedVideo!.file!;
          } else {
            return;
          }
        } else {
          return;
        }
      } else {
        file = await picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          selectedFile = File(file.path);
        } else {
          return;
        }
      }

      setState(() {});
    } catch(e){
      rethrow;
    }
  }

  Future<void> upload() async {
    if (selectedFile == null) {
      Get.snackbar("No File", "Please pick a file");
      return;
    }

    await mediaController.uploadSingleMedia(
      user: user,
      file:isVideo ? compressedVideo!.file! : selectedFile!,
      isVideo: isVideo,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Uploaded Successfully"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    selectedFile = null;
    compressedVideo = null;
    setState(() {});
  }

  MediaInfo? compressedVideo;

  Future<void> compressVideo(String path)async {
    final info = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.MediumQuality, // Options: Low, Medium, High, VeryHigh
      deleteOrigin: false, // Set true to delete original file
    );

    if (info != null) {
      setState(() {
        compressedVideo = info;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    VideoCompress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Media")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(
                "Upload as Video",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              value: isVideo,
              onChanged: (val) => setState(() => isVideo = val),
              activeColor: Colors.blue,
              activeTrackColor: Colors.blue.shade100,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.zero,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: pickSingleFile,
              child: Text(
                "Pick ${isVideo ? 'Video' : 'Image'}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (selectedFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    isVideo
                        ? const Icon(Icons.videocam, size: 100)
                        : Image.file(selectedFile!, height: 150),
              ),
            ElevatedButton(
              onPressed: upload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child:Obx(() => mediaController.isUploading.value
                    ? const CircularProgressIndicator()
                    : Text("Upload", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
