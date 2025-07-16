import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:am_user/modals/userModal.dart';

class SharePreferencesMethods {

  Future<UserModal?> loadUserFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(userJson);
        return UserModal.fromJson(jsonMap);
      } catch (e) {
        print('Error decoding user from SharedPreferences: $e');
        return null;
      }
    }

    return null;
  }


  Future<void> saveUserToSharedPref(UserModal user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }



}