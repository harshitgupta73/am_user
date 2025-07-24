import 'dart:io';

import 'package:am_user/controller/ad_controller/ad_controller.dart';
import 'package:am_user/data/firebase/ad_services/ad_services.dart';
import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:am_user/modals/add_modal.dart';
import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/component/custom_dropdwon.dart';
import 'package:am_user/widgets/component/custome_textfield.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/constants/firebse_const/string_const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:video_compress/video_compress.dart';
import '../../controller/media_controllers/media_controller.dart';
import '../../widgets/component/custom_image_container.dart';

class AdRegisterScreen extends StatefulWidget {
  const AdRegisterScreen({super.key});

  @override
  State<AdRegisterScreen> createState() => _AdRegisterScreenState();
}

class _AdRegisterScreenState extends State<AdRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  final MediaController mediaController = Get.find();
  double? price;

  File? selectedFile;
  bool isVideo = false;
  MediaInfo? compressedVideo;
  List<int> noOfDays = [7, 15, 30];
  bool entireCountry = false;
  List<String> selectedStates = [];
  Map<String, List<String>> selectedDistricts = {};
  List<String> fullySelectedStates = [];
  TextEditingController businessName = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  int? NoOfDays;

  final AdController adController = Get.find();
  final AdServices adServices = AdServices();

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Promote your Business",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: isVerySmallScreen ? 20 : 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 24),

                        _buildFormFields(isSmallScreen, isVerySmallScreen),
                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // Register Button
                        Obx(
                          () =>
                              adController.isLoading.value
                                  ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                  : CustomButton(
                                    textColor: Colors.black,
                                    backgroundColor: backgroundColor,
                                    label: "Upload Ad",
                                    onPressed: _submitForm,
                                  ),
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
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
        SwitchListTile(
          title: Text(
            "Upload as Video",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          value: isVideo,
          onChanged: (val) => setState(() => isVideo = val),
          activeColor: Colors.blue,
          activeTrackColor: Colors.blue.shade100,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.zero,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: pickSingleFile,
          child: Text(
            "Pick ${isVideo ? 'Video' : 'Image'}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        if (selectedFile != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                  isVideo
                      ? videoThumbnail != null
                          ? Image.file(videoThumbnail!, height: 150)
                          : const Icon(
                            Icons.videocam,
                            color: Colors.black,
                            size: 100,
                          )
                      : Image.file(selectedFile!, height: 150),

          ),
        CustomTextField(
          color: Colors.black,
          label: 'Shop Name / Business Name',
          fontSize: isVerySmallScreen ? 14 : null,
          controller: businessName,
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),

        CustomTextField(
          color: Colors.black,
          label: 'Contact No',
          controller: contactNo,
          inputType: TextInputType.phone,
          fontSize: isVerySmallScreen ? 14 : null,
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Row(
          children: [
            Checkbox(
              value: entireCountry,
              checkColor: Colors.white, // Tick color
              fillColor: MaterialStateProperty.resolveWith<Color>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue; // Checkbox color when selected
                }
                return Colors.grey; // When unselected
              }),
              onChanged: (val) {
                setState(() {
                  entireCountry = val!;
                  selectedStates.clear();
                  selectedDistricts.clear();
                  fullySelectedStates.clear();
                });
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'Advertise across entire country',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        if (!entireCountry) ...[
          // Multi-select state picker
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ), // 👈 Changes the dropdown arrow color
            ),
            child: MultiSelectDialogField(
              unselectedColor: Colors.black,
              // chipDisplay: MultiSelectChipDisplay(
              //   chipColor: Colors.white,
              //   textStyle: TextStyle(color: Colors.black),
              // ),
              chipDisplay: MultiSelectChipDisplay.none(),
              selectedItemsTextStyle: TextStyle(color: Colors.black),
              items:
                  stateDistrictMap.keys
                      .map((e) => MultiSelectItem(e, e))
                      .toList(),
              title: Text(
                "Select States",
                style: TextStyle(color: Colors.black),
              ),
              buttonText: Text(
                "Select States",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              searchIcon: Icon(Icons.arrow_downward_sharp, color: Colors.black),
              onConfirm: (values) {
                selectedStates = values.cast<String>();
                selectedDistricts.removeWhere(
                  (key, _) => !selectedStates.contains(key),
                );
                fullySelectedStates.removeWhere(
                  (key) => !selectedStates.contains(key),
                );
                setState(() {});
              },
            ),
          ),
          Wrap(
            spacing: 6,
            children: selectedStates.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_outlined,color: Colors.blue,),
                    SizedBox(width: 8,),
                    Text(
                      item,
                      style: TextStyle(fontSize: 15,color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          for (String state in selectedStates) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith<Color>((
                        Set<MaterialState> states,
                        ) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.blue; // Checkbox color when selected
                      }
                      return Colors.grey; // When unselected
                    }),
                    value: fullySelectedStates.contains(state),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          fullySelectedStates.add(state);
                          selectedDistricts[state] =
                              stateDistrictMap[state]!;
                        } else {
                          fullySelectedStates.remove(state);
                          selectedDistricts.remove(state);
                        }
                      });
                    },
                  ),
                  Text(
                    'All district in $state',
                    style: TextStyle(fontSize: 15,color: Colors.black),
                  ),
                ],
              ),
            ),
              if (!fullySelectedStates.contains(state)) ...[
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ), // 👈 Changes the dropdown arrow color
              ),
              child: MultiSelectDialogField(
                unselectedColor: Colors.black,
                chipDisplay: MultiSelectChipDisplay(
                  chipColor: Colors.white,
                  textStyle: TextStyle(color: Colors.black),
                ),
                selectedItemsTextStyle: TextStyle(color: Colors.black),
                items:
                stateDistrictMap[state]!
                    .map((e) => MultiSelectItem(e, e))
                    .toList(),
                title: Text(
                  'Select Districts',
                  style: TextStyle(color: Colors.black),
                ),
                buttonText: Text(
                  'Select Districts in $state',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                searchIcon: Icon(
                  Icons.arrow_downward_sharp,
                  color: Colors.black,
                ),
                onConfirm: (values) {
                  selectedDistricts[state] = values.cast<String>();
                  setState(() {});
                },
              ),
            ),
            ],
            const SizedBox(height: 10),
          ],
        ],
        const SizedBox(height: 10),
        CustomDropdown(
          items: noOfDays,
          value: NoOfDays,
          hint: "Number of days for Advertisement",
          onChanged: (value) {
            NoOfDays = value;
            setState(() {});
          },
        ),
      ],
    );
  }

  File? videoThumbnail;

  Future<File?> getVideoThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(
      videoPath,
      quality: 50, // 0 to 100
      position: -1, // -1 = auto select, or provide seconds (e.g. 2)
    );
    return thumbnail;
  }

  Future<void> pickSingleFile() async {
    try {
      XFile? file;

      if (isVideo) {
        file = await picker.pickVideo(source: ImageSource.gallery);
        if (file != null) {
          await compressVideo(file.path);
          if (compressedVideo?.file != null) {
            selectedFile = compressedVideo!.file!;
            videoThumbnail = await getVideoThumbnail(file.path);
          } else {
            return;
          }
        } else {
          return;
        }
      } else {
        file = await picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          selectedFile = File(file.path);
        } else {
          return;
        }
      }
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> compressVideo(String path) async {
    adController.startMediaUpload();
    final info = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.MediumQuality,
      // Options: Low, Medium, High, VeryHigh
      deleteOrigin: false, // Set true to delete original file
    );

    if (info != null) {
      setState(() {
        compressedVideo = info;
      });
    }
    adController.stopMediaUpload();
  }

  void _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    int totalDistricts = selectedDistricts.values
        .fold(0, (sum, list) => sum + list.length);
    price= totalDistricts*NoOfDays!.toInt()*10;

    if (selectedFile == null) {
      _showError("Please upload an image or video.");
      return;
    }

    if (NoOfDays == null) {
      _showError("Please select ad duration.");
      return;
    }

    if (!entireCountry && selectedStates.isEmpty && selectedDistricts.isEmpty) {
      _showError(
        "Please select location (state/district) or enable entire country.",
      );
      return;
    }

    adController.startLoading();
    String? imageUrl;
    String? videoUrl;

    if (isVideo) {
      videoUrl = await StorageServices().uploadVideo(selectedFile!);
    } else {
      imageUrl = await StorageServices().uploadImage(selectedFile!);
    }
    String id = FirebaseFirestore.instance.collection(adCollection).doc().id;

    final ad = AddModal(
      adId: id,
      adImage: imageUrl,
      adVideo: videoUrl,
      adName: businessName.text.trim(),
      contactNo: contactNo.text.trim(),
      entireCountry: entireCountry,
      selectedStates: entireCountry ? null : selectedStates,
      selectedDistrictsPerState: entireCountry ? null : selectedDistricts,
      startDate: Timestamp.now(),
      durationDays: NoOfDays!,
    );

    await adServices.addTheAd(ad, id);
    print("Total Price = $price");
    adController.stopLoading();

    // 👇 Upload logic goes here (Firebase or API)
    // print(ad.toJson());

    await adController.fetchAds();

    // ✅ Optionally show success/snackbar
    context.go("${RoutsName.bottomNavigation}/0");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Ad registered successfully")));

    // Clear form if needed
    _formKey.currentState?.reset();
    setState(() {
      selectedFile = null;
      isVideo = false;
      compressedVideo = null;
      selectedStates.clear();
      selectedDistricts.clear();
      entireCountry = false;
      NoOfDays = null;
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }
}
