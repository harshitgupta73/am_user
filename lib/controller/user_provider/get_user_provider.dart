import 'package:am_user/data/firebase/user/user_insert_update.dart';
import 'package:am_user/modals/driver_modal.dart';
import 'package:am_user/modals/shopModal.dart';
import 'package:am_user/modals/userModal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/shareprefrance/shareprefrance.dart';

class GetUserController extends GetxController {
  final UserMethod userMethod = UserMethod();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final RxBool isLoading = false.obs;

  final Rx<ShopModal?> shopModal = Rx<ShopModal?>(null);
  final Rx<WorkerModal?> workerModal = Rx<WorkerModal?>(null);
  final Rx<DriverModal?> driverModal = Rx<DriverModal?>(null);
  final RxString userType = "".obs;

  final Rxn<UserModal> _userModal = Rxn<UserModal>();
  UserModal? get myUser => _userModal.value;

  Rxn<UserModal> otherUser = Rxn<UserModal>();

  @override
  void onInit() {
    super.onInit();
    getUser();
    loadUserFromFirestore();
    // initUserTypeFromSharedPref();// Optional: auto-fetch on controller init
  }

  Future<void> getUser() async {
    try {
      isLoading.value = true;

      String userId = firebaseAuth.currentUser!.uid;
      UserModal? user = await userMethod.getUserById(userId);
      if (user != null) {
        _userModal.value = user;
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> getUserById(String id) async{
    try {
      isLoading.value = true;

      UserModal? user = await userMethod.getUserById(id);
      if (user != null) {
        otherUser.value = user;
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
    finally{
      isLoading.value = false;
    }
  }

  void clearUser() {
    _userModal.value = null;
  }

  Future<void> initUserTypeFromSharedPref() async {
    final prefs = SharePreferencesMethods();

    final shop = await prefs.loadShopFromSharedPref();
    if (shop != null) {
      shopModal.value = shop;
      userType.value = 'Shops';
      return;
    }

    final driver = await prefs.loadVehicleFromSharedPref();
    if (driver != null) {
      driverModal.value = driver;
      userType.value = 'drivers';
      return;
    }

    final worker = await prefs.loadWorkerFromSharedPref();
    if (worker != null) {
      workerModal.value = worker;
      userType.value = 'Workers';
      return;
    }

    userType.value = 'unknown';
  }

  Future<void> loadUserFromFirestore() async {
    isLoading.value=true;
    final uid = await SharePreferencesMethods().getUid();
    final userType = await SharePreferencesMethods().getUserType();
    final _firestore = FirebaseFirestore.instance;

    if (uid == null || userType == null) {
      print("No userType or uid found in SharedPreferences.");
      return;
    }

    final doc = await _firestore.collection(userType).doc(uid).get();
    if (!doc.exists) {
      print("No user document found for $userType with uid $uid.");
      return;
    }

    final data = doc.data()!;
    switch (userType) {
      case 'Shops':
        shopModal.value = ShopModal.fromJson(data);
        break;
      case 'Workers':
        workerModal.value = WorkerModal.fromJson(data);
        break;
      case 'drivers':
        driverModal.value = DriverModal.fromJson(data);
        break;
      default:
        print("Unknown userType: $userType");
    }
    isLoading.value=false;
  }



}
