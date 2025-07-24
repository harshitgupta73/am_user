class AllUserModal {
  final String name;
  final String contact;
  final String type;
  final String id;// "Shop", "Driver", or "Worker"
  final String? image;
  final double? distance;

  AllUserModal({
    required this.name,
    required this.contact,
    required this.type,
    required this.id,
    this.image,
    this.distance,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
      'type': type,
      'id': id,
      'image': image,
      'distance': distance,
    };
  }

}
