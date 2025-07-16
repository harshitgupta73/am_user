import 'dart:io';

import 'package:get/get.dart';

import '../../data/firebase/user/user_insert_update.dart';
import '../../modals/userModal.dart';

class MediaController extends GetxController {
  final UserMethod _service = UserMethod();
  final isUploading = false.obs;

  Future<void> uploadSingleMedia({
    required UserModal user,
    required File file,
    required bool isVideo,
  }) async {
    try {
      isUploading.value = true;

      final url = await _service.uploadSingleMedia(file, isVideo);
      await _service.addMediaToUser(
        userId: user.userId!,
        mediaUrl: url,
        isVideo: isVideo,
      );

      Get.snackbar("Success", "Uploaded successfully");
    } catch (e) {
      Get.snackbar("Upload Failed", e.toString());
    } finally {
      isUploading.value = false;
    }
  }
}
