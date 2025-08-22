import 'package:am_user/controller/controllers.dart';
import 'package:am_user/controller/image_picker_controller.dart';
import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/widgets/common_methods.dart';
import 'package:am_user/widgets/component/reel_conatiner.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../controller/chat_controller/chat_controller.dart';
import '../controller/user_provider/get_user_provider.dart';
import '../responsive/reponsive_layout.dart';

class ChatScreen extends StatefulWidget {
  final String targetUserId;
  final String targetUserName;
  const ChatScreen({super.key, required this.targetUserId, required this.targetUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePickerController imagePickerController = ImagePickerController();
  final controller = Get.find<Controller>();
  final chatController = Get.find<ChatController>();
  AllUserModal? user;
  final ScrollController _scrollController = ScrollController();
  RxBool isLoading = false.obs;

  final GetUserController getController = Get.find<GetUserController>();
  String? currentUserId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = getController.myUser?.userId;
    user = controller.allUsers.firstWhereOrNull((e) =>
    e.id ==
        widget.targetUserId);
    chatController.initChat(currentUserId!, widget.targetUserId);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      chatController.fetchMoreMessages();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final data = widget.data;
    final size = MediaQuery
        .of(context)
        .size;
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
              IconButton(onPressed: () {
                customNavigate(context, RoutsName.allChats);
              }, icon: Icon(Icons.arrow_back, color: Colors.black54,))
            ],
          ),
        ),

        body: Container(
          margin: Responsive.isDesktop(context) ? EdgeInsets.symmetric(
              horizontal: size.width / 4) : EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Expanded(
                child: Obx(() =>
                    ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        bool isSender = msg.senderId == currentUserId!;
                        Widget messageWidget;
                        if (msg.messageType == 'image' &&
                            msg.mediaUrl != null) {
                          messageWidget = GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => FullScreenImageView(
                              //       imageUrl: msg.mediaUrl!,
                              //     ),
                              //   ),
                              // );
                              customNavigate(context, RoutsName.fullImageScreen,queryParams: {
                                'imageUrl': msg.mediaUrl!,
                              },);
                            },
                            child: Image.network(
                              msg.mediaUrl!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else if (msg.messageType == 'video' &&
                            msg.mediaUrl != null) {
                          messageWidget = GestureDetector(
                            onTap: () {
                              customNavigate(
                                context,
                                RoutsName.fullVideoScreen,
                                queryParams: {
                                  'url': msg.mediaUrl!,
                                },
                              );
                            },
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: VideoPlayerWidget(url: msg.mediaUrl!),
                            ),
                          );
                        } else {
                          messageWidget = AutoSizeText(
                            msg.message,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 100,
                          );
                        }
                        return Align(
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isSender ? Colors.green : Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                                width: Responsive.isMobile(context) ? 200 : 300,
                                child: messageWidget
                            ),
                          ),
                        );
                      },
                    ),
                ),
              ),

              // Message Input Field
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Expanded(
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
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(
                                  Icons.attach_file, color: Colors.white),
                              onPressed: () {
                                // imagePickerController.getImage();
                                _handleAttachment(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),
                    // isLoading.value?  CircularProgressIndicator() : CircleAvatar(
                    //   backgroundColor: Colors.green,
                    //   radius: 25,
                    //   child: IconButton(
                    //     icon: const Icon(Icons.send, color: Colors.white),
                    //     onPressed: () {
                    //       // Handle send button press
                    //       final text = _messageController.text.trim();
                    //       if(text.isNotEmpty){
                    //         chatController.sendMessage(widget.currentUserId, text);
                    //       }
                    //       _messageController.clear();
                    //     },
                    //   ),
                    // ),
                    Obx(() {
                      return isLoading.value
                          ? SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.green,),
                      )
                          : CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 25,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            final text = _messageController.text.trim();
                            if (text.isNotEmpty) {
                              chatController.sendMessage(
                                  currentUserId!, text);
                            }
                            _messageController.clear();
                          },
                        ),
                      );
                    })

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAttachment(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Send Image'),
              onTap: () async {
                await imagePickerController.getImage();
                Navigator.pop(ctx);
                if (imagePickerController.imagePath.value.isNotEmpty) {
                  isLoading.value=true;
                  await chatController.sendImageMessage(currentUserId!, imagePickerController.imagePath.value);
                  isLoading.value=false;
                  imagePickerController.imagePath.value = '';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Send Video'),
              onTap: () async {
                await imagePickerController.getVideo();
                Navigator.pop(ctx);
                if (imagePickerController.videoPath.value.isNotEmpty) {
                  isLoading.value=true;
                  await chatController.sendVideoMessage(currentUserId!, imagePickerController.videoPath.value);
                  isLoading.value=false;
                  imagePickerController.videoPath.value = '';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
      });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator());
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String url;
  const FullScreenVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
          alignment: Alignment.topLeft,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            SafeArea(
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer( // for zoom/pan support
              child: Image.network(imageUrl),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
