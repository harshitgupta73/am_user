import 'package:cloud_firestore/cloud_firestore.dart';

class PriceModel {
  String? id;
  double? nationwidePrice;
  double? districtPrice;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  PriceModel({
    this.id,
    this.nationwidePrice,
    this.districtPrice,
    this.createdAt,
    this.updatedAt,
  });

  // Factory to create from Firestore or Map
  factory PriceModel.fromMap(Map<String, dynamic> data, String id) {
    return PriceModel(
      id: id,
      nationwidePrice: (data['nationwidePrice'] ?? 0).toDouble(),
      districtPrice: (data['districtPrice'] ?? 0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  // Convert to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nationwidePrice': nationwidePrice,
      'districtPrice': districtPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Check if this is a first-time insert or update
  bool get isFirstTime => createdAt == updatedAt;
}