import 'package:am_user/data/firebase/user/user_insert_update.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/component/custom_buttom.dart';
import '../widgets/component/custome_textfield.dart';
import '../widgets/constants/login_type.dart';
import '../widgets/routs/routs.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final  userMethod = UserMethod();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text("Forgot Password"), centerTitle: true),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 160),
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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    ClipRRect(
                      child: Image.asset(logo, height: 150, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Enter your email for email verification",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    CustomTextField(
                      label: 'Email ',
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      color: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      textColor: Colors.black,
                      backgroundColor: backgroundColor,
                      label: "Send Email",
                      onPressed: _loginWithEmailAndPassword,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginWithEmailAndPassword() async {
    if(formKey.currentState!.validate()){
      final email = _emailController.text.trim(); // <-- trim!
      try {
        await userMethod.forgotPassword(email);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password reset link sent to your email"))
        );
      } catch (e) {
        print("Error sending password reset email: $e");
      }
    }
  }
}
