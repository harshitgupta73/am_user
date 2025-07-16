import 'dart:convert';

import 'package:am_user/data/firebase/shop_method/shope_methods.dart';
import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/modals/driver_modal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../data/firebase/driver_methods/driver_insert_update.dart';
import '../data/firebase/worker_methods/worker_method.dart';
import '../modals/shopModal.dart';

class Controller extends GetxController {
  final ShopMethods shopMethods = ShopMethods();
  final DriverMethods driverMethods = DriverMethods();
  final WorkerMethod workerMethod = WorkerMethod();

  final shops = <ShopModal>[].obs;
  final drivers = <DriverModal>[].obs;
  final workers = <WorkerModal>[].obs;
  RxBool isLoading = false.obs;

  final allUsers = <AllUserModal>[].obs;

  final currDistrict = "".obs;

  void startLoading() => isLoading.value = true;

  void stopLoading() => isLoading.value = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllShops();
    getAllDrivers();
    getAllWorkers();
    getCurrentDistrict().then((_) => getAllUsers());
  }

  Future<void> getAllShops() async {
    isLoading.value = true;
    shops.value = await shopMethods.getAllShops();
    isLoading.value = false;
  }

  Future<void> getAllDrivers() async {
    isLoading.value = true;
    drivers.value = await driverMethods.getAllDrivers();
    isLoading.value = false;
  }

  Future<void> getAllWorkers() async {
    isLoading.value = true;
    workers.value = await workerMethod.getAllWorkers();
    isLoading.value = false;
  }

  Future<void> getCurrentDistrict() async {
    isLoading.value=true;
    try {

      final permission = await Permission.location.request();

      if (!permission.isGranted) {
        Get.snackbar("Permission Denied", "Location permission is required");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      getSubLocality(position.latitude, position.longitude);

      print(placemarks.first);

      if (placemarks.isNotEmpty) {
        String? district = placemarks.first.subAdministrativeArea;
        if (district != null && district.isNotEmpty) {
          if (district != null && district.isNotEmpty) {
            // Remove " Division" if it exists
            district = district.replaceAll(" Division", "").trim();
            currDistrict.value = district;
            print("Current District: $district");
          }
        } else {
          Get.snackbar("Error", "Could not detect district");
        }
      }

    } catch (e) {
      Get.snackbar("Location Error", e.toString());
    } finally{
      isLoading.value=false;
    }
  }

  Future<void> getSubLocality(double lat, double lon) async {
    final String overpassQuery = '''
  [out:json][timeout:25];
  (
    node["place"~"suburb|neighbourhood|locality"](around:500,$lat,$lon);
    way["place"~"suburb|neighbourhood|locality"](around:500,$lat,$lon);
    relation["place"~"suburb|neighbourhood|locality"](around:500,$lat,$lon);
  );
  out center;
  ''';

    try {
      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: {'data': overpassQuery},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['elements'] != null && data['elements'].isNotEmpty) {
          // Get the first matched sub-locality
          final tags = data['elements'][0]['tags'];
          final name = tags != null ? tags['name'] : 'Unknown';
          print('Sub-locality: $name');
        } else {
          print('No sub-locality found nearby.');
        }
      } else {
        print('Failed to fetch data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred:$e');
    }
  }

  Future<void> getAllUsers() async {
    isLoading.value = true;

    try {
      final district = currDistrict.value;
      if (district.isEmpty) {
        Get.snackbar("Error", "District not found");
        return;
      }

      List<AllUserModal> tempList = [];
      // Fetch shops
      final shopSnapshot =
          await FirebaseFirestore.instance
              .collection('Shops')
              .where('distValue', isEqualTo: district)
              .get();
      for (var doc in shopSnapshot.docs) {
        final data = doc.data();
        tempList.add(
          AllUserModal(
            name: data['shopName'] ?? 'Unnamed Shop',
            contact: data['contactNo'] ?? '',
            type: 'Shop',
            id: doc.id,
            image: data['shopImage'],
          ),
        );
      }

      // Fetch drivers
      final driverSnapshot =
          await FirebaseFirestore.instance
              .collection('drivers')
              .where('distValue', isEqualTo: district)
              .get();
      for (var doc in driverSnapshot.docs) {
        final data = doc.data();
        tempList.add(
          AllUserModal(
            name: data['driverName'] ?? 'Unnamed Driver',
            contact: data['driverContact'] ?? '',
            type: 'Driver',
            id: doc.id,
            image: data['driverImage'],
          ),
        );
      }

      // Fetch workers
      final workerSnapshot =
          await FirebaseFirestore.instance
              .collection('Workers')
              .where('distValue', isEqualTo: district)
              .get();
      for (var doc in workerSnapshot.docs) {
        final data = doc.data();
        tempList.add(
          AllUserModal(
            name: data['workerName'] ?? 'Unnamed Worker',
            contact: data['workerContact'] ?? '',
            type: 'Worker',
            id: doc.id,
            image: data['workerImage'],
          ),
        );
      }
      tempList.shuffle(); // 🔀 Randomly intermix all users
      allUsers.value = tempList;
    } catch (e) {
      print("Error fetching users: $e");
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
