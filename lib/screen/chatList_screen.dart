import 'package:am_user/controller/controllers.dart';
import 'package:am_user/controller/user_provider/get_user_provider.dart';
import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/modals/chat_room_model.dart';
import 'package:am_user/widgets/common_methods.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../controller/chat_controller/chat_controller.dart';
import '../modals/chat_modal.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  final userController = Get.find<GetUserController>();
  final chatController = Get.find<ChatController>();
  final controller = Get.find<Controller>();

  List<ChatRoomModel> filteredChats = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState()  {
    super.initState(); // Listen for changes to the search input
    loadChats();
  }

  void loadChats() async{
    await chatController.loadUserChats(userController.myUser!.userId!);

  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DateFormat formatter = DateFormat('hh:mm a');

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // status bar background
        statusBarIconBrightness: Brightness.dark, // icons: time, battery
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0,left: 12,right: 12,),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search chats...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                // contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.black,
              ),
            ),
          ),
          Expanded(
              child: chatController.chatRooms.isEmpty ? Center(child: Text("Start Chatting !!",style: TextStyle(color: Colors.black),),) :  ListView.builder(
                itemCount: chatController.chatRooms.length,
                itemBuilder: (context, index) {
                  final chat = chatController.chatRooms[index];
                  print(chat.lastMessage);
                  final otherUserId = chatController.chatRooms[index].participants.firstWhere((
                      id) => id != userController.myUser!.userId);
                  AllUserModal? otherUser;
                  try {
                    otherUser = controller.allUsers.firstWhere((user) => user.id == otherUserId);
                    // print("dhdj= ${otherUser.name}");
                  } catch (e) {
                    // print("Error: $e");
                    otherUser = null;

                  }
                  return otherUser== null ? Center(child: Text("Loading.."),) : Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width :2,color:Colors.black,)
                    ),
                    child: ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(otherUser.image!),
                            radius: 25,
                          ),

                        ],
                      ),
                      title: Text(
                        otherUser.name,
                        style: TextStyle(
                          // fontWeight: chat.isRead ? FontWeight.normal : FontWeight.bold,
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: isDarkMode ? Colors.black54 : Colors.white54,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          Text(
                            formatTimestamp(chat.lastMessageAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[500] : Colors
                                  .grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),

                        ],
                      ),
                      onTap: () {
                        // Mark as read when tapped
                        customNavigate(
                          context,
                          RoutsName.chatScreen,
                          queryParams: {
                            'targetUserId': otherUserId,
                            'targetUserName': otherUser!.name,
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
