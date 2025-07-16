class ShopModal {
  String? shopName;
  String? proprietorName;
  String? contactNo;
  String? shopAddress;
  String? shopItem;
  String? shopImage;
  String? selectedGender;
  String? stateValue;
  String? distValue;

  ShopModal({
    this.shopName,
    this.proprietorName,
    this.contactNo,
    this.shopAddress,
    this.shopItem,
    this.shopImage,
    this.selectedGender,
    this.stateValue,
    this.distValue,
  });

  // Create a ShopModal from a JSON map
  factory ShopModal.fromJson(Map<String, dynamic> json) {
    return ShopModal(
      shopName: json['shopName'] as String?,
      proprietorName: json['proprietorName'] as String?,
      contactNo: json['contactNo'] as String?,
      shopAddress: json['shopAddress'] as String?,
      shopItem: json['shopItem'] as String?,
      shopImage: json['shopImage'] as String?,
      selectedGender: json['selectedGender'] as String?,
      stateValue: json['stateValue'] as String?,
      distValue: json['distValue'] as String?,
    );
  }

  // Convert ShopModal to JSON map
  Map<String, dynamic> toJson() {
    return {
      'shopName': shopName,
      'proprietorName': proprietorName,
      'contactNo': contactNo,
      'shopAddress': shopAddress,
      'shopItem': shopItem,
      'shopImage': shopImage,
      'selectedGender': selectedGender,
      'stateValue': stateValue,
      'distValue': distValue,
    };
  }
}
