import 'dart:io';
import 'dart:typed_data';
import 'package:am_user/controller/image_picker_controller.dart';
import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:am_user/data/firebase/worker_methods/worker_method.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/controllers.dart';
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
  final genderList = ['Male', 'Female', 'Other'];
  final WorkerMethod workerMethod = WorkerMethod();

  final ImagePickerController imagePickerController = Get.put(
    ImagePickerController(),
  );

  final controller = Get.put(Controller());

  final StorageServices storageServices = StorageServices();

  final TextEditingController workerName = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController workerContact = TextEditingController();
  final TextEditingController otherSkills = TextEditingController();
  Uint8List? workerImage;
  String? selectedGender;

  String? stateValue;
  String? distValue;
  String? jobWorkCategory;
  String? jobWork;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    workerName.dispose();
    address.dispose();
    workerContact.dispose();
    otherSkills.dispose();
  }

  final _formKey = GlobalKey<FormState>();

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
                          "Worker Register",
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
                      child: Obx(() {
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
                      }),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(controller: workerName, label: 'Name'),

                    SizedBox(height: 10),
                    CustomTextField(
                      controller: workerContact,
                      label: 'Contact No',
                      inputType: TextInputType.number,
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

                    CustomDropdown(
                      items: jobCategories.keys.toList(),
                      value: jobWorkCategory,
                      hint: '- - Select Work Categories - - ',
                      onChanged: (work) {
                        jobWorkCategory = work;
                        jobWork = null;
                        setState(() {});
                      },
                    ),

                    SizedBox(height: 10),

                    jobWorkCategory == 'Other'
                        ? CustomTextField(label: "Other")
                        : CustomDropdown(
                          value: jobWork,
                          hint: ' - - Select Work - -',
                          items:
                              jobWorkCategory != null
                                  ? jobCategories[jobWorkCategory]!.toList()
                                  : [],
                          onChanged: (value) {
                            jobWork = value;
                            setState(() {});
                          },
                        ),
                    SizedBox(height: 10),

                    CustomTextField(controller: address, label: 'Address'),
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
                      controller: otherSkills,
                      label: 'Other Skills (,)',
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : CustomButton(
                            backgroundColor: backgroundColor,
                            label: "Register",
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  imagePickerController
                                      .imagePath
                                      .value
                                      .isNotEmpty) {
                                controller.startLoading();
                                File file = File(
                                  imagePickerController.imagePath.value,
                                );
                                String url = await storageServices.uploadImage(
                                  file,
                                );
                                WorkerModal worker = WorkerModal(
                                  workerName: workerName.text.toString(),
                                  workerContat: workerContact.text.toString(),
                                  address: address.text.toString(),
                                  otherSkills: otherSkills.text.toString(),
                                  selectedGender: selectedGender.toString(),
                                  stateValue: stateValue.toString(),
                                  distValue: distValue.toString(),
                                  jobWorkCategory: jobWorkCategory.toString(),
                                  jobWork: jobWork.toString(),
                                  workerImage: url,
                                );
                                await workerMethod.createWorker(worker);
                                controller.stopLoading();
                                await controller.getAllUsers();
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Worker added successfully'),
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
                              () => context.go(
                                "${RoutsName.loginScreen}/$workerLogin",
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
