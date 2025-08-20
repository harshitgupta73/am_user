import 'package:flutter/material.dart';
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

   try {
     final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

     if (!launched) {
       showAppSnackBar(
         context,
         "Could not open dialer",
         backgroundColor: Colors.red,
       );
     }
   } catch (e) {
     showAppSnackBar(
       context,
       "Error: $e",
       backgroundColor: Colors.red,
     );
     print("Error launching dialer: $e");
   }
 }


}