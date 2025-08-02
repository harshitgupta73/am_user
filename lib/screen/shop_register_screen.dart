import 'dart:io';
import 'package:am_user/business_categories/business_type.dart';
import 'package:am_user/controller/user_provider/get_user_provider.dart';
import 'package:am_user/data/firebase/shop_method/shope_methods.dart';
import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:am_user/modals/shopModal.dart';
import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/component/custom_dropdwon.dart';
import 'package:am_user/widgets/component/custome_textfield.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/constants/login_type.dart';
import 'package:am_user/widgets/routs/routs.dart';
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
import '../controller/image_picker_controller.dart';
import '../data/shareprefrance/shareprefrance.dart';
import '../widgets/component/custom_image_container.dart';
import '../widgets/component/show_type_dropdown.dart';

class ShopRegisterScreen extends StatefulWidget {
  const ShopRegisterScreen({super.key});

  @override
  State<ShopRegisterScreen> createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  final userController = Get.find<GetUserController>();
  final Controller controller = Get.find<Controller>();

  bool isEditing = false;

  final SharePreferencesMethods sharedPreferencesMethods =
      SharePreferencesMethods();

  final ShopMethods shopMethods = ShopMethods();
  final imagePickerController = Get.put(ImagePickerController());
  final StorageServices storageServices = StorageServices();
  final TextEditingController shopName = TextEditingController();
  final TextEditingController propritorName = TextEditingController();
  final TextEditingController contactNo = TextEditingController();
  final TextEditingController shopAddress = TextEditingController();
  final TextEditingController shopItem = TextEditingController();
  final TextEditingController openingTime = TextEditingController();
  final TextEditingController closingTime = TextEditingController();
  final TextEditingController aboutBusiness = TextEditingController();
  final TextEditingController website = TextEditingController();

  String? shopImage;
  String? stateValue;
  String? distValue;

