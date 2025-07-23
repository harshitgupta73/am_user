import 'package:am_user/modals/add_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../widgets/constants/firebse_const/string_const.dart';

class AdServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTheAd(AddModal ad,String id)async{
    try{
      await _firestore
          .collection(adCollection)
          .doc(id)
          .set(ad.toJson());
      print('Ad inserted');
    }catch(e){
      print('Insert failed: $e');
    }
  }

  Future<List<AddModal>> fetchRelevantAds() async {
    List<AddModal> relevantAds = [];

    try {
      // Step 1: Get user's current location and convert to district
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String userDistrict = placemarks.first.subAdministrativeArea ?? '';
      String currDist= userDistrict.replaceAll(" Division", "");
      String userState = placemarks.first.administrativeArea ?? '';

      print('User location: $userState / $currDist');

      // Step 2: Get all ads from Firestore
      QuerySnapshot snapshot = await _firestore.collection(adCollection).get();
      print("dhvhdjh=${snapshot.docs.length}");

      for (var doc in snapshot.docs) {
        AddModal ad = AddModal.fromJson(doc.data() as Map<String, dynamic>);

        // Step 3: Filter by isActive()
        if (!ad.isActive()) continue;

        // Step 4: Filter based on location
        if (ad.entireCountry == true) {
          relevantAds.add(ad);
        } else {
          if (ad.selectedDistrictsPerState != null) {
            final stateDistricts = ad.selectedDistrictsPerState!;
            if (stateDistricts.containsKey(userState)) {
              final districts = stateDistricts[userState]!;
              if (districts.contains(currDist)) {
                relevantAds.add(ad);
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching relevant ads: $e');
    }
    print('Relevant ads: ${relevantAds.length}');
    return relevantAds;
  }

}