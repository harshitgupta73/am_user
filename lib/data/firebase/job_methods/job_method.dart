import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../modals/job_model.dart';

class JobMethods {
  final CollectionReference jobCollection =
  FirebaseFirestore.instance.collection('Jobs');
  Future<void> addJob(JobModel job) async {
    try {
      await jobCollection.doc(job.jobId).set(job.toMap());
      print('Job added successfully!');
    } catch (e) {
      print('Error adding job: $e');
      rethrow;
    }
  }

  /// Get all jobs from Firestore
  Future<List<JobModel>> getAllJobs() async {
    try {
      final snapshot = await jobCollection.orderBy('createdAt', descending: true).get();
      return snapshot.docs
          .map((doc) => JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching jobs: $e');
      rethrow;
    }
  }
}