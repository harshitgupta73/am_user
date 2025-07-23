

// GoRouter Setup
import 'dart:convert';
import 'dart:io';

import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/modals/driver_modal.dart';
import 'package:am_user/screen/ad_center/ad_account_create.dart';
import 'package:am_user/screen/ad_center/ad_login_screen.dart';
import 'package:am_user/screen/add_job_page.dart';
import 'package:am_user/screen/card_deatils_csreen.dart';
import 'package:am_user/screen/driverRegisterScreen.dart';
import 'package:am_user/screen/login_screen.dart';
import 'package:am_user/screen/otp_screen.dart';
import 'package:am_user/screen/selected_user_screen.dart';
import 'package:am_user/screen/serach_screen.dart';
import 'package:am_user/screen/splash_screen.dart';
import 'package:am_user/screen/street_list_screen.dart';
import 'package:am_user/screen/type_dashboard_screen.dart';
import 'package:am_user/screen/user_register_screen.dart';
import 'package:am_user/widgets/bottom_navigation_bar/bottom_nevigation.dart';
import 'package:am_user/widgets/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modals/userModal.dart';
import '../../modals/worker_modal.dart';
import '../../screen/add_post_screen.dart';
import '../../screen/chatList_screen.dart';
import '../../screen/chat_screen.dart';
import '../../screen/dash_bord_profile_screen.dart';
import '../../screen/error_screen.dart';
import '../../screen/home_screen.dart';
import '../../screen/profile_screen.dart';
import '../../screen/shop_register_screen.dart';
import '../../screen/worker_register_screen.dart';

bool isAndroid(){
  if(Platform.isAndroid) return true;
  return false;
}

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,

  initialLocation:"/",
  // initialLocation:"/listScreen",

  routes: [

    GoRoute(
        path:RoutsName.splashScreen,
        builder: (context, state) {
          return SplashScreen();

        }
    ),

    GoRoute(
        path:RoutsName.listScreen,
        builder: (context, state) {
          return GorakhpurPlacesScreen();

        }
    ),

    GoRoute(
      path:"${RoutsName.bottomNavigation}/:currentIndex",
        builder: (context, state) {
        final String? currentIndex = state.pathParameters["currentIndex"];
        int newIndex = int.tryParse(currentIndex??"")??0;
          return  CurvedNavBar(currentIndex: newIndex,);

        }
      ),


    GoRoute(
      path: RoutsName.homeScreen,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: RoutsName.registrationScreen,
      builder: (context, state) => RegistrationScreen(),
    ),
    GoRoute(
      path: RoutsName.addPostScreen,
      builder: (context, state) => const AddPostScreen(),
    ),
    GoRoute(
      path:RoutsName.chatScreen,
      builder: (context, state) {
        final currentUserId = state.uri.queryParameters['currentUserId'] ?? '';
        final targetUserId = state.uri.queryParameters['targetUserId'] ?? '';
        final targetUserName = state.uri.queryParameters['targetUserName'] ?? '';

        return ChatScreen(
          currentUserId: currentUserId,
          targetUserId: targetUserId,
          targetUserName: targetUserName,
        );
      },
    ),

    GoRoute(
      path:RoutsName.allChats ,
      builder: (context, state) {
        return ChatListScreen();

      },
    ),
    GoRoute(
        path:RoutsName.profileScreen ,
        builder: (context, state) {
          return ProfileScreen();
        }
    ),

    GoRoute(
        path:RoutsName.shopRegisterScreen ,
        builder: (context, state) {
          return ShopRegisterScreen( );
        }
    ),

    GoRoute(
        path: RoutsName.workRegisterScreen,
        builder: (context, state) {
          return WorkerRegister();
        }
    ),
    GoRoute(
        path: RoutsName.driverRegisterScreen,
        builder: (context, state) {
          return DriverRegisterScreen();
        }
    ),
    GoRoute(
        path: RoutsName.cardDetailScreen,
        builder: (context, state) {
          final user = state.extra as AllUserModal?;
          return CardDetailsScreen(users: user);
        }
    ),

    GoRoute(
      path: "${RoutsName.loginScreen}/:loginAs",
      builder: (context, state) {
        return LoginScreen();
      },
    ),

    GoRoute(
    path: RoutsName.otpScreen,
        builder: (context, state) {
     return OtpScreen();
       },
    ),

    GoRoute(
      path: RoutsName.dashBord,
      builder: (context, state) {
        return DashBordScreen();
      },


    ),
    GoRoute(
      path: RoutsName.adRegisterScreen,
      builder: (context, state) {
        return AdRegisterScreen();
      },


    ),
    GoRoute(
      path: RoutsName.adLoginScreen,
      builder: (context, state) {
        return AdLoginScreen();
      },
      
    ),
    GoRoute(
      path: RoutsName.searchScreen,
      builder: (context, state) {
        return SearchScreen();
      },

    ),
    GoRoute(
      path: RoutsName.typeDashboard,
      builder: (context, state) {
        return TypeDashboardScreen();
      },

    ),
    GoRoute(
      path: RoutsName.addJob,
      builder: (context, state) {
        return AddJobPage();
      },

    ),
    GoRoute(
      path: RoutsName.selectedUsers,
      builder: (context, state) {
        return SelectedUserScreen();
      },

    ),
    GoRoute(
      path: RoutsName.adLoginScreen,
      builder: (context, state) {
        // Safely extract DriverModal from state extra
        final driver = state.extra as AllUserModal?;

        // Ensure that driver is not null before passing to CardDetailsScreen
        if (driver == null) {
          return Scaffold(
            body: Center(child: Text("Driver data is missing.")),
          );
        }

        return CardDetailsScreen(users:driver ,);
      },
    ),
  ],
);


class RoutsName{
  static String splashScreen = '/';
 static String homeScreen = '/homeScreen';
 static String chatScreen = '/chatScreen';
 static String allChats ='/notification';
 static String profileScreen ='/profileScreen';
 static String shopRegisterScreen ='/shopRegisterScreen';
 static String workRegisterScreen = '/workerRegisterScreen';
 static String driverRegisterScreen = '/driverRegisterScreen';
 static String loginScreen = '/loginScreen';
 static String otpScreen = "/otpScreen";
 static String dashBord = '/dashBord';
 static String bottomNavigation = '/bottomNavigation';
 static String adRegisterScreen = '/adRegisterScreen';
 static String adLoginScreen = '/adLoginScreen';
 static String cardDetailScreen = '/cardDetailScreen';
 static String fullVideoScreen = '/fullVideoScreen';
 static String searchScreen ='/searchScreen';
 static String registrationScreen = '/registrationScreen';
 static String addPostScreen = '/addPostScreen';
 static String listScreen = '/listScreen';
 static String addJob = '/addJob';
 static String typeDashboard='/typeDashboard';
 static String selectedUsers='/selectedUsers';

}