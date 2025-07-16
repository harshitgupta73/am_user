import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServices{

  final storage = FirebaseStorage.instance;

  Future<String> uploadPdf(File file) async{
    try{
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = storage.ref().child('pdfs/$fileName.pdf');
      final uploadTask =await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    }catch(e){
      print("Error storing pdf: $e");
      rethrow;
    }
  }

  Future<String> uploadImage(File file) async{
    try{
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = storage.ref().child('images/$fileName.jpg');
      final uploadTask =await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    }catch(e){
      print("Error storing pdf: $e");
      rethrow;
    }
  }
}