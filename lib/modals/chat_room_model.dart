import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String roomId;
  final List<String> participants; // userIds of participants
  final String lastMessage;
  final String lastMessageSenderId;
  final Timestamp lastMessageAt;

  ChatRoomModel({
    required this.roomId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageAt,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map, String id) {

    Timestamp timestamp;
    final raw = map['lastMessageAt'];

    if (raw is Timestamp) {
      timestamp = raw;
    } else if (raw is String) {
      timestamp = Timestamp.fromDate(DateTime.parse(raw));
    } else {
      timestamp = Timestamp.now(); // fallback
    }
    return ChatRoomModel(
      roomId: id,
      participants: List<String>.from(map['participants']),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageSenderId: map['lastMessageSenderId'] ?? '',
      lastMessageAt: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageAt': lastMessageAt,
    };
  }
}