import 'package:am_user/widgets/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/user_provider/get_user_provider.dart';
import '../widgets/common_methods.dart';
import '../widgets/routs/routs.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  
  final userController = Get.find<GetUserController>();
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // status bar background
        statusBarIconBrightness: Brightness.dark, // icons: time, battery
      ),
    );
    String type = "";
    if (userController.shopModal.value != null) {
      type = 'Shop';
    } else if (userController.driverModal.value != null) {
      type = 'Driver';
    } else if (userController.workerModal.value != null) {
      type = 'Worker';
    } else {
      type = 'user';
    }    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Registration", style: TextStyle(color: customTextColor)),
        centerTitle: true,
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: type == "user" ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                context.push(RoutsName.shopRegisterScreen);
              },
              child: Row(
                children: [
                  Icon(Icons.home_work,color: Colors.cyan,size: 40,),
                  SizedBox(width: 20,),
                  Text(
                    "Business & Shop",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                customNavigate(context, RoutsName.workRegisterScreen, null);
              },
              child: Row(
                children: [
                  Icon(Icons.manage_accounts,color: Colors.deepPurpleAccent,size: 40,),
                  SizedBox(width: 20,),
                  Text(
                    "Workers",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                context.push(RoutsName.driverRegisterScreen);
              },
              child: Row(
                children: [
                  Icon(Icons.directions_car_filled,color: Colors.redAccent,size: 40,),
                  SizedBox(width: 20,),
                  Text(
                    "Vehicles",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,color: Colors.green,size: 100,),
            SizedBox(height: 20,),
            Text("Already Registered",style: TextStyle(color: Colors.lightBlue,fontSize: 28,fontWeight: FontWeight.bold),),
          ],
        ),
      )
    );
  }
}
