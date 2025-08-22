import 'dart:io';
import 'dart:typed_data';
import 'package:am_user/business_categories/business_type.dart';
import 'package:am_user/controller/image_picker_controller.dart';
import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:am_user/data/firebase/worker_methods/worker_method.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:am_user/widgets/common_methods.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire3/geoflutterfire3.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../controller/controllers.dart';
import '../controller/user_provider/get_user_provider.dart';
import '../data/shareprefrance/shareprefrance.dart';
import '../widgets/component/custom_buttom.dart';
import '../widgets/component/custom_dropdwon.dart';
import '../widgets/component/custom_image_container.dart';
import '../widgets/component/custome_textfield.dart';
import '../widgets/constants/const.dart';
import '../widgets/routs/routs.dart';

class WorkerRegister extends StatefulWidget {
  const WorkerRegister({super.key});

  @override
  State<WorkerRegister> createState() => _WorkerRegisterState();
}

class _WorkerRegisterState extends State<WorkerRegister> {
  final ImagePickerController imagePickerController =
      Get.find<ImagePickerController>();
  final controller = Get.find<Controller>();
  final userController = Get.find<GetUserController>();
  final sharedPreferencesMethods = SharePreferencesMethods();
  final StorageServices storageServices = StorageServices();
  final WorkerMethod workerMethod = WorkerMethod();

  final genderList = ['Male', 'Female', 'Other'];

  String? workerImage;
  final TextEditingController workerName = TextEditingController();
  final TextEditingController workerContact = TextEditingController();
  String? selectedGender;
  List<String> workerType = [];
  final TextEditingController otherType = TextEditingController();
  String? stateValue;
  String? distValue;
  final TextEditingController address = TextEditingController();
  final TextEditingController otherSkills = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    workerName.dispose();
    address.dispose();
    workerContact.dispose();
    otherSkills.dispose();
    otherType.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  late GeoFirePoint _location;
  bool isEditing = false;

