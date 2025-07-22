import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModal {
  String? driverId;
  String? driverName;
  String? driverContact;
  String? email;
  String? driverLicenceNo;
  String? vehicleNo;
  String? vehicleName;
  String? vehicleOwnerName;
  String? driverAddress;
  String? driverOtherSkill;
  String? vehicleRcImage;
  String? driverImage;
  String? drivingLicence;
  String? stateValue;
  String? distValue;
  Map<String, dynamic>? position; // Contains 'geopoint' and 'geohash'
  Timestamp? lastUpdated;

  DriverModal({
    this.driverId,
    this.driverName,
    this.driverContact,
    this.driverLicenceNo,
    this.email,
    this.vehicleName,
    this.vehicleNo,
    this.vehicleOwnerName,
    this.driverAddress,
    this.driverOtherSkill,
    this.vehicleRcImage,
    this.driverImage,
    this.drivingLicence,
    this.stateValue,
    this.distValue,
    this.position,
    this.lastUpdated,
  });


  // Optional: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'driverName': driverName,
      'driverContact': driverContact,
      'driverLicenceNo': driverLicenceNo,
      'email':email,
      'vehicleName': vehicleName,
      'vehicleNo': vehicleNo,
      'vehicleOwnerName': vehicleOwnerName,
      'driverAddress': driverAddress,
      'driverOtherSkill': driverOtherSkill,
      'vehicleRcImage': vehicleRcImage,
      'driverImage': driverImage,
      'drivingLicence': drivingLicence,
      'stateValue': stateValue,
      'distValue': distValue,
      'position': position,
      'lastUpdated': lastUpdated,
    };
  }


  // Optional: Create from JSON
  factory DriverModal.fromJson(Map<String, dynamic> json) {
    return DriverModal(
      driverId: json['driverId'],
      driverName: json['driverName'],
      driverContact: json['driverContact'],
      driverLicenceNo: json['driverLicenceNo'],
      vehicleNo: json['vehicleNo'],
      email: json['email'],
      vehicleName: json['vehicleName'],
      vehicleOwnerName: json['vehicleOwnerName'],
      driverAddress: json['driverAddress'],
      driverOtherSkill: json['driverOtherSkill'],
      vehicleRcImage: json['vehicleRcImage'],
      driverImage: json['driverImage'],
      drivingLicence: json['drivingLicence'],
      stateValue: json['stateValue'],
      distValue: json['distValue'],
      position: json['position'],
      lastUpdated: json['lastUpdated'],
    );
  }
}
