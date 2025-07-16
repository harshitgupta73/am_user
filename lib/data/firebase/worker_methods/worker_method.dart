
import 'package:am_user/widgets/constants/firebse_const/string_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../modals/worker_modal.dart';

class WorkerMethod{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late CollectionReference _workerCollection ;

  WorkerMethod(){
    _workerCollection = firestore.collection(workerCollection);
  }

  Future<List<WorkerModal>> getAllWorkers() async {
    try {
      final snapshot = await firestore.collection(workerCollection).get();
      List<WorkerModal> workerList = snapshot.docs
          .map((doc) => WorkerModal.fromJson(doc.data()))
          .toList();
      return workerList;
    } catch (e) {
      print("Error fetching shops: $e");
      return [];
    }
  }


  Future<void> createWorker(WorkerModal worker) async {
    try {
      await _workerCollection.add(worker.toJson());
      debugPrint('✅ Worker created with ID: ${worker.workerName}');
    } catch (e) {
      debugPrint('❌ Error creating worker: $e');
    }
  }

  Future<WorkerModal?> getWorkerById(String workerId) async {
    try {
      final doc = await _workerCollection.doc(workerId).get();
      if (doc.exists) {
        debugPrint('✅ Worker data fetched for ID: $workerId');
        return WorkerModal.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        debugPrint('⚠️ Worker not found for ID: $workerId');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error fetching worker: $e');
      return null;
    }
  }

  Future<void> updateWorker(WorkerModal worker, String workerId) async {
    try {
      await _workerCollection.doc(workerId).update(worker.toJson());
      debugPrint('✅ Worker updated with ID: $workerId');
    } catch (e) {
      debugPrint('❌ Error updating worker: $e');
    }
  }



}