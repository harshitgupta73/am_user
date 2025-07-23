import 'package:am_user/controller/user_provider/get_user_provider.dart';
import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/modals/shopModal.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controller/controllers.dart';
import '../widgets/routs/routs.dart';

class SelectedUserScreen extends StatefulWidget {
  const SelectedUserScreen({super.key});

  @override
  State<SelectedUserScreen> createState() => _SelectedUserScreenState();
}

class _SelectedUserScreenState extends State<SelectedUserScreen> {
  final controller = Get.find<Controller>();
  final userController = Get.find<GetUserController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchDataBasedOnSelection();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("User",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.option.value == "drivers") {
          return buildDriverList();
        } else if (controller.option.value == "Workers") {
          return buildWorkerList();
        } else if (controller.option.value == "Shops") {
          return buildShopList();
        } else {
          return const Center(child: Text("No option selected", style: TextStyle(color: Colors.white)));
        }
      }),
    );
  }

  Widget buildDriverList() {
    return ListView.builder(
      itemCount: controller.drivers.length,
      itemBuilder: (context, index) {
        final driver = controller.drivers[index];
        return GestureDetector(
          onTap: (){
            context.go(
              '${RoutsName.cardDetailScreen}',
              extra: AllUserModal(name: driver.driverName!, contact: driver.driverContact!, image: driver.driverImage!, type: 'Driver', id: driver.driverId!)
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: driver.driverImage != null
                  ? NetworkImage(driver.driverImage!)
                  : const AssetImage("assets/driver_placeholder.png") as ImageProvider,
            ),
            title: Text(driver.driverName ?? '', style: const TextStyle(color: Colors.black)),
            subtitle: Text(driver.driverContact ?? '', style: const TextStyle(color: Colors.grey)),
          ),
        );
      },
    );
  }

  Widget buildWorkerList() {
    final filtered = controller.workerList;

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final worker = filtered[index];
        return GestureDetector(
          onTap: () {
            context.go(
              '${RoutsName.cardDetailScreen}',
              extra: AllUserModal(name: worker.workerName!, contact: worker.workerContat!, image: worker.workerImage!, type: "Worker", id: worker.workerId!)
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: worker.workerImage != null
                  ? NetworkImage(worker.workerImage!)
                  : const AssetImage("assets/worker_placeholder.png") as ImageProvider,
            ),
            title: Text(worker.workerName ?? '', style: const TextStyle(color: Colors.black)),
            subtitle: Text(worker.workerContat ?? '', style: const TextStyle(color: Colors.grey)),
          ),
        );
      },
    );
  }

  Widget buildShopList() {
    final filtered = controller.shopList;

    return filtered.length==0 ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text("No shop available according to your category and subcategory",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
    ) : ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final shop = filtered[index];
        return shopCard(shop);
      },
    );
  }

  Widget shopCard(ShopModal shop){
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                context.go(
                  '${RoutsName.cardDetailScreen}',
                  extra: AllUserModal(name: shop.shopName!, contact: shop.contactNo!, image: shop.shopImage!, type: "Shop", id: shop.shopId!)
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: shop.shopImage != null
                        ? NetworkImage(shop.shopImage!)
                        : const AssetImage("assets/shop_placeholder.png") as ImageProvider,
                  ),
                  const SizedBox(width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Shop : ${shop.shopName}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      Text("Proprietor Name : ${shop.proprietorName}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      Text("Contact : ${shop.contactNo}", style: const TextStyle(color: Colors.black)),
                      Text("${shop.shopAddress!}, ${shop.distValue}, ${shop.stateValue}", style: const TextStyle(color: Colors.black)),
                      Text("Working hour : ${shop.openingTime}-${shop.closingTime}", style: const TextStyle(color: Colors.black)),
                      Text("Working days : ${shop.days!.join(", ")}", style: const TextStyle(color: Colors.black)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 📞 Call Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // final phoneNumber = shop.contactNo;
                      // if (phoneNumber != null && phoneNumber.isNotEmpty) {
                      //   final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
                      //   if (await canLaunchUrl(launchUri)) {
                      //     await launchUrl(launchUri);
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(content: Text("Cannot launch dialer")),
                      //     );
                      //   }
                      // }
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text("Call"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                // 💬 Message Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // final currentUserId = controller.currentUser.id; // Replace appropriately
                      // final targetUserId = widget.users.id;
                      // final targetUserName = widget.users.name ?? '';
                      //
                      // Get.to(() => ChatPage(
                      //   currentUserId: currentUserId,
                      //   targetUserId: targetUserId,
                      //   targetUserName: targetUserName,
                      // ));
                      context.go(
                        '${RoutsName.chatScreen}?currentUserId=${userController.myUser!.userId!}&targetUserId=${shop.shopId}&targetUserName=${Uri.encodeComponent(shop.shopName!)}',
                      );
                    },
                    icon: const Icon(Icons.message),
                    label: const Text("Message"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ]
      ),
    ));
  }
}
