import 'dart:io';
import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:am_user/modals/driver_modal.dart';
import 'package:am_user/widgets/component/image_picker_buttom.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire3/geoflutterfire3.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import '../controller/controllers.dart';
import '../controller/image_picker_controller.dart';
import '../controller/user_provider/get_user_provider.dart';
import '../data/firebase/driver_methods/driver_insert_update.dart';
import '../data/shareprefrance/shareprefrance.dart';
import '../widgets/common_methods.dart';
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

  TextEditingController driverName = TextEditingController();
  TextEditingController driverContact = TextEditingController();
  TextEditingController driverLicenceNo = TextEditingController();
  TextEditingController vehicleNo = TextEditingController();
  TextEditingController vehicleOwnerName = TextEditingController();
  TextEditingController driverAddress = TextEditingController();
  TextEditingController driverOtherSkill = TextEditingController();
  TextEditingController vehicleName = TextEditingController();

  final ImagePickerController imagePickerController = Get.put(ImagePickerController());

  final userController = Get.find<GetUserController>();

  final DriverMethods driverMethods = DriverMethods();

  final StorageServices storageServices = StorageServices();

  final controller = Get.find<Controller>();
  bool isEditing = false;

  String? vehicleRcImage;
  String? driverImage;
  String? drivingLicence;
  String? stateValue;
  String? distValue;
  String? jobWorkCategory;
  String? jobWork;

  final _formKey = GlobalKey<FormState>();

  late GeoFirePoint _location;

  Future<void> getLocation() async {
    Location location = Location();

    // Request permission
    PermissionStatus permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return null;

    // Get current location
    LocationData locData = await location.getLocation();
    double latitude = locData.latitude!;
    double longitude = locData.longitude!;

    // Create GeoFirePoint
    GeoFirePoint myLocation = GeoFlutterFire().point(
      latitude: latitude,
      longitude: longitude,
    );
    _location = myLocation;
  }

  final sharedPreferencesMethods = SharePreferencesMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    final driver= userController.driverModal.value;
    if(driver != null){
        isEditing= true;
      driverImage = driver.driverImage;
      driverName.text = driver.driverName!;
      driverContact.text = driver.driverContact!;
      driverLicenceNo.text = driver.driverLicenceNo!;
      drivingLicence = driver.drivingLicence!;

      vehicleNo.text = driver.vehicleNo!;
      vehicleName.text = driver.vehicleName!;
      vehicleOwnerName.text = driver.vehicleOwnerName!;
      vehicleRcImage = driver.vehicleRcImage!;

      driverAddress.text = driver.driverAddress!;
      driverOtherSkill.text = driver.driverOtherSkill!;
      stateValue = driver.stateValue!;
      distValue = driver.distValue!;
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
                color: backgroundColor,
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
                          "Driver Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        await imagePickerController.getImage();
                        setState(() {
                          driverImage = imagePickerController.imagePath.value;
                        });
                      },
                      child: Obx(() {
                        final pickedImage = imagePickerController.imagePath.value;

                        if (pickedImage.isNotEmpty && File(pickedImage).existsSync()) {
                          // Show selected local image
                          return Image.file(
                            File(pickedImage),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        } else if (driverImage != null && driverImage!.startsWith("http")) {
                          // Show existing Firebase image
                          return Image.network(
                            driverImage!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                          );
                        } else {
                          // Show placeholder
                          return CustomImageContainer(
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
                          );}})
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: driverName,
                      label: 'Driver Name',
                      cursorColor: Colors.black,
                      color: customTextColor,
                    ),

                    SizedBox(height: 10),
                    CustomTextField(
                      controller: driverContact,
                      label: 'Contact No',
                      inputType: TextInputType.number,
                      cursorColor: Colors.black,
                      color: customTextColor,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: driverLicenceNo,
                      label: 'Driving Licence',
                      inputType: TextInputType.number,
                      cursorColor: Colors.black,
                      color: customTextColor,
                    ),
                    SizedBox(height: 10),
                    ImagePickerButton(
                      label: "Upload ",
                      notation: "Driving Licence Image",
                      backgroundColor: backgroundColor,
                      onPressed: () async {
                        await imagePickerController.getLicenceImage();
                        setState(() {
                          drivingLicence =
                              imagePickerController.licenceImage.value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: vehicleNo,
                      label: 'Vehicle No',
                      inputType: TextInputType.text,
                      cursorColor: Colors.black,
                      color: customTextColor,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: vehicleName,
                      label: 'Vehicle Name',
                      inputType: TextInputType.text,
                      cursorColor: Colors.black,
                      color: customTextColor,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: vehicleOwnerName,
                      label: 'Vehicle owner Name',
                      inputType: TextInputType.text,
                      cursorColor: Colors.black,
                      color: customTextColor,
                    ),
                    SizedBox(height: 10),

                    ImagePickerButton(
                      label: "Upload ",
                      notation: "Upload RC Image",
                      backgroundColor: backgroundColor,
                      onPressed: () async {
                        await imagePickerController.getRCImage();
                        setState(() {
                          vehicleRcImage =
                              imagePickerController.rcImage.value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    // SizedBox(height: 10,),
                    CustomTextField(
                      controller: driverAddress,
                      label: 'Address',
                      cursorColor: Colors.black,
                      color: customTextColor,
                    ),
                    SizedBox(height: 10),
                    CustomDropdown(
                      items: stateDistrictMap.keys.toList(),
                      value: stateValue,
                      hint: " - -Select State - -",
                      onChanged: (value) {
                        stateValue = value.toString();
                        distValue = null; // Reset district when state changes
                        setState(() {});
                      },
                    ),

                    SizedBox(height: 10),

                    CustomDropdown(
                      hint: " - - Select District - - ",
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

                    CustomTextField(
                      controller: driverOtherSkill,
                      label: 'Other Skills',
                      cursorColor: Colors.black,
                      color: customTextColor,
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.black)
                          : CustomButton(
                            textColor: Colors.black,
                            backgroundColor: backgroundColor,
                            label:isEditing ? "Update" : "Register",
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                controller.startLoading();

                                if (driverImage == null ||
                                    drivingLicence == null ||
                                    vehicleRcImage == null) {
                                  Get.snackbar(
                                    "Missing Image",
                                    "Please upload all required images",
                                    backgroundColor: Colors.red,
                                  );
                                  return;
                                }

                                try {
                                  File driverImgFile = File(driverImage!);
                                  File licenceImgFile = File(drivingLicence!);
                                  File rcImgFile = File(vehicleRcImage!);

                                  String uploadedDriverImage =
                                      await storageServices.uploadImage(
                                        driverImgFile,
                                      );
                                  String uploadedDrivingLicence =
                                      await storageServices.uploadImage(
                                        licenceImgFile,
                                      );
                                  String uploadedVehicleRcImage =
                                      await storageServices.uploadImage(
                                        rcImgFile,
                                      );
                                  String randomId = userController.myUser!.userId!;

                                  DriverModal driver = DriverModal(
                                    driverId: randomId,
                                    driverName: driverName.text.trim(),
                                    driverContact: driverContact.text.trim(),
                                    driverLicenceNo:
                                        driverLicenceNo.text.trim(),
                                    vehicleNo: vehicleNo.text.trim(),
                                    vehicleName: vehicleName.text.trim(),
                                    vehicleOwnerName:
                                        vehicleOwnerName.text.trim(),
                                    driverAddress: driverAddress.text.trim(),
                                    driverOtherSkill:
                                        driverOtherSkill.text.trim(),
                                    driverImage: uploadedDriverImage,
                                    drivingLicence: uploadedDrivingLicence,
                                    vehicleRcImage: uploadedVehicleRcImage,
                                    stateValue: stateValue ?? "",
                                    distValue: distValue ?? "",
                                    position: _location.data,
                                    lastUpdated: Timestamp.now(),
                                  );


                                  // print(randomId);
                                  if (isEditing) {
                                    await driverMethods.updateDriver(driver, randomId);
                                    await userController.loadUserFromFirestore();
                                  } else {
                                    await driverMethods.insertDriver(driver, randomId);
                                    await sharedPreferencesMethods.clearUserData();
                                    await sharedPreferencesMethods.saveUserTypeAndUid("drivers", randomId);
                                    await userController.loadUserFromFirestore();
                                  }

                                  controller.stopLoading();

                                  await controller.getAllUsers();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isEditing ? 'Driver updated successfully' : 'Driver added successfully for one year',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  if (!isEditing) {
                                    imagePickerController.imagePath.value = '';
                                    context.pop();
                                  } else {
                                    customNavigate(context, RoutsName.typeDashboard);
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    "Failed to upload images or save data",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  "Invalid Form",
                                  "Please fill all fields",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                              imagePickerController.imagePath.value = "";
                            },
                          );
                    }),
                    SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         context.go("${RoutsName.loginScreen}/$driverLogin");
                    //       },
                    //       child: Text(
                    //         "Already have Account? Login",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
