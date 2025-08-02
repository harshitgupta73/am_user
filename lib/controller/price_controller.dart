import 'package:am_user/data/firebase/user/user_insert_update.dart';
import 'package:get/get.dart';

import '../modals/price_model.dart';

class PriceController extends GetxController{

  final UserMethod userMethod= UserMethod();

  final Rxn<PriceModel> _price = Rxn<PriceModel>();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  PriceModel? get price => _price.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData(){
    userMethod.getPrice().listen((price) {
      _price.value = price;
    });
  }
}