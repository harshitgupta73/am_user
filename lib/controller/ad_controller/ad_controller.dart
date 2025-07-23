import 'package:am_user/data/firebase/ad_services/ad_services.dart';
import 'package:am_user/modals/add_modal.dart';
import 'package:get/get.dart';

class AdController extends GetxController{

  RxBool isLoading = false.obs;
  void startLoading() => isLoading.value = true;
  void stopLoading() => isLoading.value = false;

  final adServices = AdServices();

  RxBool isMediaUpload= false.obs;
  void startMediaUpload() => isMediaUpload.value = true;
  void stopMediaUpload() => isMediaUpload.value = false;

  RxList<AddModal> ads = <AddModal>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAds();
  }



  Future<void> fetchAds() async{
    isLoading.value=true;
    ads.value= await adServices.fetchRelevantAds();
    isLoading.value=false;
  }

}