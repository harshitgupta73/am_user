import 'package:get/get.dart';

import '../../data/firebase/chat_services/chat_service.dart';
import '../../modals/chat_message.dart';
import '../../modals/chat_room_model.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();

  final chatRooms = <ChatRoomModel>[].obs;

  var messages = <ChatMessage>[].obs;
  late String roomId;

  Future<void> initChat(String currentUserId, String otherUserId) async {
    roomId =await _chatService.getOrCreateChatRoom(currentUserId, otherUserId);
    _chatService.getMessages(roomId).listen((data) {
      messages.value = data;
    });
  }

  Future<void> sendMessage(String userId, String content) async {
    final msg = ChatMessage(
      senderId: userId,
      message: content,
      timestamp: DateTime.now(),
    );
    await _chatService.sendMessage(roomId, msg);
  }

  Future<void> loadUserChats(String userId) async {
    final rooms = await _chatService.fetchUserChatRooms(userId);
    chatRooms.assignAll(rooms);
  }
}
