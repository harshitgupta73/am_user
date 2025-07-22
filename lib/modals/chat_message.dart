class ChatMessage {
  final String senderId;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
