import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModal {
  String? shopId;
  String? shopName;
  String? proprietorName;
  String? contactNo;
  String? shopAddress;
  List<String>? shopType;
  Set<String>? shopCategorySet;                  // to store raw Set
  Map<String, Set<String>>? shopSubcategoryMap;
  String? openingTime;
  String? closingTime;
  List<String>? days;
  String? aboutBusiness;
  String? website;
  String? shopItem;
  String? shopImage;
  String? stateValue;
  String? distValue;
  Map<String, dynamic>? position; // Contains 'geopoint' and 'geohash'
  Timestamp? lastUpdated;

  ShopModal({
    this.shopId,
    this.shopName,
    this.proprietorName,
    this.contactNo,
    this.shopAddress,
    this.shopType,
    this.shopCategorySet,
    this.shopSubcategoryMap,
    this.openingTime,
    this.closingTime,
    this.days,
    this.aboutBusiness,
    this.website,
    this.shopItem,
    this.shopImage,
    this.stateValue,
    this.distValue,
    this.position,
    this.lastUpdated,
  });

  // Create a ShopModal from a JSON map
  factory ShopModal.fromJson(Map<String, dynamic> json) {
    return ShopModal(
      shopId: json['shopId'] as String?,
      shopName: json['shopName'] as String?,
      proprietorName: json['proprietorName'] as String?,
      contactNo: json['contactNo'] as String?,
      shopAddress: json['shopAddress'] as String?,
      shopType: (json['shopType'] as List<dynamic>?)?.cast<String>(),
      shopCategorySet: (json['shopCategorySet'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toSet(),
      shopSubcategoryMap: (json['shopSubcategoryMap'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e.toString()).toSet(),
        ),
      ),
      openingTime: json['openingTime'] as String?,
      closingTime: json['closingTime'] as String?,
      days: (json['days'] as List<dynamic>?)?.cast<String>(),
      aboutBusiness: json['aboutBusiness'] as String?,
      website: json['website'] as String?,
      shopItem: json['shopItem'] as String?,
      shopImage: json['shopImage'] as String?,
      stateValue: json['stateValue'] as String?,
      distValue: json['distValue'] as String?,
      position: json['position'] as Map<String, dynamic>?,
      lastUpdated: json['lastUpdated'] as Timestamp?,
    );
  }

  // Convert ShopModal to JSON map
  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'shopName': shopName,
      'proprietorName': proprietorName,
      'contactNo': contactNo,
      'shopAddress': shopAddress,
      'shopType': shopType,
      'shopCategorySet': shopCategorySet?.toList(),  // Convert Set to List
      'shopSubcategoryMap': shopSubcategoryMap?.map(
            (key, value) => MapEntry(key, value.toList()),  // Convert inner Set to List
      ),
      'openingTime': openingTime,
      'closingTime': closingTime,
      'days': days,
      'aboutBusiness': aboutBusiness,
      'website': website,
      'shopItem': shopItem,
      'shopImage': shopImage,
      'stateValue': stateValue,
      'distValue': distValue,
      'position': position,
      'lastUpdated': lastUpdated,
    };
  }
}
