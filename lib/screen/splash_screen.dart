import 'package:am_user/widgets/constants/login_type.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';


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
    Future.delayed(const Duration(seconds: 3), () {
    User?  user = auth.currentUser;
    if(user !=null){
      context.push("${RoutsName.bottomNavigation}/0");

    }else{
      context.push(RoutsName.registrationScreen);

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
            // Animated Logo
            Image.asset(
             logo,
              width: 120,
              height: 120,
            )
                .animate()
                .scale(duration: 900.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 1200.ms),
            const SizedBox(height: 20),
            // App Name
            const Text(
              "My Premium App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
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
