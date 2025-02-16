import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ユーザーが参加しているチャットルーム一覧を取得
  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    return _firestore
        .collection('ChatRooms')
        .where('members', arrayContains: userId)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatRoomModel.fromFirestore(doc)).toList());
  }

  /// 指定した `chatRoomId` に紐づくメッセージ一覧を取得
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    return _firestore
        .collection('Messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList());
  }

  /// 新しいメッセージを送信
  Future<void> sendMessage(String chatRoomId, String senderId, String text) async {
    final messageRef = _firestore.collection('Messages').doc();

    final message = MessageModel(
      id: messageRef.id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      text: text,
      sentAt: DateTime.now(),
    );

    await messageRef.set(message.toFirestore());

    // チャットルームの最終メッセージと未読カウントを更新
    final chatRoomRef = _firestore.collection('ChatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomRef.get();
    final chatRoomData = chatRoomSnapshot.data() as Map<String, dynamic>;

    Map<String, int> unreadCount = Map<String, int>.from(chatRoomData['unreadCount'] ?? {});

    // 送信者以外の未読メッセージ数を増加
    for (var member in List<String>.from(chatRoomData['members'])) {
      if (member != senderId) {
        unreadCount[member] = (unreadCount[member] ?? 0) + 1;
      }
    }

    await chatRoomRef.update({
      'lastMessage': text,
      'lastUpdated': Timestamp.fromDate(DateTime.now()),
      'unreadCount': unreadCount,
    });
  }

  /// 未読メッセージ数をリセット
  Future<void> resetUnreadCount(String chatRoomId, String userId) async {
    final chatRoomRef = _firestore.collection('ChatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomRef.get();
    final chatRoomData = chatRoomSnapshot.data() as Map<String, dynamic>;

    Map<String, int> unreadCount = Map<String, int>.from(chatRoomData['unreadCount'] ?? {});
    unreadCount[userId] = 0; // 自分の未読数をリセット

    await chatRoomRef.update({'unreadCount': unreadCount});
  }

  /// クラン用の新規チャットルームを作成（今後の拡張）
  Future<String> createChatRoomForClan(String clanId, List<String> members) async {
    final chatRef = _firestore.collection('ChatRooms').doc();

    final chatRoom = ChatRoomModel(
      id: chatRef.id,
      members: members,
      lastMessage: '',
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
      roomName: 'クランチャット',
      clanId: clanId,
      unreadCount: {for (var member in members) member: 0},
    );

    await chatRef.set(chatRoom.toFirestore());
    return chatRef.id;
  }
}
