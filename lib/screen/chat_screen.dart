import 'package:am_user/controller/controllers.dart';
import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controller/chat_controller/chat_controller.dart';
import '../responsive/reponsive_layout.dart';

class ChatScreen extends StatefulWidget {
  // final dynamic data; // Use a proper model if possible
  final String currentUserId;
  final String targetUserId;
  final String targetUserName;
  const ChatScreen({super.key, required this.currentUserId, required this.targetUserId, required this.targetUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final controller = Get.find<Controller>();
  final chatController = Get.find<ChatController>();
  AllUserModal? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = controller.allUsers.firstWhereOrNull((e) => e.id == widget.targetUserId);
    chatController.initChat(widget.currentUserId, widget.targetUserId);
  }

  @override
  Widget build(BuildContext context) {
    // final data = widget.data;
    final size = MediaQuery.of(context).size;
    final messages = chatController.messages;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        context.pop();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          elevation: 2,
          centerTitle: true,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user!.image ?? ''),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      widget.targetUserName ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      minFontSize: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              IconButton(onPressed: (){
                context.go(RoutsName.allChats);
              }, icon: Icon(Icons.arrow_back,color: Colors.black54,))
            ],
          ),
        ),

        body: Container(
          margin: Responsive.isDesktop(context)?EdgeInsets.symmetric(horizontal:size.width/4 ):EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Obx (()
                => Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      bool isSender = msg.senderId == widget.currentUserId;
                      return Align(
                        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSender ? Colors.green : Colors.blueGrey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SizedBox(
                            width:Responsive.isMobile(context)?200: 300,
                            child: AutoSizeText(
                              msg.message,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 100,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Message Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          controller: _messageController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.attach_file,color: Colors.white,)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 25,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          // Handle send button press
                          final text = _messageController.text.trim();
                          if(text.isNotEmpty){
                            chatController.sendMessage(widget.currentUserId, text);
                          }
                          _messageController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
