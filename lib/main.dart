
import 'package:am_user/controller/ad_controller/ad_controller.dart';
import 'package:am_user/controller/controllers.dart';
import 'package:am_user/controller/job_controller/job_controller.dart';
import 'package:am_user/controller/media_controllers/media_controller.dart';
import 'package:am_user/controller/price_controller.dart';
import 'package:am_user/controller/user_provider/get_user_provider.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/chat_controller/chat_controller.dart';
import 'controller/image_picker_controller.dart';
import 'controller/location_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(LocationController());
  Get.put(GetUserController());
  Get.put(MediaController());
  Get.put(Controller());
  Get.put(ChatController());
  Get.put(ImagePickerController());
  Get.put(JobController());
  Get.put(AdController());
  Get.put(PriceController());

  final controller = Get.find<GetUserController>();
  controller.getUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Am User',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      routerConfig: router,
    );
  }
}
