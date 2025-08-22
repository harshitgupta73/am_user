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
        statusBarColor: Colors.black, 
        statusBarIconBrightness: Brightness.dark, 
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
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/104a911c63dcaf4814ee6136c5825d5b.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
                customNavigate(context, RoutsName.workRegisterScreen);
              },
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/d50eb623382d5c7483cca89cc13582f7.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/ffeab1a8e03347dba1cf79d32d055309.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
