import 'dart:async';
import 'dart:convert';
import 'package:am_user/modals/driver_modal.dart';
import 'package:am_user/modals/shopModal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<ShopModal?> loadShopFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final shopJson = prefs.getString('shop');
    if (shopJson != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(shopJson);
        return ShopModal.fromJson(jsonMap);
      } catch (e) {
        print('Error decoding shop from SharedPreferences: $e');
        return null;
      }
    }
    return null;
  }

  Future<WorkerModal?> loadWorkerFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final workerJson = prefs.getString('worker');
    if (workerJson != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(workerJson);
        return WorkerModal.fromJson(jsonMap);
      } catch (e) {
        print('Error decoding worker from SharedPreferences: $e');
        return null;
      }
    }
    return null;
  }
  Future<DriverModal?> loadVehicleFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final driverJson = prefs.getString('driver');
    if (driverJson != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(driverJson);
        return DriverModal.fromJson(jsonMap);
      } catch (e) {
        print('Error decoding driver from SharedPreferences: $e');
        return null;
      }
    }
    return null;
  }

  String safeEncode(Object? object) {
    return jsonEncode(object, toEncodable: (nonEncodable) {
      if (nonEncodable is GeoPoint) {
        return {
          'latitude': nonEncodable.latitude,
          'longitude': nonEncodable.longitude,
        };
      }
      return nonEncodable.toString(); // fallback
    });
  }


  Future<void> saveUserToSharedPref(UserModal user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }

  Future<void> saveShopToSharedPref(ShopModal shop) async {
    final prefs = await SharedPreferences.getInstance();
    final shopJson = jsonEncode(shop.toJson());
    await prefs.setString('shop', safeEncode(shopJson));

  }

  Future<void> saveWorkerToSharedPref(WorkerModal worker) async {
    final prefs = await SharedPreferences.getInstance();
    final workerJson = jsonEncode(worker.toJson());
    await prefs.setString('worker', safeEncode(workerJson));
  }
  Future<void> saveVehicleToSharedPref(DriverModal driver) async {
    final prefs = await SharedPreferences.getInstance();
    final driverJson = jsonEncode(driver.toJson());
    await prefs.setString('driver', safeEncode(driverJson));
  }

  static const String _userTypeKey = 'userType';
  static const String _uidKey = 'uid';

  Future<void> saveUserTypeAndUid(String userType, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, userType);
    await prefs.setString(_uidKey, uid);
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userTypeKey);
    await prefs.remove(_uidKey);
    await prefs.clear();
  }
}