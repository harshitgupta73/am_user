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
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

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
  final SharePreferencesMethods _sharePreferencesMethods = SharePreferencesMethods();
  final userController = Get.find<GetUserController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  List<dynamic>_filterList = [];

  final TextEditingController _searchController = TextEditingController();

  String option="";
  String selectedCategory='';
  String selectedSubCategory='';

  final driver = DriverModal(
    driverName: 'Ramesh Singh',
    driverContact: '9876543210',
    driverLicenceNo: 'DL1234567890',
    vehicleNo: 'MH12AB1234',
    vehicleOwnerName: 'Suresh Sharma',
    driverAddress: '123 Park Street, Mumbai',
    driverOtherSkill: 'Mechanic',
    vehicleRcImage: 'https://via.placeholder.com/400x200.png?text=RC+Image',
    driverImage: 'https://randomuser.me/api/portraits/men/45.jpg',
    drivingLicence: 'https://via.placeholder.com/400x200.png?text=Driving+Licence',
    stateValue: 'Maharashtra',
    distValue: 'Mumbai',
  );


  UserModal? userModal ;
  final slider = [
    BannerImageWidget(),
    BannerImageWidget(),
    BannerImageWidget(),
    BannerImageWidget(),
    BannerImageWidget(),
    BannerImageWidget()
  ];

  List<WorkerModal> workers = [];


  getUserData()async{
    UserModal? cachedData = await _sharePreferencesMethods.loadUserFromSharedPref();
    if(cachedData !=null){
      userModal = cachedData;
      setState(() {});
    }
    await userController.getUser();
    userModal = userController.myUser;
    print("user = ${userController.myUser!.name}");
    if(userModal!=null){
      _sharePreferencesMethods.saveUserToSharedPref(userModal!);
      setState(() {});
    }
  }
  String screen="";

  void fun(){
    if(userController.shopModal.value != null) screen='type_dashboard';
    else if(userController.workerModal.value != null) screen='type_dashboard';
    else if(userController.driverModal.value != null) screen='type_dashboard';
    else screen='user_dashboard';
  }



  @override
  void initState() {
    super.initState();
    getUserData();
    // print("_sharePreferencesMethods.getUserType() = ${_sharePreferencesMethods.getUserType()}");
    fun();
    if(!Platform.isAndroid){
      print("object");
    }
    // _searchController.addListener(_onChange);
  }

  final controller = Get.put(Controller());


  // void _onChange() {
  //   final query = _searchController.text.toLowerCase();
  //
  //   setState(() {
  //     // _filterList = workers.where((element) {
  //     //   final jobMatch = element.jobWork
  //     //       ?.split(',')
  //     //       .any((e) => e.trim().toLowerCase().contains(query)) ??
  //     //       false;
  //
  //       final nameMatch =
  //           element.workerName?.toLowerCase().contains(query) ?? false;
  //
  //       return jobMatch || nameMatch;
  //     }).toList();
  //   });
  // }

  navigateToProfileScreen(UserModal user) {
    if (!isSkiaWeb) {
      context.push(RoutsName.profileScreen, extra: user);

    } else {
      context.push(RoutsName.profileScreen, extra: user);
    }
  }


  @override
  Widget build(BuildContext context) {
    // print(controller.allUsers.length);
    return Scaffold(
      backgroundColor: backgroundColor,
      body:userModal ==null ?Center(child: CircularProgressIndicator(),):  Column(
        children: [
          SizedBox(height: Responsive.isMobile(context) ? 10 : 30),
          SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 10),
            bottom: true,
            child: Row(
              crossAxisAlignment: Responsive.isDesktop(context)
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // navigateToProfileScreen(userModal);
                    screen =="user_dashboard" ?
                    context.go(RoutsName.profileScreen) : context.go(RoutsName.typeDashboard);
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: userModal?.image == null || userModal!.image!.isEmpty?AssetImage(logo): NetworkImage(userModal!.image!),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: Responsive.isMobile(context) ||
                      Responsive.isTab(context)
                      ? 4
                      : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        userModal!.name??"",
                        style: TextStyle(
                            color: customTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        stepGranularity: 0.1,
                        minFontSize: 18,
                      ),
                      AutoSizeText(
                        userModal!.contact??"",
                        style: TextStyle(
                            color: customTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        stepGranularity: 0.1,
                        minFontSize: 14,
                      ),
                    ],
                  ),
                ),
                if (Responsive.isDesktop(context) || Responsive.isTab(context))
                  Expanded(flex: 10, child: CustomSearchbar(
                    onTap: () {
                      int index = 1;
                      context.push("${RoutsName.bottomNavigation}/$index");
                    },
                    controller: _searchController,
                    label: "Search here",
                  )),
                IconButton(
                  onPressed: () {
                    //context.push(RoutsName.allChats, extra: workers);
                    // context.push(RoutsName.);
                  },
                  icon: Icon(Icons.notifications,color: Colors.black54,),
                  color: customTextColor,
                ),
                IconButton(
                  onPressed: () {
                    //context.push(RoutsName.allChats, extra: workers);
                    SharePlus.instance.share(
                        ShareParams(text: 'check out my website https://example.com')
                    );
                  },
                  icon: Icon(Icons.share,color: Colors.green,),
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
          Expanded(
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
                  if (Responsive.isMobile(context)) const SizedBox(height: 10,),

                  CarouselSlider(
                    items: slider,
                    options: CarouselOptions(
                      height: Responsive.isDesktop(context)
                          ? 600
                          : Responsive.isTab(context)
                          ? 300
                          : 200,

                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      // onPageChanged: (index, reason) {
                      //   setState(() {
                      //     _currentIndex = index;
                      //   });
                      // },
                    ),
                  ),

                  SizedBox(height: 10,),

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: slider
                        .asMap()
                        .entries
                        .map((entry) {
                      return GestureDetector(
                        onTap: () => setState(() => _currentIndex = entry.key),
                        child: Container(
                          width: _currentIndex == entry.key ? 12.0 : 8.0,
                          height: _currentIndex == entry.key ? 12.0 : 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == entry.key
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  Container(
                    margin: EdgeInsets.only( left: 20),
                    child: AutoSizeText(
                      "Recommended Services",
                      minFontSize: 20,
                      maxLines: 1,
                      maxFontSize: 34,
                      style: TextStyle(
                        color: customTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.isDesktop(context) ? 34 : 24,
                        shadows: [
                          BoxShadow(color: Colors.orange,
                              offset: Offset(-1, 2),
                              blurRadius: 10,
                              spreadRadius: 1)
                        ],
                      ),
                    ),
                  ),

                  Obx(()
                    => controller.isLoading.value ? Center(child: CircularProgressIndicator(),) : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.allUsers.length,
                      shrinkWrap: true,
                      padding: Responsive.isMobile(context)
                          ? EdgeInsets.zero
                          : EdgeInsets.all(20),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                        crossAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
                        mainAxisSpacing: Responsive.isMobile(context) ? 0 : 10,
                        childAspectRatio:
                        Responsive.isDesktop(context)
                            ? 20 / 5
                            : Responsive.isMobile(context)
                            ? 14 / 5
                            : 15 / 5,
                      ),
                      itemBuilder: (context, index) {
                        final users = controller.allUsers[index];
                        print("users = ${users.name}");
                        return InkWell(
                          onTap: () {
                            if (kIsWeb) {
                              context.push("${RoutsName.cardDetailScreen}?userData=$driver");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CardDetailsScreen(users:users),
                                ),
                              );
                            }
                          },
                          child: ListDetailsCardForWeb(
                            id:users.id,
                            work: users.type,
                            image: users.image,
                            name: users.name,
                            contact: users.contact,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showMainCategoryMenu(context, Offset position) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      color: Colors.blue,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: Provider().business_category.keys
          .map((main) => PopupMenuItem<String>(
        value: main,
        child: Text(main),
      ))
          .toList(),
    ).then((selectedMainCategory) {
      if (selectedMainCategory != null) {
        final subCategories = Provider().business_category[selectedMainCategory]!;
        final newPos = Offset(position.dx + 200, position.dy); // adjust as needed
        showSubCategoriesMenu(context, newPos, subCategories);
      }
    });
  }

  void showSubCategoriesMenu(BuildContext context, Offset position, List<String> subCategories) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      color: Colors.blue,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: subCategories
          .map((sub) => PopupMenuItem<String>(
        value: sub,
        child: Text(sub),
      ))
          .toList(),
    ).then((value) {
      if (value != null) {
        print("Selected Subcategory: $value");
      }
    });
  }

  Widget popUpMenu() {
    return PopupMenuButton(
      color: backgroundColor,
      icon: Icon(Icons.menu, color: Colors.black,),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              child: GestureDetector(
                onTapDown: (details) {
                  Navigator.pop(context); // close current popup
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
                                  "assets/images/104a911c63dcaf4814ee6136c5825d5b.jpg"),
                              fit: BoxFit.cover)
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text("Business & Shop",style: TextStyle(color: Colors.black),)
                  ],
                ),
              )),
          PopupMenuItem(
              onTap: () {
                customNavigate(context, RoutsName.workRegisterScreen, null);
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
                                "assets/images/d50eb623382d5c7483cca89cc13582f7.jpg"),
                            fit: BoxFit.cover)
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("Profession & Worker",style: TextStyle(color: Colors.black),)
                ],
              )),
          PopupMenuItem(
              onTap: () {
                context.push(RoutsName.driverRegisterScreen);
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
                                "assets/images/ffeab1a8e03347dba1cf79d32d055309.jpg"),
                            fit: BoxFit.cover)
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("Vehicle",style: TextStyle(color: Colors.black),)
                ],
              )),
          PopupMenuItem(
              onTap: () {

                navigateToProfileScreen(userModal!);
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
                                "assets/images/d37b020e87945ad7f245e48df752ed03.jpg"),
                            fit: BoxFit.cover)
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("Profile",style: TextStyle(color: Colors.black),)
                ],
              )),
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
                            image: AssetImage(
                                "assets/images/icons8-user-64.png"),
                            fit: BoxFit.cover)
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("Ad Center",style: TextStyle(color: Colors.black),)
                ],
              )),


          PopupMenuItem(
              onTap: ()async {
                FirebaseAuth.instance.signOut();
                userController.clearUser();
                _sharePreferencesMethods.clearUserData();
                context.go(RoutsName.registrationScreen);
              },
              child: Row(
                children: [
                  Icon(Icons.logout, size: 30,color: Colors.black,),
                  SizedBox(width: 15,),
                  Text("Log Out",style: TextStyle(color: Colors.black),)
                ],
              )),
        ];
      },);
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
            title: const Text("Business & Shop",
                style: TextStyle(fontWeight: FontWeight.bold)),
            children: Provider().business_category.entries.map((entry) {
              return ExpansionTile(
                title: Text(entry.key),
                children: entry.value
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
            title: const Text("Profession & Worker"),
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
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              // navigateToProfileScreen(userModal!);
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