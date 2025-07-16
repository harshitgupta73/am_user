class AllUserModal {
  final String name;
  final String contact;
  final String type;
  final String id;// "Shop", "Driver", or "Worker"
  final String? image;

  AllUserModal({
    required this.name,
    required this.contact,
    required this.type,
    required this.id,
    this.image,
  });
}
