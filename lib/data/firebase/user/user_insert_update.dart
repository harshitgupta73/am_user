
import 'dart:io';

import 'package:am_user/widgets/constants/firebse_const/string_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../modals/userModal.dart';


class UserMethod{

  Future<String?> insertUser(UserModal user, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection(userCollation)
          .doc(uid)
          .set(user.toJson());
      print('User inserted successfully');
      return null; // success
    } catch (e) {
      print('Insert failed: $e');
      return 'Insert failed: ${e.toString()}';
    }
  }

  Future<String?> updateUser(UserModal user, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection(userCollation)
          .doc(uid)
          .update(user.toJson());
      print('User updated successfully');
      return null; // success
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        print('User not found');
        return 'User not found';
      } else {
        print('Update failed: $e');
        return 'Update failed: ${e.message}';
      }
    } catch (e) {
      return 'Unexpected error: ${e.toString()}';
    }
  }

  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<UserModal?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(userCollation) // Adjust collection name if different
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModal.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found for ID: $userId');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }


  Future<String> uploadSingleMedia(File file, bool isVideo) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String path = isVideo ? 'users/videos/$fileName' : 'users/images/$fileName';

    TaskSnapshot snap = await _storage.ref().child(path).putFile(file);
    return await snap.ref.getDownloadURL();
  }

  Future<void> addMediaToUser({
    required String userId,
    required String mediaUrl,
    required bool isVideo,
  }) async {
    final doc = _db.collection('Users').doc(userId);
    final snapshot = await doc.get();
    final data = snapshot.data();

    List<String> currentMedia = List<String>.from(
      data?[isVideo ? 'Videos' : 'Images'] ?? [],
    );

    if ((isVideo && currentMedia.length >= 6) ||
        (!isVideo && currentMedia.length >= 10)) {
      throw Exception(isVideo ? "Max 6 videos allowed" : "Max 10 images allowed");
    }

    currentMedia.add(mediaUrl);

    await doc.update({
      isVideo ? 'Videos' : 'Images': currentMedia,
    });
  }


}