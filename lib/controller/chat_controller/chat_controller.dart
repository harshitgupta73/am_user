import 'dart:io';

import 'package:am_user/data/firebase/storage_services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../data/firebase/chat_services/chat_service.dart';
import '../../modals/chat_message.dart';
import '../../modals/chat_room_model.dart';
import '../user_provider/get_user_provider.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final StorageServices _storageService = StorageServices();

  final chatRooms = <ChatRoomModel>[].obs;
  late String roomId;
  DocumentSnapshot? lastMessageDoc;
  bool hasMoreMessages = true;
  static const int pageSize = 20;

  var messages = <ChatMessage>[].obs;
  final userController = Get.find<GetUserController>();

  @override
  void onInit() {
    super.onInit();
    if(FirebaseAuth.instance.currentUser != null)
      loadUserChats(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> initChat(String currentUserId, String otherUserId) async {
    roomId =await _chatService.getOrCreateChatRoom(currentUserId, otherUserId);
    _chatService.getMessages(roomId).listen((data) {
      messages.value = data;
    });
  }

  Future<void> sendMessage(String userId, String content, {String? mediaUrl, String messageType = 'text'}) async {
    final msg = ChatMessage(
      senderId: userId,
      message: content,
      timestamp: DateTime.now(),
      mediaUrl: mediaUrl,
      messageType: messageType,
    );
    await _chatService.sendMessage(roomId, msg);
  }

  Future<void> sendImageMessage(String userId, String imagePath) async {
    final url = await _storageService.uploadImage(File(imagePath));
    await sendMessage(userId, '[Image]', mediaUrl: url, messageType: 'image');
  }

  Future<void> sendVideoMessage(String userId, String videoPath) async {
    final url = await _storageService.uploadVideo(File(videoPath));
    await sendMessage(userId, '[Video]', mediaUrl: url, messageType: 'video');
  }

  Future<void> loadUserChats(String userId) async {
    final rooms = await _chatService.fetchUserChatRooms(userId);
    chatRooms.assignAll(rooms);
  }
  //
  Future<void> fetchMoreMessages() async {
    if (!hasMoreMessages) return;
    final query = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastMessageDoc!)
        .limit(pageSize);
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      final newMessages = snapshot.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList();
      messages.addAll(newMessages);
      lastMessageDoc = snapshot.docs.last;
      if (snapshot.docs.length < pageSize) {
        hasMoreMessages = false;
      }
    } else {
      hasMoreMessages = false;
    }
  }
}
