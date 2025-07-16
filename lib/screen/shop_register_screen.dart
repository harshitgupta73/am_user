import 'dart:io';

import 'package:am_user/data/firebase/shop_method/shope_methods.dart';
import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:am_user/modals/shopModal.dart';
import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/component/custom_dropdwon.dart';
import 'package:am_user/widgets/component/custome_textfield.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/controllers.dart';
import '../controller/image_picker_controller.dart';
import '../widgets/component/custom_image_container.dart';

class ShopRegisterScreen extends StatefulWidget {
  const ShopRegisterScreen({super.key});

  @override
  State<ShopRegisterScreen> createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  final genderList = ['Male', 'Female', 'Other'];

  final ShopMethods shopMethods = ShopMethods();

  final Controller controller = Get.put(Controller());

  final imagePickerController = Get.put(ImagePickerController());
  final StorageServices storageServices = StorageServices();

  final TextEditingController shopName = TextEditingController();
  final TextEditingController propritorName = TextEditingController();
  final TextEditingController contactNo = TextEditingController();
  final TextEditingController shopAddress = TextEditingController();
  final TextEditingController shopItem = TextEditingController();

  String? shopImage;
  String? selectedGender;

  String? stateValue;
  String? distValue;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    shopName.dispose();
    propritorName.dispose();
    contactNo.dispose();
    shopAddress.dispose();
    shopItem.dispose();
  }

  final _formKey= GlobalKey<FormState>();


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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Row(
                      children: [
                        Text(
                          "Shop Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          imagePickerController.getImage();
                        },
                        child:
                        Obx(() {
                          return imagePickerController.imagePath.value.isNotEmpty
                              ? Image.file(
                            File(imagePickerController.imagePath.value),
                          )
                              : CustomImageContainer(
                            overlay: Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          );
                        })
                    ),
                    SizedBox(height: 20),
                    CustomTextField(controller:shopName,label: 'Business & Shop Name'),
                    SizedBox(height: 10),
                    CustomTextField(controller:propritorName,label: 'Proprietor Name'),
                    SizedBox(height: 10),

                    CustomTextField(
                      controller: contactNo,
                      label: 'Contact No',
                      inputType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    CustomDropdown(
                      items: genderList,
                      value: selectedGender,
                      hint: "Select Gender",
                      onChanged: (value) {
                        selectedGender = value;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextField(controller : shopAddress,label: 'Address'),

                    SizedBox(height: 10),

                    CustomDropdown(
                      items: stateDistrictMap.keys.toList(),
                      value: stateValue,
                      hint: "Select State",
                      onChanged: (value) {
                        stateValue = value.toString();
                        distValue = null; // Reset district when state changes
                        setState(() {});
                      },
                    ),

                    SizedBox(height: 10),

                    CustomDropdown(
                      hint: " - - Select District - -",
                      value: distValue,
                      items:
                      stateValue != null
                          ? stateDistrictMap[stateValue]!.toList()
                          : [],

                      onChanged: (dist) {
                        distValue = dist;
                        setState(() {});
                      },
                    ),

                    SizedBox(height: 10),

                    CustomTextField(controller: shopItem, label: 'Items Name (,)'),
                    SizedBox(height: 10),

                    Obx((){
                      return controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : CustomButton(
                        backgroundColor: backgroundColor,
                        label: "Register",
                        onPressed: () async {

                          if(_formKey.currentState!.validate() && imagePickerController.imagePath.value.isNotEmpty){

                            controller.startLoading();
                            File file = File(imagePickerController.imagePath.value);
                            String url = await storageServices.uploadImage(file);

                            ShopModal shopModel = ShopModal(
                              shopName: shopName.text.toString(),
                              proprietorName: propritorName.text.toString(),
                              contactNo: contactNo.text.toString(),
                              shopAddress: shopAddress.text.toString(),
                              shopItem: shopItem.text.toString(),
                              shopImage: url,
                              selectedGender: selectedGender.toString(),
                              stateValue: stateValue.toString(),
                              distValue: distValue.toString(),
                            );

                            await shopMethods.insertShop(shopModel);

                            Navigator.pop(context);
                            controller.stopLoading();
                            await controller.getAllUsers();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Shop added successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );



                            imagePickerController.imagePath.value = '';
                          }

                        },
                      );
                    }),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap:
                              () =>
                              context.go(
                                "${RoutsName.loginScreen}/$shopLogin",
                              ),
                          child: Text(
                            "Already have Account? Login",
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
      ),
    );
  }
}
