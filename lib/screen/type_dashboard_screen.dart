import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../controller/user_provider/get_user_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    String type = "";
    if (userController.shopModal.value != null) {
      type = 'Shop';
    } else if (userController.driverModal.value != null) {
      type = 'Driver';
    } else if (userController.workerModal.value != null) {
      type = 'Worker';
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
                context.go(RoutsName.addPostScreen);
              },
              icon: Icon(Icons.add, color: Colors.white),
            ),
            IconButton(
              onPressed: () async {
                type == "Shop" ? context.go(RoutsName.shopRegisterScreen) : type == "Driver" ? context.go(RoutsName.driverRegisterScreen) : context.go(RoutsName.workRegisterScreen);
              },
              icon: Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx( () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        type == 'Shop'
                            ? userController.shopModal.value!.shopImage ?? ''
                            : type == 'Driver'
                            ? userController.driverModal.value!.driverImage ?? ''
                            : userController.workerModal.value!.workerImage ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type == 'Shop'
                                ? userController.shopModal.value!.shopName ?? ''
                                : type == 'Driver'
                                ? userController.driverModal.value!.driverName ??
                                ''
                                : userController.workerModal.value!.workerName ??
                                '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Contact: ${userController.shopModal.value!.contactNo}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            type == 'Shop'
                                ? "Shop"
                                : type == "Driver"
                                ? "Driver"
                                : "Worker",
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            userController.myUser!.email!,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            type == 'Shop'
                                ? userController.shopModal.value!.shopAddress ??
                                ''
                                : type == 'Driver'
                                ? userController
                                .driverModal
                                .value!
                                .driverAddress ??
                                ''
                                : userController.workerModal.value!.address ?? '',
                            style: const TextStyle(color: Colors.black),
                          ),
                          type == "Shop"
                              ? Text(
                            "Shop timing: ${userController.shopModal.value!
                                .openingTime}-${userController.shopModal.value!
                                .closingTime}",
                            style: TextStyle(color: Colors.black),
                          )
                              : Container(height: 0),
                          type == "Shop" &&
                              userController.shopModal.value?.days != null &&
                              userController.shopModal.value!.days!.isNotEmpty
                              ? Text(
                            "Opening days: ${userController.shopModal.value!.days!
                                .join(', ')}",
                            style: const TextStyle(color: Colors.black),
                          )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                type == "Driver"
                    ? _buildImage(
                  userController.driverModal.value!.drivingLicence,
                  "Driving Licence",
                )
                    : SizedBox(height: 0),
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
                            color: isPost ? Colors.white12 : Colors.transparent,
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
                            color: isVideo ? Colors.white12 : Colors.transparent,
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
                    return const Center(child: Text("User data not available"));
                  }

                  // Media list based on type
                  final mediaList = isVideo ? user.videos : user.images;

                  if (mediaList == null || mediaList.isEmpty) {
                    return Center(
                      child: Text(
                        isVideo ? "No videos available" : "No images available",
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
                          child: ReelContainer(videoUrl: mediaList[index]),
                        )
                            : userController.isLoading.value
                            ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                            : Image.network(mediaList[index], fit: BoxFit.cover);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
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
}
