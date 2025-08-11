import 'dart:convert';
import 'dart:io';

import 'package:am_user/business_categories/business_type.dart';
import 'package:am_user/controller/user_provider/get_user_provider.dart';
import 'package:am_user/modals/userModal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:am_user/responsive/reponsive_layout.dart';
import 'package:am_user/screen/card_deatils_csreen.dart';
import 'package:am_user/widgets/common_methods.dart';
import 'package:am_user/widgets/component/banner_image.dart';
import 'package:am_user/widgets/component/list_deatils_card_for_web.dart';
import 'package:am_user/widgets/component/searchBar.dart';
import 'package:am_user/widgets/component/video_player_screen.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/ad_controller/ad_controller.dart';
import '../controller/controllers.dart';
import '../data/shareprefrance/shareprefrance.dart';
import '../modals/driver_modal.dart';
import '../widgets/constants/login_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SharePreferencesMethods _sharePreferencesMethods =
      SharePreferencesMethods();
  final userController = Get.find<GetUserController>();
  final adController = Get.find<AdController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  List<dynamic> _filterList = [];

  final TextEditingController _searchController = TextEditingController();

  // UserModal? userModal;

  final slider = [
    BannerImageWidget(),
    BannerImageWidget(),
    BannerImageWidget(),
    BannerImageWidget(),
    BannerImageWidget(),
    BannerImageWidget(),
  ];

  List<WorkerModal> workers = [];

  getUserData() async {
    UserModal? cachedData =
        await _sharePreferencesMethods.loadUserFromSharedPref();
    if (cachedData != null) {
      // userModal = cachedData;
      userController.setMyUser(cachedData);
      print("user = ${userController.myUser!.toJson()}");

      // print('user casged = ${userModal!.toJson()}');
    }
    await userController.getUser();
    // userModal = userController.myUser;
    print("user = ${userController.myUser!.name}");
    if (userController.myUser != null) {
      _sharePreferencesMethods.saveUserToSharedPref(userController.myUser!);

    }
  }
