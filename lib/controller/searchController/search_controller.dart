import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/modals/userModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../modals/driver_modal.dart';
import '../../modals/shopModal.dart';
import '../../modals/worker_modal.dart';
import '../location_controller.dart';

// class SearchController extends GetxController {
//   RxList<AllUserModal> allResults = <AllUserModal>[].obs;
//   final locationController = Get.find<LocationController>();
//   RxDouble distance = 0.0.obs;
//
//   Future<void> runSearch(String keyword) async {
//     print("keyword = $keyword");
//     allResults.clear();
//     final firestore = FirebaseFirestore.instance;
//     final searchKey = keyword.toLowerCase();
//     await locationController.fetchCurrentLocation();
//     final lat = locationController.latitude.value;
//     final lng = locationController.longitude.value;
//
//     final shopSnapshot = await firestore.collection('Shops').get();
//
//     for (var doc in shopSnapshot.docs) {
//       final data = doc.data();
//       final shop = ShopModal.fromJson(data);
//       GeoPoint geopoint = data['position']['geopoint'];
//       distBWTwoPoints(lat, lng, geopoint.latitude, geopoint.longitude);
//       // print("distance= $distance");
//
//       final matches =
//           (shop.shopName?.toLowerCase().contains(searchKey) ?? false) ||
//           (shop.shopCategorySet?.any(
//                 (cat) => cat.toLowerCase().contains(searchKey),
//               ) ??
//               false) ||
//           (shop.shopSubcategoryMap?.values.any(
//                 (set) => set.any(
//                   (subcat) => subcat.toLowerCase().contains(searchKey),
//                 ),
//               ) ??
//               false) ||
//           (shop.aboutBusiness?.toLowerCase().contains(searchKey) ?? false);
//
//       if (matches) {
//         allResults.add(
//           AllUserModal(
//             name: data['shopName'] ?? 'Unnamed Shop',
//             contact: data['contactNo'] ?? '',
//             type: 'Shop',
//             id: doc.id,
//             image: data['shopImage'],
//             distance: distance.value
//           ),
//         );
//       }
//     }
//     final workerSnapshot = await firestore.collection('Workers').get();
//
//     for (var doc in workerSnapshot.docs) {
//       final data = doc.data();
//       final worker = WorkerModal.fromJson(data);
//       GeoPoint geopoint = data['position']['geopoint'];
//       distBWTwoPoints(lat, lng, geopoint.latitude, geopoint.longitude);
//       // print("distance= $distance");
//
//       final matches =
//           (worker.workerName?.toLowerCase().contains(searchKey) ?? false) ||
//               (worker.workType?.any(
//                     (type) => type.toLowerCase().contains(searchKey),
//               ) ??
//                   false) ||
//               (worker.otherSkills?.toLowerCase().contains(searchKey) ?? false);
//
//       if (matches) {
//         allResults.add(
//           AllUserModal(
//             name: data['workerName'] ?? 'Unnamed Worker',
//             contact: data['workerContact'] ?? '',
//             type: 'Worker',
//             id: doc.id,
//             image: data['workerImage'],
//             distance: distance.value
//           ),
//         );
//       }
//     }
//     final snapshot = await firestore.collection('drivers').get();
//
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final driver = DriverModal.fromJson(data);
//       GeoPoint geopoint = data['position']['geopoint'];
//       distBWTwoPoints(lat, lng, geopoint.latitude, geopoint.longitude);
//       // print("distance= $distance");
//
//       final matches =
//           (driver.driverName?.toLowerCase().contains(searchKey) ?? false) ||
//               (driver.driverOtherSkill?.toLowerCase().contains(searchKey) ??
//                   false) ||
//               (driver.vehicleName?.toLowerCase().contains(searchKey) ?? false) ||
//               (driver.vehicleNo?.toLowerCase().contains(searchKey) ?? false);
//
//       if (matches) {
//         allResults.add(
//           AllUserModal(
//             name: data['driverName'] ?? 'Unnamed Driver',
//             contact: data['driverContact'] ?? '',
//             type: 'Driver',
//             id: doc.id,
//             image: data['driverImage'],
//             distance: distance.value
//           ),
//         );
//       }
//     }
//
//     // print("mdbbdj ${allResults.length}");
//   }
//
//   void distBWTwoPoints(double lat1, double lon1, double lat2, double lon2) {
//     distance.value = Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
//   }
// }
class SearchController extends GetxController {
  RxList<AllUserModal> allResults = <AllUserModal>[].obs;
  final locationController = Get.find<LocationController>();
  RxBool isLoading = false.obs;

