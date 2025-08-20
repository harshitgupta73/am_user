import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:am_user/modals/userModal.dart';
import 'package:am_user/modals/worker_modal.dart';
import 'package:am_user/screen/chatList_screen.dart';
import 'package:am_user/screen/home_screen.dart';
import 'package:am_user/screen/jobe_search.dart';
import 'package:am_user/screen/serach_screen.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/screen/registration_screen.dart';
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
  List<WorkerModal> workers = [];

  final UserModal userModal = UserModal(
    email: "surah@gmail.com",
    contact: "9956463608",
    name: "Suraj Gupta",
    image: "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
    userId: null,
  );

  final items = <Widget>[
    _TabIcon(Icons.home),
    _TabIcon(Icons.search),
    _TabIcon(Icons.chat),
    _TabIcon(Icons.info_outline),
    _TabIcon(Icons.edit),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
    pages = [
      const HomeScreen(),
            SearchScreen(),
      const ChatListScreen(),
            JobSearchScreen(),
      const RegistrationScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildWebLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
                (index) => IconButton(
                  style: ButtonStyle(),
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
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
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

class _TabIcon extends StatelessWidget {
  final IconData icon;

  const _TabIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: Colors.white);
  }
}