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
         showAppSnackBar(context, "Cannot open dialer",backgroundColor: Colors.red);
       }
     } catch (e) {
       showAppSnackBar(context, "Error: $e",backgroundColor: Colors.red);
       print("Error: $e");
     }
   } else if (phonePermission.isPermanentlyDenied) {
     await openAppSettings();
   } else {
     showAppSnackBar(context, "Phone permission is required to make a call.",backgroundColor: Colors.red);
   }
 }

// Future<void> dialNumber(String phoneNumber, BuildContext context) async {
//   final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
//
//   try {
//     if (await canLaunchUrl(uri)) {
//       final status = await Permission.phone.status;
//
//       if (status.isGranted || status.isLimited || status.isDenied) {
//         await launchUrl(uri, mode: LaunchMode.platformDefault);
//       } else if (status.isPermanentlyDenied) {
//         showAppSnackBar(context, "Permission permanently denied, open settings.",backgroundColor: Colors.red);
//         await openAppSettings();
//       } else {
//         final result = await Permission.phone.request();
//         if (result.isGranted) {
//           await launchUrl(uri, mode: LaunchMode.platformDefault);
//         } else {
//           showAppSnackBar(context, "Phone permission denied.",backgroundColor: Colors.red);
//         }
//       }
//     } else {
//       showAppSnackBar(context, "Cannot launch dialer.",backgroundColor: Colors.red);
//     }
//   } catch (e) {
//     print("Error: $e");
//     showAppSnackBar(context, "Error launching dialer: $e",backgroundColor: Colors.red);
//   }
// }
//   Future<void> dialNumber(String phoneNumber, BuildContext context) async {
//     final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
//
//     try {
//       if (await canLaunchUrl(uri)) {
//         final status = await Permission.phone.status;
//
//         if (status.isGranted) {
//           // Permission already granted
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         } else if (status.isPermanentlyDenied) {
//           // Permanently denied → Tell user and open settings
//           showAppSnackBar(
//             context,
//             "Permission permanently denied, please enable in settings.",
//             backgroundColor: Colors.red,
//           );
//           await openAppSettings();
//         } else {
//           // Ask for permission
//           final result = await Permission.phone.request();
//           if (result.isGranted) {
//             await launchUrl(uri, mode: LaunchMode.externalApplication);
//           } else {
//             showAppSnackBar(
//               context,
//               "Phone permission denied.",
//               backgroundColor: Colors.red,
//             );
//           }
//         }
//       }
//       else {
//         showAppSnackBar(
//           context,
//           "Cannot launch dialer.",
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       debugPrint("Error launching dialer: $e");
//       showAppSnackBar(
//         context,
//         "Error launching dialer: $e",
//         backgroundColor: Colors.red,
//       );
//     }
//   }

// Future<void>
}