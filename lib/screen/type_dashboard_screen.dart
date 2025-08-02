import 'package:am_user/data/firebase/user/user_insert_update.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../controller/user_provider/get_user_provider.dart';
import '../modals/driver_modal.dart';
import '../modals/shopModal.dart';
import '../modals/worker_modal.dart';
import '../responsive/reponsive_layout.dart';
import '../widgets/component/reel_conatiner.dart';
import '../widgets/constants/const.dart';
import '../widgets/routs/routs.dart';
import 'full_screen_video_play.dart';

class TypeDashboardScreen extends StatefulWidget {
  const TypeDashboardScreen({super.key});

  @override
  State<TypeDashboardScreen> createState() => _TypeDashboardScreenState();
}

class _TypeDashboardScreenState extends State<TypeDashboardScreen> {
  final userController = Get.find<GetUserController>();
  VideoPlayerController? _activeController;
  int? _activeIndex;
  bool isVideo = false;
  bool isPost = true;

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
    userController.loadUserFromFirestore();
  }
  DriverModal? driver;
  WorkerModal? worker;
  ShopModal? shop;

  @override
  Widget build(BuildContext context) {
    String type = "";
    if (userController.shopModal.value != null) {
      type = 'Shop';
      shop=userController.shopModal.value;
    } else if (userController.driverModal.value != null) {
      type = 'Driver';
      driver=userController.driverModal.value;
    } else if (userController.workerModal.value != null) {
      type = 'Worker';
      worker=userController.workerModal.value;
    } else {
      type = 'user';
    }
    final size = MediaQuery
        .of(context)
        .size;
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTab(context);
    final isMobile = !isDesktop && !isTablet;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${type} Details', style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              onPressed: () async {
                context.push(RoutsName.addPostScreen);
              },
              icon: Icon(Icons.add, color: Colors.white),
            ),
            IconButton(
              onPressed: () async {
                type == "Shop"
                    ? context.push(RoutsName.shopRegisterScreen)
                    : type == "Driver" ? context.push(
                    RoutsName.driverRegisterScreen) : context.push(
                    RoutsName.workRegisterScreen);
              },
              icon: Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Driver Info
                  if (type == "Shop" && shop != null) ...[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(shop!.shopImage!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shop!.shopName ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              Text("Contact: ${shop!.contactNo ?? '-'}", style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),
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

                  if (type == "Worker" && worker != null) ...[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(worker!.workerImage!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(worker!.workerName ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              Text("Contact: ${worker!.workerContat ?? '-'}", style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _buildField("Gender", worker!.selectedGender),
                    _buildField("Address", "${worker!.address}, ${worker!.distValue}, ${worker!.stateValue}"),
                    _buildField("Skills", worker!.otherSkills),
                    _buildField("Work Types", worker!.workType?.join(', ')),
                  ],

                  if (type == "Driver" && driver != null) ...[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(driver!.driverImage!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(driver!.driverName ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              Text("Contact: ${driver!.driverContact?? '-'}", style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                  const Divider(height: 30, color: Colors.black54),

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
                              color: isPost ? Colors.white12 : Colors
                                  .transparent,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Photos",
                              style: TextStyle(color: Colors.black),
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
                              color: isVideo ? Colors.white12 : Colors
                                  .transparent,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Videos",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Show Posts or Videos
                  Obx(() {
                    final isLoading = userController.isLoading.value;
                    final user = userController.myUser;

                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }

                    if (user == null) {
                      return const Center(
                          child: Text("User data not available"));
                    }

                    // Media list based on type
                    final mediaList = isVideo ? user.videos : user.images;

                    if (mediaList == null || mediaList.isEmpty) {
                      return Center(
                        child: Text(
                          isVideo
                              ? "No videos available"
                              : "No images available",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: mediaList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          return isVideo
                              ? InkWell(
                            onTap:
                                () =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                        ReelsStyleVideoPlayer(
                                          videoUrl: mediaList[index],
                                        ),
                                  ),
                                ),
                            child: InkWell(onLongPress:(){
                              showDialogWidget(url: mediaList[index],isImage: false);
                            },child: ReelContainer(videoUrl: mediaList[index])),
                          )
                              : userController.isLoading.value
                              ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                              : InkWell(onLongPress: () {
                            showDialogWidget(url: mediaList[index],isImage: true);
                          },
                              child: Image.network(
                                  mediaList[index], fit: BoxFit.cover));
                        },
                      ),
                    );
                  }),
                ],
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
        style: const TextStyle(color: Colors.black),
      ),
    );
  }


  Widget _buildImage(String? url, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        if (url != null && url.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else
          const Text(
            "No Image Available",
            style: TextStyle(color: Colors.white),
          ),
        const SizedBox(height: 12),
      ],
    );
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

  Future<void> _initializeAndPlay(int index) async {
    _disposeActiveController();
    final url = videos[index];
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

  void showDialogWidget({
    required String url, required bool isImage
  }) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Delete'),
        content: Text('Are you sure you want to delete this?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text('Cancel')),
          TextButton(onPressed: () async {
            print("userid = ${FirebaseAuth.instance.currentUser!.uid} url = $url isimage = $isImage");
            await UserMethod().deleteMediaFromUserDoc(
                userId: FirebaseAuth.instance.currentUser!.uid, url: url, isImage:isImage);
            await userController.getUser();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Media deleted successfully'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(10),
              ),
            );
            Navigator.pop(context);
          }, child: Text('Delete'))
        ],
      );
    });
  }
}