import 'package:am_user/data/firebase/auth/registration.dart';
import 'package:am_user/data/firebase/user/user_insert_update.dart';
import 'package:am_user/data/shareprefrance/shareprefrance.dart';
import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/component/custome_textfield.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:am_user/widgets/utils/loading_indicator.dart';
import 'package:am_user/widgets/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  String whoIs;
   LoginScreen({super.key,required this.whoIs});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Auth auth = Auth();
  UserMethod userMethod = UserMethod();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

 bool _obscurePassword = false;
 bool _isLogin = false;




  void _loginWithEmailAndPassword() async {
    // Show the loader inside a dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ShowLoadingIndicator(message: "Please wait..."),
    );

    // Call Firebase Auth
    final result = await auth.loginWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Close the loader
    Navigator.of(context, rootNavigator: true).pop();

    // Show the result
    if (result == null) {
      context.push("${RoutsName.bottomNavigation}/0");
      Utils.showAppSnackBar(context, "Login Successful", backgroundColor: Colors.green);
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
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
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
                      Text(" Login ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 21),),
                    ],
                  ),
                  SizedBox(height: 20,),

                  ClipRRect(
                    child: Image.asset(logo,height: 150,fit: BoxFit.cover,),
                  ),

                  Text("Ready to Connect",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),

                  SizedBox(height: 20,),
                  CustomTextField(
                    label: 'Email ',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password is required';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),




                  CustomButton(backgroundColor: backgroundColor,
                    label: "Login",
                    onPressed: _loginWithEmailAndPassword,
                  ),
                  SizedBox(height: 10,),



                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed:_doNotHaveAccount ,
                      child: Text("I have,t Account? Register",style: TextStyle(color: Colors.white),))
                    ],
                  )


                ],
              ),

            ),
          ),
        ),
      ),

    );
  }

  _doNotHaveAccount() {
      final whoIs = widget.whoIs;
      if(whoIs == userLogin){
        context.push(RoutsName.registrationScreen);
      }else if(whoIs == driverLogin){
        context.push(RoutsName.driverRegisterScreen);
      }else if(whoIs == shopLogin){
        context.push(RoutsName.shopRegisterScreen);
      }else{
        context.push(RoutsName.workRegisterScreen);
      }
    }



}


