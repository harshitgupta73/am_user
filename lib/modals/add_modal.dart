import 'package:cloud_firestore/cloud_firestore.dart';

class AddModal {
  String? adId;
  String? adImage;        // Only one of adImage or adVideo should be used
  String? adVideo;
  String? adName;
  String? contactNo;
  bool? entireCountry;    // true = show ad across all of India
  List<String>? selectedStates;                         // e.g. ['Uttar Pradesh', 'Maharashtra']
  Map<String, List<String>>? selectedDistrictsPerState; // e.g. {'Uttar Pradesh': ['Lucknow', 'Noida'], 'Delhi': ['South Delhi']}
  Timestamp? startDate;
  int? durationDays; // Number of days after which ad should expire
  String? price;

  AddModal({
    this.adId,
    this.adImage,
    this.adVideo,
    this.adName,
    this.contactNo,
    this.entireCountry = false,
    this.selectedStates,
    this.selectedDistrictsPerState,
    this.startDate,
    this.durationDays,
    this.price,
  });

  factory AddModal.fromJson(Map<String, dynamic> json) {
    return AddModal(
      adId: json['adId'] as String?,
      adImage: json['adImage'] as String?,
      adVideo: json['adVideo'] as String?,
      adName: json['adName'] as String?,
      contactNo: json['contactNo'] as String?,
      entireCountry: json['entireCountry'] as bool? ?? false,
      selectedStates: (json['selectedStates'] as List<dynamic>?)?.cast<String>(),
      selectedDistrictsPerState: (json['selectedDistrictsPerState'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as List<dynamic>).cast<String>()),
      ),
      startDate: json['startDate'],
      durationDays: json['durationDays'] as int?,
      price: json['price'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adId': adId,
      'adImage': adImage,
      'adVideo': adVideo,
      'adName': adName,
      'contactNo': contactNo,
      'entireCountry': entireCountry,
      'selectedStates': selectedStates,
      'selectedDistrictsPerState': selectedDistrictsPerState,
      'startDate': startDate,
      'durationDays': durationDays,
      'price': price,
    };
  }

  /// Check if the ad is currently active
  bool isActive() {
    if (startDate == null || durationDays == null) return false;
    final expiryDate = startDate!.toDate().add(Duration(days: durationDays!));
    return DateTime.now().isBefore(expiryDate);
  }
}
