import 'dart:typed_data';

class WorkerModal {
  String? workerName;
  String? address;
  String? otherSkills;
  String? workerContat;
  String? workerImage;
  String? selectedGender;
  String? stateValue;
  String? distValue;
  String? jobWorkCategory;
  String? jobWork;

  WorkerModal({
    this.workerName,
    this.workerContat,
    this.address,
    this.otherSkills,
    this.workerImage,
    this.selectedGender,
    this.stateValue,
    this.distValue,
    this.jobWorkCategory,
    this.jobWork,
  });

  // Convert from JSON (excluding Uint8List which is binary and not JSON-serializable directly)
  factory WorkerModal.fromJson(Map<String, dynamic> json) {
    return WorkerModal(
      workerName: json['workerName'] as String?,
      workerContat: json['workerContact'] as String?,
      address: json['address'] as String?,
      otherSkills: json['otherSkills'] as String?,
      selectedGender: json['selectedGender'] as String?,
      stateValue: json['stateValue'] as String?,
      distValue: json['distValue'] as String?,
      jobWorkCategory: json['jobWorkCategory'] as String?,
      jobWork: json['jobWork'] as String?,
      workerImage: json['workerImage'] as String,
    );
  }

  // Convert to JSON (excluding binary serialization)
  Map<String, dynamic> toJson() {
    return {
      'workerName': workerName,
      'workerContact':workerContat,
      'address': address,
      'otherSkills': otherSkills,
      'selectedGender': selectedGender,
      'stateValue': stateValue,
      'distValue': distValue,
      'jobWorkCategory': jobWorkCategory,
      'jobWork': jobWork,
      'workerImage': workerImage, // Convert Uint8List to List<int> for JSON
    };
  }
}
