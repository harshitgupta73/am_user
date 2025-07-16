import 'package:am_user/data/firebase/user/user_insert_update.dart';
import 'package:am_user/modals/userModal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GetUserController extends GetxController {
  final UserMethod userMethod = UserMethod();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final Rxn<UserModal> _userModal = Rxn<UserModal>();
  UserModal? get myUser => _userModal.value;

  @override
  void onInit() {
    super.onInit();
    getUser(); // Optional: auto-fetch on controller init
  }

  Future<void> getUser() async {
    try {
      String userId = firebaseAuth.currentUser!.uid;
      UserModal? user = await userMethod.getUserById(userId);
      if (user != null) {
        _userModal.value = user;
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  void clearUser() {
    _userModal.value = null;
  }
}
