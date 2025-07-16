class DriverModal {
  String? driverName;
  String? driverContact;
  String? email;
  String? driverLicenceNo;
  String? vehicleNo;
  String? vehicleOwnerName;
  String? driverAddress;
  String? driverOtherSkill;
  String? vehicleRcImage;
  String? driverImage;
  String? drivingLicence;
  String? gender;
  String? stateValue;
  String? distValue;
  String? jobWorkCategory;
  String? jobWork;

  DriverModal({
    this.driverName,
    this.driverContact,
    this.driverLicenceNo,
    this.email,

    this.vehicleNo,
    this.vehicleOwnerName,
    this.driverAddress,
    this.driverOtherSkill,
    this.vehicleRcImage,
    this.driverImage,
    this.drivingLicence,
    this.gender,
    this.stateValue,
    this.distValue,
    this.jobWorkCategory,
    this.jobWork,
  });


  // Optional: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'driverContact': driverContact,
      'driverLicenceNo': driverLicenceNo,
      'email':email,
      'vehicleNo': vehicleNo,
      'vehicleOwnerName': vehicleOwnerName,
      'driverAddress': driverAddress,
      'driverOtherSkill': driverOtherSkill,
      'vehicleRcImage': vehicleRcImage,
      'driverImage': driverImage,
      'drivingLicence': drivingLicence,
      'gender': gender,
      'stateValue': stateValue,
      'distValue': distValue,
      'jobWorkCategory': jobWorkCategory,
      'jobWork': jobWork,
    };
  }


  // Optional: Create from JSON
  factory DriverModal.fromJson(Map<String, dynamic> json) {
    return DriverModal(
      driverName: json['driverName'],
      driverContact: json['driverContact'],
      driverLicenceNo: json['driverLicenceNo'],
      vehicleNo: json['vehicleNo'],
      email: json['email'],
      vehicleOwnerName: json['vehicleOwnerName'],
      driverAddress: json['driverAddress'],
      driverOtherSkill: json['driverOtherSkill'],
      vehicleRcImage: json['vehicleRcImage'],
      driverImage: json['driverImage'],
      drivingLicence: json['drivingLicence'],
      gender: json['gender'],
      stateValue: json['stateValue'],
      distValue: json['distValue'],
      jobWorkCategory: json['jobWorkCategory'],
      jobWork: json['jobWork'],
    );
  }
}
