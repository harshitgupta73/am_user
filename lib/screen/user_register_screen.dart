import 'dart:convert';
import 'dart:typed_data';

import 'package:am_user/data/firebase/auth/registration.dart';
import 'package:am_user/data/firebase/user/user_insert_update.dart';
import 'package:am_user/modals/userModal.dart';
import 'package:am_user/widgets/common_methods.dart';
import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:am_user/widgets/utils/loading_indicator.dart';
import 'package:am_user/widgets/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/shareprefrance/shareprefrance.dart';
import '../widgets/routs/routs.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharePreferencesMethods _sharePreferencesMethods = SharePreferencesMethods();


  Auth auth = Auth();
  UserMethod userMethod = UserMethod();
  bool _obscurePassword = true;
  Uint8List userImage = Uint8List(0) ;

  Future<void> _submitForm() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>const ShowLoadingIndicator(),);

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final contact = _contactController.text.trim();
      final password = _passwordController.text;
      final name = _nameController.text;


     var result =await auth.registerWithEmailAndPassword(email: email, password: password);
     String uid = firebaseAuth.currentUser!.uid.toString();

     UserModal userModal = UserModal(
       email:   email,
        contact:  contact,
        name:  name,
        image:  null,
      userId:   uid,
     );

      if(result == null){
        final res = await userMethod.insertUser(userModal, uid);
       result = res;
      }

     Navigator.of(context,rootNavigator: true).pop();

     if(result == null){
       await _sharePreferencesMethods.saveUserToSharedPref(userModal);
       context.pushReplacement("${RoutsName.bottomNavigation}/0");
     Utils.showAppSnackBar(context, "Account Created Successfully",backgroundColor: Colors.green);
     }else{
      Utils.showAppSnackBar(context, result,backgroundColor: Colors.red);
     }
      print("Email: $email\nContact: $contact\nPassword: $password");
    }else{
      Navigator.of(context,rootNavigator: true).pop();

    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: width > 600 ? 400 : double.infinity),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 150,
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(image: AssetImage(logo))

                    ),

                  ),
                  Text(tagLine),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
              
                  // Contact
                  TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Contact number is required';
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Enter 10-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
              
                  // Password
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
                  const SizedBox(height: 24),
              
                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(label: "Register", onPressed: _submitForm)
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:  () {
                          context.push("${RoutsName.loginScreen}/$userLogin");
                        },
                        child: RichText(
                          text: TextSpan(
                          children: [
                            TextSpan(text: "I have't Account?",style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "Login",style: TextStyle(color: Colors.blue))
                          ]
                        ),),
                      ),
                      SizedBox(width: 10,)
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
}
