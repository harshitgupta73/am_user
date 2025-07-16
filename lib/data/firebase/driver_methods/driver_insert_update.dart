import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../modals/driver_modal.dart';

class DriverMethods{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> insertDriver(DriverModal driver) async {
    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          // .doc(docId)
          .add(driver.toJson());
      print('Driver inserted successfully');
    } catch (e) {
      print('Insert failed: $e');
      rethrow;
    }
  }


  Future<void> updateDriver(DriverModal driver, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(docId)
          .update(driver.toJson());
      print('Driver updated successfully');
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        print('Driver not found for update');
      } else {
        print('Update failed: $e');
      }
      rethrow;
    }
  }

  Future<List<DriverModal>> getAllDrivers() async {
    try {
      final snapshot = await _firestore.collection('drivers').get();
      List<DriverModal> driverList = snapshot.docs
          .map((doc) => DriverModal.fromJson(doc.data()))
          .toList();
      return driverList;
    } catch (e) {
      print("Error fetching shops: $e");
      return [];
    }
  }



  Future<DriverModal?> getDriverById(String driverId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .get();

      if (doc.exists) {
        return DriverModal.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('Driver not found for ID: $driverId');
        return null;
      }
    } catch (e) {
      print('Error fetching driver by ID: $e');
      return null;
    }
  }


  Future<DriverModal?> getDriverByVehicleNo(String vehicleNo) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .where('vehicleNo', isEqualTo: vehicleNo)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return DriverModal.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('No driver found with vehicleNo: $vehicleNo');
        return null;
      }
    } catch (e) {
      print('Error fetching driver by vehicle number: $e');
      return null;
    }
  }



}