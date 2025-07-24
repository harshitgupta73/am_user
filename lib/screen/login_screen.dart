import 'dart:convert';

import 'package:am_user/controller/user_provider/get_user_provider.dart';
import 'package:am_user/data/firebase/auth/registration.dart';
import 'package:am_user/data/firebase/user/user_insert_update.dart';
import 'package:am_user/data/shareprefrance/shareprefrance.dart';
import 'package:am_user/modals/shopModal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/component/custome_textfield.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:am_user/widgets/utils/loading_indicator.dart';
import 'package:am_user/widgets/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../modals/driver_modal.dart';

class LoginScreen extends StatefulWidget {
  // String whoIs;

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final userController = Get.find<GetUserController>();

  Auth auth = Auth();
  UserMethod userMethod = UserMethod();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final SharePreferencesMethods sharePreferencesMethods =
      SharePreferencesMethods();

  bool _obscurePassword = false;
  bool _isLogin = false;

  // void _loginWithEmailAndPassword() async {
  //   // Show the loader inside a dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder:
  //         (context) => const ShowLoadingIndicator(message: "Please wait..."),
  //   );
  //
  //   // Call Firebase Auth
  //   final result = await auth.loginWithEmailAndPassword(
  //     email: _emailController.text.trim(),
  //     password: _passwordController.text.trim(),
  //   );
  //
  //   // Close the loader
  //   Navigator.of(context, rootNavigator: true).pop();
  //
  //   // Show the result
  //   if (result == null) {
  //     // Get current logged in user ID
  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //     final firestore = FirebaseFirestore.instance;
  //
  //     // Check for user type
  //     final shopDoc = await firestore.collection("Shops").doc(uid).get();
  //     final driverDoc = await firestore.collection("drivers").doc(uid).get();
  //     final workerDoc = await firestore.collection("Workers").doc(uid).get();
  //
  //     // Redirect based on document existence
  //
  //     if (shopDoc.exists) {
  //       print("Shopdoc = ${shopDoc.data()}");
  //       final data = shopDoc.data();
  //       if (data != null) {
  //         final shopModal = ShopModal.fromJson(data);
  //         await sharePreferencesMethods.saveShopToSharedPref(shopModal);
  //         print("Shop document exists");
  //         context.pushReplacement("${RoutsName.bottomNavigation}/0");
  //       } // you need to define this
  //     } else if (driverDoc.exists) {
  //       final data = driverDoc.data();
  //       if (data != null) {
  //         final driverModal = DriverModal.fromJson(data);
  //         await sharePreferencesMethods.saveVehicleToSharedPref(driverModal);
  //       }
  //       print("Driver document exists");
  //       context.pushReplacement("${RoutsName.bottomNavigation}/0");
  //     } else if (workerDoc.exists) {
  //       final data = workerDoc.data();
  //       if (data != null) {
  //         final workerModal = WorkerModal.fromJson(data);
  //         await sharePreferencesMethods.saveWorkerToSharedPref(workerModal);
  //       }
  //       print("Worker document exists");
  //       context.pushReplacement("${RoutsName.bottomNavigation}/0");
  //     } else {
  //       print("No document exists");
  //       context.pushReplacement("${RoutsName.bottomNavigation}/0");
  //     }
  //     Utils.showAppSnackBar(
  //       context,
  //       "Login Successful",
  //       backgroundColor: Colors.green,
  //     );
  //   } else {
  //     Utils.showAppSnackBar(context, result, backgroundColor: Colors.red);
  //   }
  // }

  void _loginWithEmailAndPassword() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ShowLoadingIndicator(message: "Please wait..."),
    );

    // Attempt login
    final result = await auth.loginWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Close loading
    Navigator.of(context, rootNavigator: true).pop();

    if (result == null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final firestore = FirebaseFirestore.instance;

      String? detectedUserType;

      // Detect user type
      final shopDoc = await firestore.collection("Shops").doc(uid).get();
      if (shopDoc.exists) {
        detectedUserType = "Shops";
      }

      final workerDoc = await firestore.collection("Workers").doc(uid).get();
      if (workerDoc.exists) {
        detectedUserType = "Workers";
      }

      final driverDoc = await firestore.collection("drivers").doc(uid).get();
      if (driverDoc.exists) {
        detectedUserType = "drivers";
      }

      if (detectedUserType != null) {
        // Save userType and uid in SharedPreferences
        await sharePreferencesMethods.saveUserTypeAndUid(detectedUserType, uid);
        print("Detected User Type: $detectedUserType");

        // Load user from Firestore (optional - or defer to splash)
        // await UserLoader().loadUserFromFirestore();

        Utils.showAppSnackBar(
          context,
          "Login Successful",
          backgroundColor: Colors.green,
        );

        context.pushReplacement("${RoutsName.bottomNavigation}/0");
      } else {
        context.pushReplacement("${RoutsName.bottomNavigation}/0");
        Utils.showAppSnackBar(
          context,
          "Login successfully",
          backgroundColor: Colors.red,
        );
      }
    } else {
      Utils.showAppSnackBar(context, result, backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            // margin: EdgeInsets.symmetric(vertical: 200),
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              alignment: Alignment.center,
              width: 500,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Row(
                    children: [
                      Text(
                        " Login ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 21,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  ClipRRect(
                    child: Image.asset(logo, height: 150, fit: BoxFit.cover),
                  ),

                  Text(
                    "Ready to Connect",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  SizedBox(height: 20),
                  CustomTextField(
                    label: 'Email ',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password is required';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    textColor: Colors.black,
                    backgroundColor: backgroundColor,
                    label: "Login",
                    onPressed: _loginWithEmailAndPassword,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          context.push(RoutsName.forgotPassword);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                            context.push(RoutsName.registrationScreen);

                        },
                        child: Text(
                          "I haven't Account? Register",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // _doNotHaveAccount() {
  //   final whoIs = widget.whoIs;
  //   if (whoIs == userLogin) {
  //     context.push(RoutsName.registrationScreen);
  //   } else if (whoIs == driverLogin) {
  //     context.push(RoutsName.driverRegisterScreen);
  //   } else if (whoIs == shopLogin) {
  //     context.push(RoutsName.shopRegisterScreen);
  //   } else {
  //     context.push(RoutsName.workRegisterScreen);
  //   }
  // }
}
