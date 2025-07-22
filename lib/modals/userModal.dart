class UserModal {
  final String? userId;
  final String? email;
  final String? contact;
  final String? name;
  final String? image;

  final List<String>? images;
  final List<String>? videos;

  const UserModal({
    this.userId,
    this.email,
    this.contact,
    this.name,
    this.image,
    this.images,
    this.videos,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'Email': email,
      'Contact': contact,
      'Name': name,
      'Image': image,
      'Images': images,
      'Videos': videos,
    };
  }

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
      userId: json['userId']?.toString(),
      email: json['Email'] as String?,
      contact: json['Contact'] as String?,
      name: json['Name'] as String?,
      image: json['Image'] as String?,
      images: (json['Images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      videos: (json['Videos'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  @override
  String toString() {
    return 'UserModal(name: $name, email: $email)';
  }
}