  Future<void> runSearch(String keyword) async {
    print("keyword = $keyword");
    isLoading.value = true;
    allResults.clear();
    final firestore = FirebaseFirestore.instance;
    final searchKey = keyword.toLowerCase();

    await locationController.fetchCurrentLocation();
    final lat = locationController.latitude.value;
    final lng = locationController.longitude.value;

    // ----- Search in Shops -----
    final shopSnapshot = await firestore.collection('Shops').get();
    for (var doc in shopSnapshot.docs) {
      final data = doc.data();
      final shop = ShopModal.fromJson(data);

      GeoPoint geopoint = data['position']['geopoint'];
      double shopDistance = _calculateDistance(lat, lng, geopoint.latitude, geopoint.longitude);

      final matches =
          (shop.shopName?.toLowerCase().contains(searchKey) ?? false) ||
              (shop.shopCategorySet?.any((cat) => cat.toLowerCase().contains(searchKey)) ?? false) ||
              (shop.shopSubcategoryMap?.values.any(
                    (set) => set.any((subcat) => subcat.toLowerCase().contains(searchKey)),
              ) ?? false) ||
              (shop.aboutBusiness?.toLowerCase().contains(searchKey) ?? false);

      if (matches) {
        allResults.add(
          AllUserModal(
            name: data['shopName'] ?? 'Unnamed Shop',
            contact: data['contactNo'] ?? '',
            type: 'Shop',
            id: doc.id,
            image: data['shopImage'],
            distance: shopDistance,
          ),
        );
      }
    }

    // ----- Search in Workers -----
    final workerSnapshot = await firestore.collection('Workers').get();
    for (var doc in workerSnapshot.docs) {
      final data = doc.data();
      final worker = WorkerModal.fromJson(data);

      GeoPoint geopoint = data['position']['geopoint'];
      double workerDistance = _calculateDistance(lat, lng, geopoint.latitude, geopoint.longitude);

      final matches =
          (worker.workerName?.toLowerCase().contains(searchKey) ?? false) ||
              (worker.workType?.any((type) => type.toLowerCase().contains(searchKey)) ?? false) ||
              (worker.otherSkills?.toLowerCase().contains(searchKey) ?? false);

      if (matches) {
        allResults.add(
          AllUserModal(
            name: data['workerName'] ?? 'Unnamed Worker',
            contact: data['workerContact'] ?? '',
            type: 'Worker',
            id: doc.id,
            image: data['workerImage'],
            distance: workerDistance,
          ),
        );
      }
    }

    // ----- Search in Drivers -----
    final driverSnapshot = await firestore.collection('drivers').get();
    for (var doc in driverSnapshot.docs) {
      final data = doc.data();
      final driver = DriverModal.fromJson(data);

      GeoPoint geopoint = data['position']['geopoint'];
      double driverDistance = _calculateDistance(lat, lng, geopoint.latitude, geopoint.longitude);

      final matches =
          (driver.driverName?.toLowerCase().contains(searchKey) ?? false) ||
              (driver.driverOtherSkill?.toLowerCase().contains(searchKey) ?? false) ||
              (driver.vehicleName?.toLowerCase().contains(searchKey) ?? false) ||
              (driver.vehicleNo?.toLowerCase().contains(searchKey) ?? false);

      if (matches) {
        allResults.add(
          AllUserModal(
            name: data['driverName'] ?? 'Unnamed Driver',
            contact: data['driverContact'] ?? '',
            type: 'Driver',
            id: doc.id,
            image: data['driverImage'],
            distance: driverDistance,
          ),
        );
      }
    }
    isLoading.value = false;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // in km
  }
}
