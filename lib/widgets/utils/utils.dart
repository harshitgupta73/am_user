import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';


class Utils{

 static void showAppSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor ?? Colors.black87,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).clearSnackBars(); // Optional: Clear existing
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
 }

 Future<void> dialNumber(String phoneNumber, BuildContext context) async {
   final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

   final phonePermission = await Permission.phone.request();

   if (phonePermission.isGranted) {
     try {
       if (await canLaunchUrl(uri)) {
         await launchUrl(uri,mode: LaunchMode.externalApplication);
       } else {
         showAppSnackBar(context, "Cannot open dialer");
       }
     } catch (e) {
       showAppSnackBar(context, "Error: $e");
       print("Error: $e");
     }
   } else if (phonePermission.isPermanentlyDenied) {
     await openAppSettings();
   } else {
     showAppSnackBar(context, "Phone permission is required to make a call.");
   }
 }
}