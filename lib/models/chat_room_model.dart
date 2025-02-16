import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final List<String> members;
  final String lastMessage;
  final DateTime lastUpdated;
  final String? eventId;
  final String? clanId;

  ChatRoomModel({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.lastUpdated,
    this.eventId,
    this.clanId,
  });

  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: doc.id,
      members: List<String>.from(data['members']),
      lastMessage: data['lastMessage'] ?? '',
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      eventId: data['eventId'],
      clanId: data['clanId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'members': members,
      'lastMessage': lastMessage,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      if (eventId != null) 'eventId': eventId,
      if (clanId != null) 'clanId': clanId,
    };
  }
}
