import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString userState = ''.obs;
  RxString userDistrict = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (!status.isGranted) {
      await Permission.location.request(); // optional repeat request
    }
  }

  Future<void> fetchCurrentLocation() async {
    try {

      await requestLocationPermission();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        userState.value = place.administrativeArea ?? '';
        userDistrict.value =
            (place.subAdministrativeArea ?? '').replaceAll(' Division', '');
      }
      // print('Fetched location: ${latitude.value}, ${longitude.value}');
    } catch (e) {
      // print('Error fetching location: $e');
    }
  }
}
