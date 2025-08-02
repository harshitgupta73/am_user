import 'package:am_user/controller/controllers.dart';
import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/modals/shopModal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../controller/user_provider/get_user_provider.dart';
import '../modals/driver_modal.dart';
import '../responsive/reponsive_layout.dart';
import '../widgets/utils/utils.dart';

class CardDetailsScreen extends StatefulWidget {
  final AllUserModal? users;

  const CardDetailsScreen({super.key, required this.users});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final controller = Get.find<Controller>();
  final userController = Get.find<GetUserController>();

  DriverModal? driver;
  WorkerModal? worker;
  ShopModal? shop;

  VideoPlayerController? _activeController;
  int? _activeIndex;
  bool isVideo = false;
  bool isPost = true;

  // Dummy data for videos & post

  final List<String> postImages = [
    'https://picsum.photos/id/1015/200/200',
    'https://picsum.photos/id/1016/200/200',
    'https://picsum.photos/id/1018/200/200',
    'https://picsum.photos/id/1020/200/200',
    'https://picsum.photos/id/1024/200/200',
    'https://picsum.photos/id/1027/200/200',
  ];

  @override
  void dispose() {
    _disposeActiveController();
    super.dispose();
  }

  void _disposeActiveController() {
    _activeController?.dispose();
    _activeController = null;
    _activeIndex = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final d = widget.users;
    if (d!.type == "Driver") {
      driver = controller.drivers.firstWhereOrNull((e) => e.driverId == d.id);
    } else if (d.type == "Worker") {
      worker = controller.workers.firstWhereOrNull((e) => e.workerId == d.id);
    } else if (d.type == "Shop") {
      shop = controller.shops.firstWhereOrNull((e) => e.shopId == d.id);
    }
    userController.getUserById(widget.users!.id);
  }

  Future<void> _initializeAndPlay(int index) async {
    _disposeActiveController();
    final url = userController.otherUser.value!.videos![index];
    final controller = VideoPlayerController.network(url);
    try {
      await controller.initialize();
      controller.play();
      setState(() {
        _activeController = controller;
        _activeIndex = index;
      });
    } catch (e) {
      debugPrint("Video init error: $e");
    }
  }

  Widget _buildVideoCard(int index) {
    final isActive = _activeIndex == index && _activeController != null;

    return GestureDetector(
      onTap: () {
        if (isActive) {
          setState(() {
            _activeController!.value.isPlaying
                ? _activeController!.pause()
                : _activeController!.play();
          });
        } else {
          _initializeAndPlay(index);
        }
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            isActive && _activeController!.value.isInitialized
                ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _activeController!.value.aspectRatio,
                      child: VideoPlayer(_activeController!),
                    ),
                    if (!_activeController!.value.isPlaying)
                      const Icon(
                        Icons.play_circle,
                        size: 60,
                        color: Colors.white,
                      ),
                  ],
                )
                : const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
  Widget _buildField(String label, dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        "$label: $value",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildImage(String? url, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 6),
        if (url != null && url.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(url, height: 120, width: double.infinity, fit: BoxFit.cover),
          )
        else
          const Text("No Image Available", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.users;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('${d!.type} Details')),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Info
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: d.image != null && d.image!.isNotEmpty
                      ? NetworkImage(d.image!)
                      : const AssetImage("assets/images/default_profile.png") as ImageProvider,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.name ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text("Contact: ${d.contact ?? '-'}", style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (d.type == "Shop" && shop != null) ...[
              _buildField("Proprietor", shop!.proprietorName),
              _buildField("Address", "${shop!.shopAddress}, ${shop!.distValue}, ${shop!.stateValue}"),
              _buildField("About Business", shop!.aboutBusiness),
              _buildField("Website", shop!.website),
              _buildField("Shop Item", shop!.shopItem),
              _buildField("Shop Type", shop!.shopType?.join(', ')),
              _buildField("Categories", shop!.shopCategorySet?.join(', ')),
              _buildField("Subcategories", shop!.shopSubcategoryMap?.entries.map((e) => "${e.key}: ${e.value.join(', ')}").join("\n")),
              _buildField("Working Hours", "${shop!.openingTime} - ${shop!.closingTime}"),
              _buildField("Working Days", shop!.days?.join(', ')),
            ],

            if (d.type == "Worker" && worker != null) ...[
              _buildField("Gender", worker!.selectedGender),
              _buildField("Address", "${worker!.address}, ${worker!.distValue}, ${worker!.stateValue}"),
              _buildField("Skills", worker!.otherSkills),
              _buildField("Work Types", worker!.workType?.join(', ')),
            ],

            if (d.type == "Driver" && driver != null) ...[
              _buildField("Email", driver!.email),
              _buildField("Licence No", driver!.driverLicenceNo),
              _buildField("Vehicle No", driver!.vehicleNo),
              _buildField("Vehicle Name", driver!.vehicleName),
              _buildField("Vehicle Owner", driver!.vehicleOwnerName),
              _buildField("Address", "${driver!.driverAddress}, ${driver!.distValue}, ${driver!.stateValue}"),
              _buildField("Other Skill", driver!.driverOtherSkill),
              const SizedBox(height: 16),
              _buildImage(driver!.vehicleRcImage, "Vehicle RC Image"),
              _buildImage(driver!.drivingLicence, "Driving Licence"),
            ],

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 📞 Call Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final phoneNumber = d.contact;
                      await Utils().dialNumber(phoneNumber, context);
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text("Call"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // 💬 Message Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                        '${RoutsName.chatScreen}?currentUserId=${userController.myUser!.userId!}&targetUserId=${d.id}&targetUserName=${Uri.encodeComponent(d.name)}',
                      );
                    },
                    icon: const Icon(Icons.message),
                    label: const Text("Message"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30, color: Colors.white54),

            // Toggle Tabs for Videos or Posts
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPost = true;
                        isVideo = false;
                        _disposeActiveController();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isPost ? Colors.white12 : Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Posts",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPost = false;
                        isVideo = true;
                        _disposeActiveController();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isVideo ? Colors.white12 : Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Videos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Obx(()
              =>userController.otherUser.value == null ? Center(child: CircularProgressIndicator(),): isVideo
                  ? (userController.otherUser.value!.videos != null &&
                          userController.otherUser.value!.videos!.isNotEmpty)
                      ? Column(
                        children: List.generate(
                          userController.otherUser.value!.videos!.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _buildVideoCard(index),
                            );
                          },
                        ),
                      )
                      : const Center(
                        child: Text(
                          "No videos available",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                  :userController.otherUser.value == null ? Center(child: CircularProgressIndicator(),): (userController.otherUser.value!.images != null &&
                      userController.otherUser.value!.images!.isNotEmpty)
                  ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userController.otherUser.value!.images!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          userController.otherUser.value!.images![index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                  : const Center(
                    child: Text(
                      "No images available",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

