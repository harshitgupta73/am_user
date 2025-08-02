import 'package:am_user/controller/location_controller.dart';
import 'package:am_user/data/firebase/shop_method/shope_methods.dart';
import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/modals/driver_modal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire3/geoflutterfire3.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/firebase/driver_methods/driver_insert_update.dart';
import '../data/firebase/worker_methods/worker_method.dart';
import '../modals/shopModal.dart';

class Controller extends GetxController {
  final ShopMethods shopMethods = ShopMethods();
  final DriverMethods driverMethods = DriverMethods();
  final WorkerMethod workerMethod = WorkerMethod();

  final locationController = Get.find<LocationController>();

  final shops = <ShopModal>[].obs;
  final drivers = <DriverModal>[].obs;
  final workers = <WorkerModal>[].obs;
  RxBool isLoading = false.obs;

  final allUsers = <AllUserModal>[].obs;
  RxDouble distance = 0.0.obs;

  final currDistrict = "".obs;

  RxString option = ''.obs;
  RxString selectedCategory = ''.obs;
  RxString selectedSubCategory = ''.obs;
  RxString selectedWorkerType = ''.obs;

  RxList<ShopModal> shopList = <ShopModal>[].obs;
  RxList<WorkerModal> workerList = <WorkerModal>[].obs;
  RxList<DriverModal> driverList = <DriverModal>[].obs;

  void startLoading() => isLoading.value = true;

  void stopLoading() => isLoading.value = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllShops();
    getAllDrivers();
    getAllWorkers();
    getAllUsers();
    fetchDataBasedOnSelection();

    // print("shop : ${shopList.join(", ")}");
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

  Future<void> getAllUsers() async {
    isLoading.value = true;

    await locationController.fetchCurrentLocation();
    final lat = locationController.latitude.value;
    final lng = locationController.longitude.value;

    // print("lat = $lat , lng = $lng");
    double radiusInKm = 5.0;

    final geo = GeoFlutterFire();
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    List<AllUserModal> tempList = [];

    try {
      /// 1. Query Shops
      final shopStream = geo
          .collection(
            collectionRef: FirebaseFirestore.instance.collection('Shops'),
          )
          .within(
            center: center,
            radius: radiusInKm,
            field: 'position',
            strictMode: true,
          );

      await for (var docs in shopStream) {
        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          GeoPoint geopoint = data['position']['geopoint'];
          distBWTwoPoints(lat, lng, geopoint.latitude, geopoint.longitude);
          print("distance= $distance");
          tempList.add(
            AllUserModal(
              name: data['shopName'] ?? 'Unnamed Shop',
              contact: data['contactNo'] ?? '',
              type: 'Shop',
              id: doc.id,
              image: data['shopImage'],
              distance: distance.value,
            ),
          );
        }
        break; // Only need first event from stream
      }

      /// 2. Query Drivers
      final driverStream = geo
          .collection(
            collectionRef: FirebaseFirestore.instance.collection('drivers'),
          )
          .within(
            center: center,
            radius: radiusInKm,
            field: 'position',
            strictMode: true,
          );

      await for (var docs in driverStream) {
        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          GeoPoint geopoint = data['position']['geopoint'];
          distBWTwoPoints(lat, lng, geopoint.latitude, geopoint.longitude);
          tempList.add(
            AllUserModal(
              name: data['driverName'] ?? 'Unnamed Driver',
              contact: data['driverContact'] ?? '',
              type: 'Driver',
              id: doc.id,
              image: data['driverImage'],
              distance: distance.value,
            ),
          );
        }
        break;
      }

      /// 3. Query Workers
      final workerStream = geo
          .collection(
            collectionRef: FirebaseFirestore.instance.collection('Workers'),
          )
          .within(
            center: center,
            radius: radiusInKm,
            field: 'position',
            strictMode: true,
          );

      await for (var docs in workerStream) {
        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          GeoPoint geopoint = data['position']['geopoint'];
          distBWTwoPoints(lat, lng, geopoint.latitude, geopoint.longitude);
          tempList.add(
            AllUserModal(
              name: data['workerName'] ?? 'Unnamed Worker',
              contact: data['workerContact'] ?? '',
              type: 'Worker',
              id: doc.id,
              image: data['workerImage'],
              distance: distance.value,
            ),
          );
        }
        break;
      }

      tempList.shuffle(); // 🔀 Random mix
      allUsers.value = tempList;
      // tempList.forEach((index) => print(index.toMap()));
    } catch (e) {
      print("Error in geohash query: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filterDataBasedOnSelection() async {
    print("object");
    if (option.value == "Shops") {
      print("djvdh");
      // Filter shops by category and subcategory
      final filtered =
          shops.where((shop) {
            final hasCategory =
                shop.shopCategorySet?.contains(selectedCategory.value) ?? false;
            final hasSubcategory =
                shop.shopSubcategoryMap?[selectedCategory.value]?.contains(
                  selectedSubCategory.value,
                ) ??
                false;
            return hasCategory && hasSubcategory;
          }).toList();

      shopList.value = filtered;
      print("djhb= ${shopList[0].days}");
    } else if (option.value == "Workers") {
      // Filter workers by selected work types
      final filtered =
          workers.where((worker) {
            return worker.workType?.contains(selectedWorkerType.value) ?? false;
          }).toList();

      workerList.value = filtered;
    } else if (option.value == "drivers") {
      // Just assign all drivers
      driverList.value = drivers;
    }
  }

  Future<void> fetchDataBasedOnSelection() async {
    if (option.value == "Shops") {
      // Fetch shops matching category and subcategory
      final snapshot =
          await FirebaseFirestore.instance
              .collection('Shops')
              .where('shopCategorySet', arrayContains: selectedCategory.value)
              .get();

      shops.value =
          snapshot.docs.map((doc) => ShopModal.fromJson(doc.data())).toList();

      // Filter subcategory manually
      List<ShopModal> filteredShops =
          shops.where((shop) {
            final subMap = shop.shopSubcategoryMap;
            if (subMap != null && subMap.containsKey(selectedCategory.value)) {
              return subMap[selectedCategory.value]!.contains(
                selectedSubCategory.value,
              );
            }
            return false;
          }).toList();

      shopList.value = filteredShops;
      print("dkhvd= ${shopList.length}");
    } else if (option.value == "Workers") {
      // Fetch workers matching selected types

      final snapshot =
          await FirebaseFirestore.instance
              .collection('Workers')
              .where('workType', arrayContains: selectedWorkerType.value)
              .get();

      List<WorkerModal> workers =
          snapshot.docs.map((doc) => WorkerModal.fromJson(doc.data())).toList();

      workerList.value = workers;
    } else if (option.value == "drivers") {
      // Fetch all drivers
      final snapshot =
          await FirebaseFirestore.instance.collection('drivers').get();

      List<DriverModal> drivers =
          snapshot.docs.map((doc) => DriverModal.fromJson(doc.data())).toList();

      driverList.value = drivers;
    }
  }

  void distBWTwoPoints(double lat1, double lon1, double lat2, double lon2) {
    distance.value = Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }
}
