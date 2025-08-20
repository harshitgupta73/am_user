import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    // Navigate after delay with default currentIndex = 0
    Future.delayed(const Duration(seconds: 5), () {
    User?  user = auth.currentUser;
    if(user !=null){
      context.pushReplacement("${RoutsName.bottomNavigation}/0");

    }else{
      context.pushReplacement(RoutsName.registrationScreen);

    }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(height: 10),
            Lottie.asset("assets/animation/amuserLottie.json"),

            // App Name
            const Text(
              tagLine,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
