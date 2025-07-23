import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/modals/userModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../modals/driver_modal.dart';
import '../../modals/shopModal.dart';
import '../../modals/worker_modal.dart';

class SearchController extends GetxController {
  RxList<AllUserModal> allResults = <AllUserModal>[].obs;

  // Future<void> searchKeywordInCollections(String keyword) async {
  //   final firestore = FirebaseFirestore.instance;
  //
  //   // Your collections to search in
  //   final List<String> collections = ['Shops', 'Workers', 'drivers'];
  //
  //   for (String collection in collections) {
  //     final snapshot = await firestore.collection(collection).get();
  //
  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       final category= (data[''] ?? '').toString().toLowerCase();
  //       final subcategory = (data['subcategory'] ?? '').toString().toLowerCase();
  //
  //       if (category.contains(keyword) || subcategory.contains(keyword)) {
  //         // allResults.add({
  //         //   ...data,
  //         //   'id': doc.id,
  //         //   'collection': collection,
  //         // });
  //         // allResults.add(AllUserModal(name: data[], contact: contact, type: type, id: id))
  //         convertModel(doc, collection);
  //       }
  //     }
  //   }
  //
  //   print('🔍 Total Matches: ${allResults.length}');
  //   // for (var item in allResults) {
  //   //   print(item);
  //   // }
  //
  //   // TODO: setState(() { resultList = allResults; }) to display
  // }

  // void convertModel(DocumentSnapshot doc, String collection) {
  //   final data = doc.data() as Map<String, dynamic>;
  //
  //   switch (collection) {
  //     case 'Shops':
  //       allResults.add(AllUserModal(
  //         name: data['shopName'] ?? 'Unnamed Shop',
  //         contact: data['shopContact'] ?? '',
  //         type: 'Shop',
  //         id: doc.id,
  //         image: data['shopImage'],
  //       ));
  //       break;
  // case
  //
  // '
  //
  // Workers
  //
  // '
  //
  //     :
  //
  // allResults.add
  //
  // (
  //
  // AllUserModal(
  // name: data['workerName'] ?? 'Unnamed Worker',
  // contact: data['workerContact'] ?? '',
  // type: 'Worker',
  // id: doc.id,
  // image: data['workerImage'],
  // ));
  // break;
  // case 'drivers':
  // allResults.add(AllUserModal(
  // name: data['driverName'] ?? 'Unnamed Driver',
  // contact: data['driverContact'] ?? '',
  // type: 'Driver',
  // id: doc.id,
  // image: data['driverImage'],
  // ));
  //       break;
  //   }
  // }

  Future<void> runSearch(String keyword) async {
    allResults.clear();
    final firestore = FirebaseFirestore.instance;
    final searchKey = keyword.toLowerCase();

    final shopSnapshot = await firestore.collection('Shops').get();

    for (var doc in shopSnapshot.docs) {
      final data = doc.data();
      final shop = ShopModal.fromJson(data);

      final matches =
          (shop.shopName?.toLowerCase().contains(searchKey) ?? false) ||
          (shop.shopCategorySet?.any(
                (cat) => cat.toLowerCase().contains(searchKey),
              ) ??
              false) ||
          (shop.shopSubcategoryMap?.values.any(
                (set) => set.any(
                  (subcat) => subcat.toLowerCase().contains(searchKey),
                ),
              ) ??
              false) ||
          (shop.aboutBusiness?.toLowerCase().contains(searchKey) ?? false);

      if (matches) {
        allResults.add(
          AllUserModal(
            name: data['shopName'] ?? 'Unnamed Shop',
            contact: data['shopContact'] ?? '',
            type: 'Shop',
            id: doc.id,
            image: data['shopImage'],
          ),
        );
      }
    }
    final workerSnapshot = await firestore.collection('Workers').get();

    for (var doc in workerSnapshot.docs) {
      final data = doc.data();
      final worker = WorkerModal.fromJson(data);

      final matches =
          (worker.workerName?.toLowerCase().contains(searchKey) ?? false) ||
              (worker.workType?.any(
                    (type) => type.toLowerCase().contains(searchKey),
              ) ??
                  false) ||
              (worker.otherSkills?.toLowerCase().contains(searchKey) ?? false);

      if (matches) {
        allResults.add(
          AllUserModal(
            name: data['workerName'] ?? 'Unnamed Worker',
            contact: data['workerContact'] ?? '',
            type: 'Worker',
            id: doc.id,
            image: data['workerImage'],
          ),
        );
      }
    }
    final snapshot = await firestore.collection('drivers').get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final driver = DriverModal.fromJson(data);

      final matches =
          (driver.driverName?.toLowerCase().contains(searchKey) ?? false) ||
              (driver.driverOtherSkill?.toLowerCase().contains(searchKey) ??
                  false) ||
              (driver.vehicleName?.toLowerCase().contains(searchKey) ?? false) ||
              (driver.vehicleNo?.toLowerCase().contains(searchKey) ?? false);

      if (matches) {
        allResults.add(
          AllUserModal(
            name: data['driverName'] ?? 'Unnamed Driver',
            contact: data['driverContact'] ?? '',
            type: 'Driver',
            id: doc.id,
            image: data['driverImage'],
          ),
        );
      }
    }

    print("mdbbdj ${allResults.length}");
  }
}