getuserOnTheLoad()async{
    await getUserData();
    fun();
}
  String screen = "";
  String? type;
  String? userImage;
  String? name;
  String? contact;

  void fun() {

    if (userController.shopModal.value != null){
      type="Shop";
      screen = 'type_dashboard';
      userImage= userController.shopModal.value!.shopImage;
      name= userController.shopModal.value!.shopName;
      contact= userController.shopModal.value!.contactNo;
    }
    else if (userController.workerModal.value != null){
      type="Worker";
      screen = 'type_dashboard';
      userImage= userController.workerModal.value!.workerImage;
      name= userController.workerModal.value!.workerName;
      contact= userController.workerModal.value!.workerContat;
    }
    else if (userController.driverModal.value != null){
      type="Driver";
      screen = 'type_dashboard';
      userImage= userController.driverModal.value!.driverImage;
      name= userController.driverModal.value!.driverName;
      contact= userController.driverModal.value!.driverContact;
    }
    else if(userController.myUser != null){
      screen = 'user_dashboard';
      type="User";
      userImage= userController.myUser!.image;
      name= userController.myUser!.name;
      contact= userController.myUser!.contact;
      print("myuser = ${userController.myUser!.toJson()}");
    }
    setState(() {

    });
    print("type = $type");
  }

  @override
  void initState() {
    super.initState();
    getuserOnTheLoad();


    if (!Platform.isAndroid) {
      print("object");
    }
    adController.fetchAds();
    // _searchController.addListener(_onChange);

  }

  final controller = Get.put(Controller());

  navigateToProfileScreen(UserModal user) {
    if (!isSkiaWeb) {
      context.go(RoutsName.profileScreen, extra: user);
    } else {
      context.push(RoutsName.profileScreen, extra: user);
    }
  }
  bool isVideo = false;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // status bar background
        statusBarIconBrightness: Brightness.dark, // icons: time, battery
      ),
    );
    // print(controller.allUsers.length);
    return Scaffold(
      backgroundColor: backgroundColor,
      body:
          Obx(() => userController.myUser == null
              ? Center(child: CircularProgressIndicator())
              : Column(
            children: [
              SizedBox(height: Responsive.isMobile(context) ? 10 : 30),
              SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 10),
                bottom: true,
                child: Row(
                  crossAxisAlignment:
                  Responsive.isDesktop(context)
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // navigateToProfileScreen(userModal);
                        screen == "user_dashboard"
                            ? customNavigate(context,RoutsName.profileScreen,null)
                            : customNavigate(context,RoutsName.typeDashboard,null);
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                        userImage == null ? AssetImage('assets/images/amuser.jpeg') :NetworkImage(userImage!),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex:
                      Responsive.isMobile(context) ||
                          Responsive.isTab(context)
                          ? 4
                          : 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            name ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            stepGranularity: 0.1,
                            minFontSize: 18,
                          ),
                          AutoSizeText(
                            contact ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            stepGranularity: 0.1,
                            minFontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    if (Responsive.isDesktop(context) ||
                        Responsive.isTab(context))
                      Expanded(
                        flex: 10,
                        child: CustomSearchbar(
                          onTap: () {
                            int index = 1;
                            context.push(
                              "${RoutsName.bottomNavigation}/$index",
                            );
                          },
                          controller: _searchController,
                          label: "Search here",
                        ),
                      ),
                    IconButton(
                      onPressed: () {
                        //context.push(RoutsName.allChats, extra: workers);
                        SharePlus.instance.share(
                          ShareParams(
                            text:
                            'check out my website https://example.com',
                          ),
                        );
                      },
                      icon: Icon(Icons.share, color: Colors.green),
                      color: customTextColor,
                    ),
                    popUpMenu(),
                    // IconButton(
                    //   icon: const Icon(Icons.menu),
                    //   onPressed: () {
                    //     _scaffoldKey.currentState?.openEndDrawer();
                    //   },
                    // ),
                  ],
                ),
              ),
              Obx(
                    () =>
                adController.ads.isNotEmpty
                    ? Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: double.infinity,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      aspectRatio: 16 / 9,
                      autoPlayInterval: Duration(seconds: 10),
                    ),
                    items:
                    adController.ads.map((ad) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Card(
                            elevation: 4,
                            child: Column(
                              children: [
                                if (ad.adImage != null)
                                  Expanded(
                                    child: Image.network(
                                      ad.adImage!,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                    ),
                                  ),
                                if (ad.adVideo != null)
                                  Expanded(child: VideoThumbnailPlayer(videoUrl: ad.adVideo!))
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                )
                    : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (Responsive.isMobile(context)) CustomSearchbar(
                        //   controller: _searchController,
                        //   label: "Search here",
                        //   onTap: () {
                        //     int index = 1;
                        //     context.push(RoutsName.searchScreen);
                        //   },
                        // ),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: 10),

                        CarouselSlider(
                          items: slider,
                          options: CarouselOptions(
                            height:
                            Responsive.isDesktop(context)
                                ? 600
                                : Responsive.isTab(context)
                                ? 300
                                : 200,

                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(
                              milliseconds: 800,
                            ),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            // onPageChanged: (index, reason) {
                            //   setState(() {
                            //     _currentIndex = index;
                            //   });
                            // },
                          ),
                        ),

                        SizedBox(height: 10),

                        // Dots Indicator
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children:
                          slider.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap:
                                  () => setState(
                                    () =>
                                _currentIndex =
                                    entry.key,
                              ),
                              child: Container(
                                width:
                                _currentIndex == entry.key
                                    ? 12.0
                                    : 8.0,
                                height:
                                _currentIndex == entry.key
                                    ? 12.0
                                    : 8.0,
                                margin: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                  _currentIndex == entry.key
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: AutoSizeText(
                            "Recommended Services",
                            minFontSize: 20,
                            maxLines: 1,
                            maxFontSize: 34,
                            style: TextStyle(
                              color: customTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                              Responsive.isDesktop(context)
                                  ? 34
                                  : 24,
                              shadows: [
                                BoxShadow(
                                  color: Colors.orange,
                                  offset: Offset(-1, 2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Obx(
                              () =>
                          controller.isLoading.value
                              ? Center(
                            child:
                            CircularProgressIndicator(),
                          )
                              : GridView.builder(
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemCount:
                            controller.allUsers.length,
                            shrinkWrap: true,
                            padding:
                            Responsive.isMobile(context)
                                ? EdgeInsets.zero
                                : EdgeInsets.all(20),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                              Responsive.isMobile(
                                context,
                              )
                                  ? 1
                                  : 2,
                              crossAxisSpacing:
                              Responsive.isMobile(
                                context,
                              )
                                  ? 0
                                  : 10,
                              mainAxisSpacing:
                              Responsive.isMobile(
                                context,
                              )
                                  ? 0
                                  : 10,
                              childAspectRatio:
                              Responsive.isDesktop(
                                context,
                              )
                                  ? 20 / 5
                                  : Responsive.isMobile(
                                context,
                              )
                                  ? 14 / 5
                                  : 15 / 5,
                            ),
                            itemBuilder: (context, index) {
                              final users =
                              controller
                                  .allUsers[index];
                              print(
                                "users = ${users.name}",
                              );
                              return InkWell(
                                onTap: () {
                                  if (kIsWeb) {
                                    // context.push("${RoutsName.cardDetailScreen}?userData=$driver");
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            CardDetailsScreen(
                                              users:
                                              users,
                                            ),
                                      ),
                                    );
                                  }
                                },
                                child:
                                ListDetailsCardForWeb(
                                  id: users.id,
                                  work: users.type,
                                  image: users.image,
                                  name: users.name,
                                  contact:
                                  users.contact,
                                  distance:
                                  users.distance,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ) ,)

    );
  }


  void showMainCategoryMenu(context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      color: Colors.blue,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items:
          Provider().business_category.keys
              .map(
                (main) => PopupMenuItem<String>(value: main, child: Text(main)),
              )
              .toList(),
    ).then((selectedMainCategory) {
      if (selectedMainCategory != null) {
        final subCategories =
            Provider().business_category[selectedMainCategory]!;
        final newPos = Offset(
          position.dx + 200,
          position.dy,
        ); // adjust as needed
        controller.selectedCategory.value = selectedMainCategory;
        showSubCategoriesMenu(context, newPos, subCategories);
      }
    });
  }

  void showWorkerTypeMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      color: Colors.blue,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items:
      Provider().worker_type
          .map((sub) => PopupMenuItem<String>(value: sub, child: Text(sub)))
          .toList(),
    ).then((value) {
      if (value != null) {
        controller.selectedWorkerType.value = value;
        context.push(RoutsName.selectedUsers);
      }
    });
  }


  void showSubCategoriesMenu(
    BuildContext context,
    Offset position,
    List<String> subCategories,
  ) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      color: Colors.blue,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items:
          subCategories
              .map((sub) => PopupMenuItem<String>(value: sub, child: Text(sub)))
              .toList(),
    ).then((value) {
      if (value != null) {
        controller.selectedSubCategory.value = value;
        context.push(RoutsName.selectedUsers);
      }
    });
  }

  Widget popUpMenu() {
    return PopupMenuButton(
      color: backgroundColor,
      icon: Icon(Icons.menu, color: Colors.black),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: GestureDetector(
              onTapDown: (details) {
                controller.option.value = "Shops";// close current popup
                showMainCategoryMenu(context, details.globalPosition);
              },
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/104a911c63dcaf4814ee6136c5825d5b.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Business & Shop",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem(

            child: GestureDetector(
              onTapDown: (details) {
                controller.option.value="Workers";
                showWorkerTypeMenu(context,details.globalPosition );
              },
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),

                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/d50eb623382d5c7483cca89cc13582f7.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Worker",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem(
            onTap: () {
              controller.option.value="drivers";
              context.push(RoutsName.selectedUsers);
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),

                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/ffeab1a8e03347dba1cf79d32d055309.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text("Vehicle", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () {
              context.push(RoutsName.adRegisterScreen);
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage("assets/images/icons8-user-64.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text("Ad Center", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),

          PopupMenuItem(
            onTap: () async {
              FirebaseAuth.instance.signOut();
              userController.clearUser();
              _sharePreferencesMethods.clearUserData();
              context.push(RoutsName.registrationScreen);
            },
            child: Row(
              children: [
                Icon(Icons.logout, size: 30, color: Colors.black),
                SizedBox(width: 15),
                Text("Log Out", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ];
      },
    );
  }

  Drawer _buildRightDrawer() {
    return Drawer(
      width: 300,
      backgroundColor: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text(
              "Business & Shop",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children:
                Provider().business_category.entries.map((entry) {
                  return ExpansionTile(
                    title: Text(entry.key),
                    children:
                        entry.value
                            .map(
                              (sub) => ListTile(
                                title: Text(sub),
                                onTap: () {
                                  Navigator.pop(context);
                                  print("Selected Subcategory: $sub");
                                },
                              ),
                            )
                            .toList(),
                  );
                }).toList(),
          ),
          // const Divider(),
          ListTile(
            title: const Text("Worker"),
            onTap: () {
              Navigator.pop(context);
              // customNavigate(context, RoutsName.workRegisterScreen, null);
            },
          ),
          ListTile(
            title: const Text("Vehicle"),
            onTap: () {
              Navigator.pop(context);
              // context.push(RoutsName.driverRegisterScreen);
            },
          ),
          ListTile(
            title: const Text("Ad Center"),
            onTap: () {
              Navigator.pop(context);
              // context.push(RoutsName.adRegisterScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out"),
            onTap: () {
              Navigator.pop(context);
              // perform logout
            },
          ),
        ],
      ),
    );
  }
}
