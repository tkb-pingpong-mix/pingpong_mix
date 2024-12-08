class ChatRoomModel {
  final String id;
  final String senderName;
  final String lastMessage;
  final DateTime timestamp;

  ChatRoomModel({
    required this.id,
    required this.senderName,
    required this.lastMessage,
    required this.timestamp,
  });
}
