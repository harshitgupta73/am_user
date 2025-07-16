import 'dart:io';

import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:am_user/modals/driver_modal.dart';
import 'package:am_user/widgets/component/image_picker_buttom.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/controllers.dart';
import '../controller/image_picker_controller.dart';
import '../data/firebase/driver_methods/driver_insert_update.dart';
import '../widgets/component/custom_buttom.dart';
import '../widgets/component/custom_dropdwon.dart';
import '../widgets/component/custom_image_container.dart';
import '../widgets/component/custome_textfield.dart';
import '../widgets/constants/const.dart';
import '../widgets/routs/routs.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final genderList = ['Male','Female','Other'];

  TextEditingController driverName  = TextEditingController();
  TextEditingController driverContact  = TextEditingController();
  TextEditingController driverLicenceNo  = TextEditingController();
  TextEditingController vehicleNo  = TextEditingController();
  TextEditingController vehicleOwnerName  = TextEditingController();
  TextEditingController driverAddress  = TextEditingController();
  TextEditingController driverOtherSkill  = TextEditingController();

  final ImagePickerController imagePickerController = Get.put(ImagePickerController());
  final DriverMethods driverMethods = DriverMethods();

  final StorageServices storageServices = StorageServices();

  final controller = Get.put(Controller());

  String? vehicleRcImage;
  String? driverImage;
  String? drivingLicence;
  String? gender ;
  String? stateValue;
  String? distValue;
  String? jobWorkCategory;
  String? jobWork;

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
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
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
                        Text("Driver Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 21),),
                      ],
                    ),
                    GestureDetector(
                        onTap: () async{
                          await imagePickerController.getImage();
                          setState(() {
                            driverImage= imagePickerController.imagePath.value;
                          });
                        },
                        child:
                        Obx((){
                          return imagePickerController.imagePath.value.isNotEmpty
                              ? Image.file(
                            File(driverImage!),
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
                    SizedBox(height: 20,),
                    CustomTextField(
                      controller: driverName,
                      label: 'Driver Name',
                    ),

                    SizedBox(height: 10,),
                    CustomTextField(
                      controller: driverContact,
                      label: 'Contact No',
                      inputType: TextInputType.number,
                    ),
                    SizedBox(height: 10,),
                    CustomTextField(
                      controller: driverLicenceNo,
                      label: 'Driving Licence',
                      inputType: TextInputType.number,
                    ),
                    SizedBox(height: 10,),
                    ImagePickerButton(label: "Upload ",
                      notation: "Driving Licence Image",
                      backgroundColor: backgroundColor,
                      onPressed: () async {
                        await imagePickerController.getImage();
                        setState(() {
                          drivingLicence = imagePickerController.imagePath.value;
                        });
                      },),
                    SizedBox(height: 10,),
                    CustomTextField(
                      controller: vehicleNo,
                      label: 'Vehicle No',
                      inputType: TextInputType.number,
                    ),
                    SizedBox(height: 10,),
                    CustomTextField(
                      controller: vehicleOwnerName,
                      label: 'Vehicle owner Name',
                      inputType: TextInputType.number,
                    ),
                    SizedBox(height: 10,),

                    ImagePickerButton(label: "Upload ",
                      notation: "Upload RC Image",
                      backgroundColor: backgroundColor,
                      onPressed: () async {
                        await imagePickerController.getImage();
                        setState(() {
                          vehicleRcImage = imagePickerController.imagePath.value;
                        });
                      },),
                    SizedBox(height: 10,),
                    // SizedBox(height: 10,),
                    CustomTextField(
                      controller: driverAddress,
                      label: 'Address',
                    ),
                    SizedBox(height: 10,),
                    CustomDropdown(
                      items:stateDistrictMap.keys.toList(),
                      value: stateValue,
                      hint: " - -Select State - -",
                      onChanged: (value) {
                        stateValue = value.toString();
                        distValue = null; // Reset district when state changes
                        setState(() {

                        });
                      },),


                    SizedBox(height: 10,),

                    CustomDropdown(
                      hint: " - - Select District - - ",
                      value: distValue,
                      items: stateValue!=null? stateDistrictMap[stateValue]!.toList():[],

                      onChanged: (dist) {
                        distValue = dist;
                        setState(() {

                        });
                      },),

                    SizedBox(height: 10,),

                    CustomTextField(
                      controller: driverOtherSkill,
                      label: 'Other Skills (,)',
                    ),
                    SizedBox(height: 10,),
                    CustomButton(backgroundColor: backgroundColor,label: "Register", onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        controller.startLoading();

                        if (driverImage == null || drivingLicence == null || vehicleRcImage == null) {
                          Get.snackbar("Missing Image", "Please upload all required images",
                              backgroundColor: Colors.red);
                          return;
                        }

                        try {
                          File driverImgFile = File(driverImage!);
                          File licenceImgFile = File(drivingLicence!);
                          File rcImgFile = File(vehicleRcImage!);

                          String uploadedDriverImage = await storageServices.uploadImage(driverImgFile);
                          String uploadedDrivingLicence = await storageServices.uploadImage(licenceImgFile);
                          String uploadedVehicleRcImage = await storageServices.uploadImage(rcImgFile);

                          DriverModal driver = DriverModal(
                            driverName: driverName.text.trim(),
                            driverContact: driverContact.text.trim(),
                            driverLicenceNo: driverLicenceNo.text.trim(),
                            vehicleNo: vehicleNo.text.trim(),
                            vehicleOwnerName: vehicleOwnerName.text.trim(),
                            driverAddress: driverAddress.text.trim(),
                            driverOtherSkill: driverOtherSkill.text.trim(),
                            driverImage: uploadedDriverImage,
                            drivingLicence: uploadedDrivingLicence,
                            vehicleRcImage: uploadedVehicleRcImage,
                            gender: gender ?? "",
                            stateValue: stateValue ?? "",
                            distValue: distValue ?? "",
                            jobWorkCategory: jobWorkCategory ?? "",
                            jobWork: jobWork ?? "",
                          );

                          await driverMethods.insertDriver(driver);
                          controller.stopLoading();
                          Navigator.pop(context);
                          await controller.getAllUsers();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Driver added successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          Get.snackbar("Error", "Failed to upload images or save data", backgroundColor: Colors.red,colorText: Colors.white);
                        }
                      } else {
                        Get.snackbar("Invalid Form", "Please fill all fields", backgroundColor: Colors.red,colorText: Colors.white);
                      }
                      imagePickerController.imagePath.value = "";
                    },),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {

                              context.go("${RoutsName.loginScreen}/$driverLogin");
                              },
                            child: Text("Already have Account? Login",style: TextStyle(color: Colors.white),))
                      ],
                    )

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