  Future<void> getLocation() async {
    Location location = Location();

    // Request permission
    PermissionStatus permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return ;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    final worker = userController.workerModal.value;
    if (worker != null) {
      isEditing = true;
      workerImage = worker.workerImage;
      workerName.text = worker.workerName ?? '';
      workerContact.text = worker.workerContat ?? '';
      selectedGender = worker.selectedGender;
      address.text = worker.address ?? '';
      otherSkills.text = worker.otherSkills ?? '';
      stateValue = worker.stateValue;
      distValue = worker.distValue;
      workerType = worker.workType ?? [];
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
                          "Worker Register",
                          style: TextStyle(
                            color: customTextColor,
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
                      child: Obx(() {
                        final pickedImage =
                            imagePickerController.imagePath.value;
                        if (pickedImage.isNotEmpty) {
                          return Image.file(
                            File(pickedImage),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        } else if (workerImage != null) {
                          return Image(
                            image: NetworkImage(workerImage!),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        } else {
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
                          );
                        }
                      }),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      cursorColor: customTextColor,
                      controller: workerName,
                      label: 'Name',
                      color: Colors.black,
                    ),

                    SizedBox(height: 10),
                    CustomTextField(
                      controller: workerContact,
                      label: 'Contact No',
                      inputType: TextInputType.number,
                      cursorColor: customTextColor,
                      color: Colors.black,
                    ),

                    SizedBox(height: 10),
                    CustomDropdown(
                      items: genderList,
                      value: selectedGender,
                      hint: "- - Select Gender - -",
                      onChanged: (value) {
                        selectedGender = value;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),

                    Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(color: Colors.black),
                      ),
                      child: MultiSelectDialogField(
                        items:
                            Provider().worker_type
                                .map((e) => MultiSelectItem<String>(e, e))
                                .toList(),
                        title: Text("Worker Types"),
                        buttonText: Text(
                          "Select worker Types",
                          style: TextStyle(color: customTextColor),
                        ),
                        searchable: true,
                        backgroundColor: Colors.white,
                        unselectedColor: Colors.black,
                        chipDisplay: MultiSelectChipDisplay(
                          chipColor: Colors.white,
                          textStyle: TextStyle(color: Colors.black),
                        ),
                        selectedItemsTextStyle: TextStyle(color: Colors.black),
                        initialValue: workerType,
                        onConfirm: (values) {
                          setState(() {
                            workerType = values.cast<String>();
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    workerType.contains("Others")
                        ? CustomTextField(
                          controller: otherType,
                          label: 'Other Type',
                          inputType: TextInputType.text,
                        )
                        : Container(),

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
                      cursorColor: Colors.black,
                      color: customTextColor,
                      controller: address,
                      label: 'Address',
                    ),

                    SizedBox(height: 10),
                    CustomTextField(
                      cursorColor: Colors.black,
                      color: customTextColor,
                      controller: otherSkills,
                      label: 'Other Skills',
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.black)
                          : CustomButton(
                            textColor: Colors.black,
                            backgroundColor: backgroundColor,
                            label: isEditing ? "Update" : "Register",
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                controller.startLoading();

                                try {
                                  String imagePath =
                                      imagePickerController.imagePath.value;
                                  String uploadedImageUrl = imagePath;

                                  if (!imagePath.startsWith("http")) {
                                    if (imagePath.isEmpty && !isEditing) {
                                      Get.snackbar(
                                        "Missing Image",
                                        "Please upload a worker image",
                                        backgroundColor: Colors.red,
                                      );
                                      controller.stopLoading();
                                      return;
                                    } else if (imagePath.isNotEmpty) {
                                      uploadedImageUrl = await storageServices.uploadImage(File(imagePath));
                                    } else if (isEditing && workerImage != null) {
                                      uploadedImageUrl = workerImage!;
                                    }
                                  }

                                  // Replace "Others" if user has entered a custom skill
                                  if (workerType.contains("Others") &&
                                      otherType.text.trim().isNotEmpty) {
                                    workerType.remove("Others");
                                    workerType.add(otherType.text.trim());
                                  }

                                  String workerId =
                                      userController.myUser!.userId!;
                                  WorkerModal worker = WorkerModal(
                                    workerId: workerId,
                                    workerName: workerName.text.trim(),
                                    workerContat: workerContact.text.trim(),
                                    address: address.text.trim(),
                                    otherSkills: otherSkills.text.trim(),
                                    selectedGender: selectedGender,
                                    stateValue: stateValue ?? '',
                                    distValue: distValue ?? '',
                                    workType: workerType,
                                    workerImage: uploadedImageUrl,
                                    position: _location.data,
                                    lastUpdated: Timestamp.now(),
                                  );

                                  if (isEditing) {
                                    await workerMethod.updateWorker(
                                      worker,
                                      workerId,
                                    );
                                    await userController.loadUserFromFirestore();
                                  } else {
                                    await workerMethod.createWorker(
                                      worker,
                                      workerId,
                                    );
                                      await sharedPreferencesMethods
                                          .clearUserData();
                                      await sharedPreferencesMethods
                                          .saveUserTypeAndUid(
                                        "Workers",
                                        workerId,
                                      );
                                    await userController.loadUserFromFirestore();
                                    await controller.getAllUsers();

                                  }

                                  controller.stopLoading();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isEditing
                                            ? 'Worker updated successfully'
                                            : 'Worker added successfully for one year!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  if (!isEditing) {
                                    imagePickerController.imagePath.value = '';
                                    Navigator.pop(context);
                                  } else {
                                    customNavigate(context, RoutsName.typeDashboard);
                                  }
                                } catch (e) {
                                  controller.stopLoading();
                                  Get.snackbar(
                                    "Error",
                                    "Something went wrong while saving worker",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              }
                            },
                          );
                    }),
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
}

// : CustomButton(
//   backgroundColor: backgroundColor,
//   label:isEditing ? "Upload" : "Register",
//   onPressed: () async {
//     if (_formKey.currentState!.validate() ) {
//       controller.startLoading();
//       File file = File(
//         imagePickerController.imagePath.value,
//       );
//       String url = await storageServices.uploadImage(
//         file,
//       );
//
//       if (workerType.contains("Others") && otherType.text.trim().isNotEmpty) {
//         workerType.remove("Others");
//         workerType.add(otherType.text.trim());
//       }
//
//       String randomId = userController.myUser!.userId!;
//       WorkerModal worker = WorkerModal(
//         workerId: randomId,
//         workerName: workerName.text.toString(),
//         workerContat: workerContact.text.toString(),
//         address: address.text.toString(),
//         otherSkills: otherSkills.text.toString(),
//         selectedGender: selectedGender.toString(),
//         stateValue: stateValue.toString(),
//         distValue: distValue.toString(),
//         workType: workerType,
//         workerImage: url,
//         position: _location.data,
//         lastUpdated: Timestamp.now(),
//       );
//       if(randomId.isNotEmpty){
//         await workerMethod.createWorker(worker,randomId);
//       }
//       await sharedPreferencesMethods.clearUserData();
//       await sharedPreferencesMethods.saveUserTypeAndUid("Workers", randomId);
//       controller.stopLoading();
//       await controller.getAllUsers();
//       Navigator.pop(context);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Worker added successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//       imagePickerController.imagePath.value = '';
//     }
//   },
// );
