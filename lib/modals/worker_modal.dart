import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerModal {
  String? workerId;
  String? workerName;
  String? address;
  String? otherSkills;
  String? workerContat;
  String? workerImage;
  String? selectedGender;
  String? stateValue;
  String? distValue;
  List<String>? workType;
  Map<String, dynamic>? position; // Contains 'geopoint' and 'geohash'
  Timestamp? lastUpdated;

  WorkerModal({
    this.workerId,
    this.workerName,
    this.workerContat,
    this.address,
    this.otherSkills,
    this.workerImage,
    this.selectedGender,
    this.stateValue,
    this.distValue,
    this.workType,
    this.position,
    this.lastUpdated,
  });

  // Convert from JSON (excluding Uint8List which is binary and not JSON-serializable directly)
  factory WorkerModal.fromJson(Map<String, dynamic> json) {
    return WorkerModal(
      workerId: json['workerId'] as String?,
      workerName: json['workerName'] as String?,
      workerContat: json['workerContact'] as String?,
      address: json['address'] as String?,
      otherSkills: json['otherSkills'] as String?,
      selectedGender: json['selectedGender'] as String?,
      stateValue: json['stateValue'] as String?,
      distValue: json['distValue'] as String?,
      workType: (json['workType'] as List<dynamic>?)?.cast<String>(),
      workerImage: json['workerImage'] as String,
      position: json['position'] as Map<String, dynamic>?,
      lastUpdated: json['lastUpdated'] as Timestamp?,
    );
  }

  // Convert to JSON (excluding binary serialization)
  Map<String, dynamic> toJson() {
    return {
      'workerId' :workerId,
      'workerName': workerName,
      'workerContact':workerContat,
      'address': address,
      'otherSkills': otherSkills,
      'selectedGender': selectedGender,
      'stateValue': stateValue,
      'distValue': distValue,
      'workType': workType,
      'workerImage': workerImage,
      'position': position,
      'lastUpdated': lastUpdated,
      // Convert Uint8List to List<int> for JSON
    };
  }
}
