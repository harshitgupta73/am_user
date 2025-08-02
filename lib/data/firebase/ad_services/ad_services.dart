import 'package:am_user/modals/add_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../controller/location_controller.dart';
import '../../../widgets/constants/firebse_const/string_const.dart';

class AdServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocationController locationController = Get.find<LocationController>();

  Future<void> addTheAd(AddModal ad, String id) async {
    try {
      await _firestore.collection(adCollection).doc(id).set(ad.toJson());
      print('Ad inserted');
    } catch (e) {
      print('Insert failed: $e');
    }
  }

  Future<List<AddModal>> fetchRelevantAds() async {
    List<AddModal> relevantAds = [];

    try {
      await locationController.fetchCurrentLocation();

      final String userState = locationController.userState.value;
      final String userDistrict = locationController.userDistrict.value;

      print('User location: $userState / $userDistrict');

      // Step 2: Get all ads from Firestore
      QuerySnapshot snapshot = await _firestore.collection(adCollection).get();
      print("Fetched ads: ${snapshot.docs.length}");

      for (var doc in snapshot.docs) {
        AddModal ad = AddModal.fromJson(doc.data() as Map<String, dynamic>);

        // Step 3: Filter by isActive()
        if (!ad.isActive()) continue;

        if (ad.entireCountry == true) {
          relevantAds.add(ad);
          continue;
        }

        // if (ad.selectedDistrictsPerState != null) {
        //   final stateDistricts = ad.selectedDistrictsPerState!;
        //   if (stateDistricts.containsKey(userState)) {
        //     final districts = stateDistricts[userState]!;
        //     if (districts.contains(currDist)) {
        //       relevantAds.add(ad);
        //     }
        //   }
        // }
        final stateDistricts = ad.selectedDistrictsPerState;
        if (stateDistricts == null || stateDistricts.isEmpty) continue;

        final districts = stateDistricts[userState];
        if (districts != null && districts.contains(userDistrict)) {
          relevantAds.add(ad);
        }
      }
    } catch (e) {
      print('Error fetching relevant ads: $e');
    }
    print('Relevant ads: ${relevantAds.length}');
    return relevantAds;
  }
}
