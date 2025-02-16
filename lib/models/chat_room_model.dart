import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final List<String> members;
  final String lastMessage;
  final DateTime lastUpdated;
  final DateTime createdAt;
  final String roomName;
  final String? eventId;
  final String? clanId;
  final Map<String, int> unreadCount; // {userId : 未読メッセージ数}

  ChatRoomModel({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.lastUpdated,
    required this.createdAt,
    required this.roomName,
    this.eventId,
    this.clanId,
    required this.unreadCount,
  });

  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: doc.id,
      members: List<String>.from(data['members']),
      lastMessage: data['lastMessage'] ?? '',
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      roomName: data['roomName'] ?? '',
      eventId: data['eventId'],
      clanId: data['clanId'],
      unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'members': members,
      'lastMessage': lastMessage,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'createdAt': Timestamp.fromDate(createdAt),
      'roomName': roomName,
      if (eventId != null) 'eventId': eventId,
      if (clanId != null) 'clanId': clanId,
      'unreadCount': unreadCount,
    };
  }
}
