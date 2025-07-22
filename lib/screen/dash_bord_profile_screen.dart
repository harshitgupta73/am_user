import 'package:am_user/controller/user_provider/get_user_provider.dart';
import 'package:am_user/widgets/component/reel_conatiner.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../data/shareprefrance/shareprefrance.dart';
import '../modals/userModal.dart';
import '../widgets/routs/routs.dart';
import 'full_screen_video_play.dart';

class DashBordScreen extends StatefulWidget {
  const DashBordScreen({super.key});

  @override
  State<DashBordScreen> createState() => _DashBordScreenState();
}

class _DashBordScreenState extends State<DashBordScreen> {
  final userController = Get.find<GetUserController>();
  bool isVideo = false;
  bool isPost = false;

  final String profileImage =
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fHww";

  String selectedLanguage = 'English'; // Default language

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600; // simple check

    // if (userController.myUser == null ||
    //     userController.myUser!.images == null ||
    //     userController.myUser!.videos == null) {
    //   return Scaffold(
    //     backgroundColor: backgroundColor,
    //     body: const Center(
    //       child: CircularProgressIndicator(color: Colors.redAccent),
    //     ),
    //   );
    // }

    // if(userController.shopModal.value != null){
    //   return Text("Shop exist");
    // }else if(userController.driverModal.value != null){
    //   return Text("Driver exist");
    // }else if(userController.workerModal.value != null){
    //   return Text("Worker exist");
    // }
    // return Container(
    //   child: Text("user type"),
    // );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          isMobile
              ? AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () {
                      context.go(RoutsName.addPostScreen);
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                  // Popup Menu
                  PopupMenuButton<String>(
                    iconColor: Colors.white,
                    onSelected: (value) {
                      _handleMenuAction(value, context);
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Language',
                          child: Row(
                            children: [
                              Icon(Icons.language, color: Colors.black),
                              SizedBox(width: 10),
                              Text('Language: $selectedLanguage'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Row(
                            children: [
                              Icon(Icons.exit_to_app, color: Colors.black),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Logout',
                          child: Row(
                            children: [
                              Icon(Icons.exit_to_app, color: Colors.black),
                              SizedBox(width: 10),
                              Text('Logout'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              )
              : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        userController.myUser!.images != null
                            ? _buildStat(
                              "Posts",
                              userController.myUser!.images!.length.toString(),
                            )
                            : _buildStat("Posts", 0.toString()),
                        userController.myUser!.videos != null
                            ? _buildStat(
                              "Videos",
                              userController.myUser!.videos!.length.toString(),
                            )
                            : _buildStat("Videos", 0.toString()),
                        _buildStat("Rating", "4.9"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Username & Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userController.myUser!.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: customTextColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "This is a funny guy's profile 🤪",
                      style: TextStyle(color: customTextColor),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Post/Video Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      isPost = !isPost;
                      isVideo = false;
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: customTextColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Post",
                        style: TextStyle(color:customTextColor),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      isPost = false;
                      isVideo = !isVideo;
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Videos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Divider(),

            // Post Grid or Videos
            Obx(() {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      isVideo
                          ? userController.myUser!.videos != null ? userController.myUser!.videos!.length : 0
                          : userController.myUser!.images != null ? userController.myUser!.images!.length : 0,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return isVideo
                        ? InkWell(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ReelsStyleVideoPlayer(
                                        videoUrl:
                                            userController
                                                .myUser!
                                                .videos![index],
                                      ),
                                ),
                              ),
                          child: ReelContainer(
                            videoUrl: userController.myUser!.videos![index],
                          ),
                        )
                        : userController.isLoading.value
                        ? Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        )
                        : Image.network(
                          userController.myUser!.images![index],
                          fit: BoxFit.cover,
                        );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Handle Popup Menu Action
  void _handleMenuAction(String value, BuildContext context) {
    switch (value) {
      case 'Language':
        _showLanguageDialog(context);
        break;
      case 'Logout':
        _logout(context);
      case 'Edit':
        _logout(context);
        break;
    }
  }

  // Logout Function
  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // Show Language Dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    selectedLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Hindi'),
                onTap: () {
                  setState(() {
                    selectedLanguage = 'Hindi';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Spanish'),
                onTap: () {
                  setState(() {
                    selectedLanguage = 'Spanish';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: customTextColor,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: customTextColor)),
      ],
    );
  }
}
