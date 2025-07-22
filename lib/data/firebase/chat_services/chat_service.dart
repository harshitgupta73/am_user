import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../modals/chat_message.dart';
import '../../../modals/chat_room_model.dart';

class ChatService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> getOrCreateChatRoom(String currentUser, String userId2) async {
    QuerySnapshot snapshot = await _db.collection('chatRooms')
        .where('participants', arrayContains: currentUser)
        .get();

    for (var doc in snapshot.docs) {
      List participants = doc['participants'];
      if (participants.contains(userId2)) {
        return doc.id;
      }
    }

    String newRoomId = _db.collection('chatRooms').doc().id;
    await _db.collection('chatRooms').doc(newRoomId).set({
      'roomId': newRoomId,
      'participants': [currentUser, userId2],
      'lastMessageSenderId': currentUser,
      'lastMessage': '',
      'lastMessageAt': DateTime.now().toIso8601String(),
    });

    return newRoomId;
  }

  // String getChatRoomId(String userId1, String userId2) {
  //   final ids = [userId1, userId2]..sort();
  //   return ids.join("_");
  // }

  Stream<List<ChatMessage>> getMessages(String roomId) {
    return _db
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList());
  }

  Future<void> sendMessage(String roomId, ChatMessage message) async {
    await _db
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .add(message.toMap());

    await _db.collection('chatRooms').doc(roomId).update({
      'lastMessage': message.message,
      'lastMessageAt': Timestamp.now(),
    });
  }

  Future<List<ChatRoomModel>> fetchUserChatRooms(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => ChatRoomModel.fromMap(doc.data(), doc.id)).toList();
  }

}