import 'dart:convert';
import 'package:am_user/modals/driver_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';


void customNavigate(BuildContext context, String page, dynamic data) {
  final path;
  if(data !=null){
     path = "$page/$data";
  }else{
    path = page;
  }

  if (kIsWeb) {
    context.go(path); // Web-friendly navigation
  } else {
    context.push(path); // Push onto the stack in mobile/native
  }
}

String encodeDriverToUrl(DriverModal driver) {
  final jsonString = jsonEncode(driver.toJson());
  final base64 = base64UrlEncode(utf8.encode(jsonString)); // Base64-encode
  return Uri.encodeComponent(base64); // URL-encode the base64 string
}

DriverModal decodeDriverFromUrl(String encoded) {
  final decoded = Uri.decodeComponent(encoded); // URL-decode
  final jsonString = utf8.decode(base64Url.decode(decoded)); // Base64-decode
  final data = jsonDecode(jsonString);
  return DriverModal.fromJson(data);
}


Future<Uint8List>profilePlaceHolder()async{
  final ByteData byteData = await rootBundle.load("assets/images/default-avatar-photo-placeholder-profile-icon-vector.jpg");
  return byteData.buffer.asUint8List();
}