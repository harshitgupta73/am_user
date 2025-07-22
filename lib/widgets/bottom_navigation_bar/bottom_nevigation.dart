import 'package:am_user/modals/userModal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:am_user/screen/chatList_screen.dart';
import 'package:am_user/screen/home_screen.dart';
import 'package:am_user/screen/jobe_search.dart';
import 'package:am_user/screen/serach_screen.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import '../../screen/dash_bord_profile_screen.dart';
import '../../screen/registration_screen.dart';
import '../routs/routs.dart';

class CurvedNavBar extends StatefulWidget {
  final int currentIndex;

  const CurvedNavBar({super.key, this.currentIndex = 0});

  @override
  State<CurvedNavBar> createState() => _CurvedNavBarState();
}

class _CurvedNavBarState extends State<CurvedNavBar> {
  late int _selectedIndex;

  late List<Widget> pages;
  // final dummyWorker = WorkerModal(
  //   workerName: 'Amit Kumar',
  //   address: '456 Gandhi Nagar, Delhi',
  //   otherSkills: 'Plumbing, Painting',
  //   selectedGender: 'Male',
  //   stateValue: 'Delhi',
  //   distValue: 'Central Delhi',
  //   jobWorkCategory: 'Construction',
  //   jobWork: 'Mason',
  //   // If you don’t have an actual image, you can skip this or use a placeholder image.
  //   workerImage: null, // Or use Uint8List.fromList(...) if you have image bytes
  // );


   List<WorkerModal> workers = [];

  final UserModal userModal = UserModal(

   email:  "surah@gmail.com",
  contact:   "9956463608",
   name:  "Suraj Gupta",
   image:  "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
  userId:   null
  );

  final items = <Widget>[
    tabIcon(Icons.home),
    tabIcon(Icons.search),
    tabIcon(Icons.chat),
    tabIcon(Icons.info_outline),
    tabIcon(Icons.edit),
  ];

  static Widget tabIcon(IconData icon) {
    return Icon(icon, color: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    // workers = List.generate(10, (index) => dummyWorker,);
    _selectedIndex = widget.currentIndex;
    pages = [
      HomeScreen(),
      SearchScreen(),
      ChatListScreen(),
      JobSearchScreen(),
      RegistrationScreen(),

    ];
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;

    return isWeb
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
                (index) => IconButton(
              icon: items[index],
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                });
                context.go('${RoutsName.bottomNavigation}/$index');
              },
            ),
          ),
        ),
      ),
      body: pages[_selectedIndex],
    )
        : Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: backgroundColor,
        color: forgroundColor,
        buttonBackgroundColor: Colors.black,
        height: 60,
        items: items,
        index: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      body: pages[_selectedIndex],
    );
  }
}
