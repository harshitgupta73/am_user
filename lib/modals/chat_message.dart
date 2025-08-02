class ChatMessage {
  final String senderId;
  final String message;
  final DateTime timestamp;
  final String? mediaUrl; // New: URL for image/video
  final String messageType; // 'text', 'image', 'video'

  ChatMessage({
    required this.senderId,
    required this.message,
    required this.timestamp,
    this.mediaUrl,
    this.messageType = 'text',
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'mediaUrl': mediaUrl,
      'messageType': messageType,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      mediaUrl: map['mediaUrl'],
      messageType: map['messageType'] ?? 'text',
    );
  }
}
