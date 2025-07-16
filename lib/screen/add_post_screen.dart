import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/image_picker_controller.dart';
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
    XFile? file;

    if (isVideo) {
      file = await picker.pickVideo(source: ImageSource.gallery);
    } else {
      file = await picker.pickImage(source: ImageSource.gallery);
    }

    if (file != null) {
      selectedFile = File(file.path);
      setState(() {});
    }
  }

  Future<void> upload() async {
    if (selectedFile == null) {
      Get.snackbar("No File", "Please pick a file");
      return;
    }

    await mediaController.uploadSingleMedia(
      user: user,
      file: selectedFile!,
      isVideo: isVideo,
    );

    selectedFile = null;
    setState(() {});
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
              title: Text("Upload as Video"),
              value: isVideo,
              onChanged: (val) => setState(() => isVideo = val),
            ),
            ElevatedButton(
              onPressed: pickSingleFile,
              child: Text("Pick ${isVideo ? 'Video' : 'Image'}"),
            ),
            if (selectedFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isVideo
                    ? const Icon(Icons.videocam, size: 100)
                    : Image.file(selectedFile!, height: 150),
              ),
            ElevatedButton(
              onPressed: upload,
              child: Text("Upload"),
            ),
            const SizedBox(height: 10),
            Obx(() => mediaController.isUploading.value
                ? const CircularProgressIndicator()
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}

