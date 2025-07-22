


import 'package:am_user/widgets/constants/firebse_const/string_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../modals/shopModal.dart';

class ShopMethods{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> insertShop(ShopModal shop,String id) async {
    try {
      await _firestore
          .collection(shopCollection)
          .doc(id)
          .set(shop.toJson());
      print('Shop inserted');
    } catch (e) {
      print('Insert failed: $e');
    }
  }

  Future<List<ShopModal>> getAllShops() async {
    try {
      final snapshot = await _firestore.collection('Shops').get();
      List<ShopModal> shopList = snapshot.docs
          .map((doc) => ShopModal.fromJson(doc.data()))
          .toList();
      return shopList;
    } catch (e) {
      print("Error fetching shops: $e");
      return [];
    }
  }

  Future<ShopModal?> getShopById(String docId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(shopCollection)
          .doc(docId)
          .get();

      if (doc.exists) {
        return ShopModal.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('No shop found');
        return null;
      }
    } catch (e) {
      print('Get failed: $e');
      return null;
    }
  }

  Future<void> updateShop(ShopModal shop, String docId) async {
    try {
      await _firestore
          .collection(shopCollection)
          .doc(docId)
          .update(shop.toJson());
      print('Shop updated');
    } catch (e) {
      print('Update failed: $e');
    }
  }

  Future<void> deleteShop(String docId) async {
    try {
      await _firestore
          .collection(shopCollection)
          .doc(docId)
          .delete();
      print('Shop deleted');
    } catch (e) {
      print('Delete failed: $e');
    }
  }


}