  List<String> shopTypes = [];
  Set<String> selectedCategories = {};
  Map<String, Set<String>> selectedSubcategories = {};
  List<String> days = [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    if (userController.shopModal.value != null) {
      setState(() {
        isEditing = true;
      });
      shopImage = userController.shopModal.value!.shopImage;
      // imagePickerController.imagePath.value =
      //     userController.shopModal.value!.shopImage!;
      shopName.text = userController.shopModal.value!.shopName!;
      propritorName.text = userController.shopModal.value!.proprietorName!;
      contactNo.text = userController.shopModal.value!.contactNo!;
      shopTypes = userController.shopModal.value!.shopType!;
      selectedCategories = userController.shopModal.value!.shopCategorySet!;
      selectedSubcategories =
          userController.shopModal.value!.shopSubcategoryMap!;
      shopAddress.text = userController.shopModal.value!.shopAddress!;
      stateValue = userController.shopModal.value!.stateValue!;
      distValue = userController.shopModal.value!.distValue!;
      openingTime.text = userController.shopModal.value!.openingTime!;
      closingTime.text = userController.shopModal.value!.closingTime!;
      aboutBusiness.text = userController.shopModal.value!.aboutBusiness!;
      website.text = userController.shopModal.value!.website!;
      days = userController.shopModal.value!.days!;
      shopItem.text = userController.shopModal.value!.shopItem!;
    }
  }

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final selectedChips =
        selectedSubcategories.entries
            .expand(
              (entry) => entry.value.map(
                (subcat) => Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.black, size: 16),
                      SizedBox(width: 4),
                      Text(subcat, style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black26),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            )
            .toList();

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
                    const SizedBox(height: 10),
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
                        } else if (shopImage != null) {
                          return Image(
                            image: NetworkImage(shopImage!),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        } else {
                          // Show placeholder container
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
                      controller: shopName,
                      label: 'Business & Shop Name',
                      color: Colors.black,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: propritorName,
                      label: 'Proprietor Name',
                      color: Colors.black,
                    ),
                    SizedBox(height: 10),

                    CustomTextField(
                      controller: contactNo,
                      label: 'Contact No',
                      inputType: TextInputType.number,
                      color: Colors.black,
                    ),

                    SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Colors.white,
                          iconTheme: IconThemeData(
                            color: Colors.black,
                          ), // 👈 Changes the dropdown arrow color
                        ),
                        child: MultiSelectDialogField(
                          items:
                              Provider().business_type
                                  .map((e) => MultiSelectItem<String>(e, e))
                                  .toList(),
                          title: Text("Business Types"),
                          buttonText: Text(
                            "Select Business Types",
                            style: TextStyle(color: Colors.black),
                          ),
                          searchable: true,
                          backgroundColor: Colors.white,
                          searchIcon: Icon(
                            Icons.arrow_downward_sharp,
                            color: Colors.black,
                          ),
                          unselectedColor: Colors.black,
                          chipDisplay: MultiSelectChipDisplay(
                            chipColor: Colors.white,
                            textStyle: TextStyle(color: Colors.black),
                          ),
                          selectedItemsTextStyle: TextStyle(
                            color: Colors.black,
                          ),
                          initialValue: shopTypes,
                          onConfirm: (values) {
                            setState(() {
                              shopTypes = values.cast<String>();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: _openCategoryDialog,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Select Business Categories",
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 8, children: selectedChips),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: shopItem,
                      label: 'Add all your Product',
                      color: Colors.black,
                    ),

                    const SizedBox(height: 10),

                    CustomTextField(
                      controller: shopAddress,
                      label: 'Address',
                      color: Colors.black,
                    ),

                    const SizedBox(height: 10),

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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Colors.white,
                          iconTheme: IconThemeData(
                            color: Colors.black,
                          ), // 👈 Changes the dropdown arrow color
                        ),
                        child: MultiSelectDialogField(
                          items:
                              Provider().days
                                  .map((e) => MultiSelectItem<String>(e, e))
                                  .toList(),
                          title: Text("Days"),
                          buttonText: Text(
                            "Select days",
                            style: TextStyle(color: Colors.black),
                          ),
                          searchable: true,
                          backgroundColor: Colors.white,
                          searchIcon: Icon(
                            Icons.arrow_downward_sharp,
                            color: Colors.black,
                          ),
                          unselectedColor: Colors.black,
                          chipDisplay: MultiSelectChipDisplay(
                            chipColor: Colors.white,
                            textStyle: TextStyle(color: Colors.black),
                          ),
                          selectedItemsTextStyle: TextStyle(
                            color: Colors.black,
                          ),
                          initialValue: days,
                          onConfirm: (values) {
                            setState(() {
                              days = values.cast<String>();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    CustomTextField(
                      controller: openingTime,
                      color: Colors.black,
                      label: 'Opening Time',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: closingTime,
                      color: Colors.black,
                      label: 'Closing Time',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: aboutBusiness,
                      color: Colors.black,
                      label: 'About Business',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: website,
                      color: Colors.black,
                      label: 'Website',
                    ),
                    SizedBox(height: 10),

                    Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.black)
                          // : CustomButton(
                          //   backgroundColor: customTextColor,
                          //   label:isEditing == false ? "Register" : "Update profile",
                          //   onPressed: () async {
                          //     if (_formKey.currentState!.validate() &&
                          //         imagePickerController
                          //             .imagePath
                          //             .value
                          //             .isNotEmpty) {
                          //       controller.startLoading();
                          //       File file = File(
                          //         imagePickerController.imagePath.value,
                          //       );
                          //       String url = await storageServices.uploadImage(
                          //         file,
                          //       );
                          //
                          //       String randomId =
                          //           userController.myUser!.userId!;
                          //
                          //       ShopModal shopModel = ShopModal(
                          //         shopId: randomId,
                          //         shopImage: url,
                          //         shopName: shopName.text.toString(),
                          //         proprietorName: propritorName.text.toString(),
                          //         contactNo: contactNo.text.toString(),
                          //         shopType: shopTypes,
                          //         shopCategorySet: selectedCategories,
                          //         shopSubcategoryMap: selectedSubcategories,
                          //         shopAddress: shopAddress.text.toString(),
                          //         stateValue: stateValue.toString(),
                          //         distValue: distValue.toString(),
                          //         openingTime: openingTime.text.toString(),
                          //         closingTime: closingTime.text.toString(),
                          //         aboutBusiness: aboutBusiness.text.toString(),
                          //         website: website.text.toString(),
                          //         days: days,
                          //         shopItem: shopItem.text.toString(),
                          //         position: _location.data,
                          //         lastUpdated: Timestamp.now(),
                          //       );
                          //
                          //       if (randomId.isNotEmpty) {
                          //         await shopMethods.insertShop(
                          //           shopModel,
                          //           randomId,
                          //         );
                          //       }
                          //       await sharedPreferencesMethods.clearUserData();
                          //       await sharedPreferencesMethods
                          //           .saveUserTypeAndUid("Shops", randomId);
                          //       imagePickerController.imagePath.value = '';
                          //
                          //       Navigator.pop(context);
                          //       controller.stopLoading();
                          //       await controller.getAllUsers();
                          //
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         SnackBar(
                          //           content: Text('Shop added successfully'),
                          //           backgroundColor: Colors.green,
                          //         ),
                          //       );
                          //     }
                          //   },
                          // );
                          : CustomButton(
                            backgroundColor: customTextColor,
                            label:
                                isEditing == false
                                    ? "Register"
                                    : "Update Profile",
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  (imagePickerController
                                          .imagePath
                                          .value
                                          .isNotEmpty ||
                                      shopImage != null)) {
                                controller.startLoading();

                                String url = shopImage ?? '';
                                // If user picked a new image, upload it
                                if (imagePickerController
                                    .imagePath
                                    .value
                                    .isNotEmpty) {
                                  File file = File(
                                    imagePickerController.imagePath.value,
                                  );
                                  url = await storageServices.uploadImage(file);
                                }

                                // Get shop ID — same for both add/edit
                                String shopId = userController.myUser!.userId!;

                                // Construct the ShopModal
                                ShopModal shopModel = ShopModal(
                                  shopId: shopId,
                                  shopImage: url,
                                  shopName: shopName.text.toString(),
                                  proprietorName: propritorName.text.toString(),
                                  contactNo: contactNo.text.toString(),
                                  shopType: shopTypes,
                                  shopCategorySet: selectedCategories,
                                  shopSubcategoryMap: selectedSubcategories,
                                  shopAddress: shopAddress.text.toString(),
                                  stateValue: stateValue.toString(),
                                  distValue: distValue.toString(),
                                  openingTime: openingTime.text.toString(),
                                  closingTime: closingTime.text.toString(),
                                  aboutBusiness: aboutBusiness.text.toString(),
                                  website: website.text.toString(),
                                  days: days,
                                  shopItem: shopItem.text.toString(),
                                  position: _location.data,
                                  lastUpdated: Timestamp.now(),
                                );

                                if (isEditing) {
                                  // Update shop
                                  await shopMethods.updateShop(
                                    shopModel,
                                    shopId,
                                  );
                                  await userController.loadUserFromFirestore();
                                } else {
                                  // Insert new shop
                                  await shopMethods.insertShop(
                                    shopModel,
                                    shopId,
                                  );
                                  await sharedPreferencesMethods
                                      .clearUserData();
                                  await sharedPreferencesMethods
                                      .saveUserTypeAndUid("Shops", shopId);
                                  await userController.loadUserFromFirestore();
                                }

                                imagePickerController.imagePath.value = '';
                                controller.stopLoading();
                                if (isEditing == false)
                                  await controller.getAllUsers();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isEditing
                                        ? 'Shop profile updated successfully'
                                        : 'Shop registered successfully for one year'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                isEditing == true
                                    ? context.go(RoutsName.typeDashboard)
                                    : Navigator.pop(context);
                              }
                            },
                          );
                    }),
                    SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     InkWell(
                    //       onTap:
                    //           () => context.go(
                    //             "${RoutsName.loginScreen}/$shopLogin",
                    //           ),
                    //       child: Text(
                    //         "Already have Account? Login",
                    //         style: TextStyle(color: Colors.black),
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

  void _openCategoryDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Select Business Categories"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Container(
                width: double.maxFinite,
                height: 400,
                child: Scrollbar(
                  child: ListView(
                    children:
                        Provider().business_category.entries.map((entry) {
                          final category = entry.key;
                          final subcats = entry.value;

                          return ExpansionTile(
                            title: Row(
                              children: [
                                Checkbox(
                                  value: selectedCategories.contains(category),
                                  onChanged: (bool? checked) {
                                    setState(() {
                                      setStateDialog(() {
                                        if (checked == true) {
                                          selectedCategories.add(category);
                                          selectedSubcategories[category] =
                                              selectedSubcategories[category] ??
                                              {};
                                        } else {
                                          selectedCategories.remove(category);
                                          selectedSubcategories.remove(
                                            category,
                                          );
                                        }
                                      });
                                    });
                                  },
                                ),
                                Expanded(child: Text(category)),
                              ],
                            ),
                            children:
                                subcats.map((subcat) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: CheckboxListTile(
                                      title: Text(subcat),
                                      value:
                                          selectedSubcategories[category]
                                              ?.contains(subcat) ??
                                          false,
                                      onChanged: (bool? checked) {
                                        setState(() {
                                          setStateDialog(() {
                                            if (checked == true) {
                                              selectedSubcategories[category]
                                                  ?.add(subcat);
                                            } else {
                                              selectedSubcategories[category]
                                                  ?.remove(subcat);
                                            }
                                          });
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                          );
                        }).toList(),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel without save
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Save and close
                setState(() {});
                print(selectedCategories);
                print(selectedSubcategories); // Update chips UI
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }
}
