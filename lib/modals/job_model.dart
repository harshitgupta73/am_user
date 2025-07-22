import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String jobId;
  final String? images;
  final String? video;
  final String? name;
  final Timestamp? createdAt;

  JobModel({
    required this.jobId,
    this.name,
    this.images,
    this.video,
    this.createdAt,
  });

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      jobId: id,
      name: map['name'] ?? '',
      images: map['images'] ?? '',
      video: map['video'] ?? '',
      createdAt: Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id":jobId,
      'name': name,
      'images': images,
      'video': video,
      'createdAt': createdAt,
    };
  }
}
