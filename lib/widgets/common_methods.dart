import 'dart:convert';

import 'package:am_user/modals/driver_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

void customNavigate(
  BuildContext context,
  String? page, {
  Map<String, String>? queryParams,
  dynamic data,
  bool pop = false,
}) {
  if (pop) {
    context.pop(); // ✅ works on mobile & web
    return;
  }
  String path = page ?? "";

  // If you want to support `/page/data`
  if (data != null) {
    path = "$page/$data";
  }

  // If query params are provided
  if (queryParams != null && queryParams.isNotEmpty) {
    final queryString = Uri(queryParameters: queryParams).query;
    path = "$path?$queryString";
  }

  if (kIsWeb) {
    context.go(path);
  } else {
    context.push(path);
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

Future<Uint8List> profilePlaceHolder() async {
  final ByteData byteData = await rootBundle.load(
    "assets/images/default-avatar-photo-placeholder-profile-icon-vector.jpg",
  );
  return byteData.buffer.asUint8List();
}
