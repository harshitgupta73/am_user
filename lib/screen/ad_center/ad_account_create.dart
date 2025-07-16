import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/component/custom_dropdwon.dart';
import 'package:am_user/widgets/component/custome_textfield.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/component/custom_image_container.dart';

class AdRegisterScreen extends StatefulWidget {
  const AdRegisterScreen({super.key});

  @override
  State<AdRegisterScreen> createState() => _AdRegisterScreenState();
}

class _AdRegisterScreenState extends State<AdRegisterScreen> {
  final genderList = ['Male', 'Female', 'Other'];
  String? selectedGender;
  String? stateValue;
  String? distValue;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isVerySmallScreen = screenSize.width < 400;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: isSmallScreen ? 16 : 32,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500,
                minHeight: screenSize.height * 0.8,
              ),
              child: Card(
                shadowColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "AD Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isVerySmallScreen ? 20 : 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // Centered Image Container
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 400,
                              maxHeight: screenSize.height * 0.25,
                            ),
                            child: AspectRatio(
                              aspectRatio: 16/9,
                              child: Center(
                                child: CustomImageContainer(
                                  overlay: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // Form Fields
                        _buildFormFields(isSmallScreen, isVerySmallScreen),
                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // Register Button
                        CustomButton(
                          backgroundColor: backgroundColor,
                          label: "Register",
                          onPressed: _submitForm,
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),

                        // Login Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.go(RoutsName.adLoginScreen),
                            child: Text(
                              "Already have an account? Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isVerySmallScreen ? 12 : 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(bool isSmallScreen, bool isVerySmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: 'Shop Name / Business Name',
          fontSize: isVerySmallScreen ? 14 : null,
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),

        CustomTextField(
          label: 'Contact No',
          inputType: TextInputType.phone,
          fontSize: isVerySmallScreen ? 14 : null,
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        CustomDropdown(
          items: genderList,
          value: selectedGender,
          hint: "Select Gender",
          fontSize: isVerySmallScreen ? 14 : null,
          onChanged: (value) {
            selectedGender = value;
            setState(() {});
          },
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        CustomDropdown(
          items: stateDistrictMap.keys.toList(),
          value: stateValue,
          hint: "Select State",
          fontSize: isVerySmallScreen ? 14 : null,
          onChanged: (value) {
            stateValue = value.toString();
            distValue = null;
            setState(() {});
          },
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        CustomDropdown(
          hint: "Select District",
          value: distValue,
          items: stateValue != null
              ? stateDistrictMap[stateValue]!.toList()
              : [],
          fontSize: isVerySmallScreen ? 14 : null,
          onChanged: (dist) {
            distValue = dist;
            setState(() {});
          },
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        CustomTextField(
          label: 'Address',
          fontSize: isVerySmallScreen ? 14 : null,
        ),

      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with
      //
      //
      // auth
    }
  }
}