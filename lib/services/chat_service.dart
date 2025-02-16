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

    // チャットルームの最終メッセージを更新
    await _firestore.collection('ChatRooms').doc(chatRoomId).update({
      'lastMessage': text,
      'lastUpdated': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// イベント用の新規チャットルームを作成
  Future<String> createChatRoomForEvent(String eventId, List<String> members) async {
    final chatRef = _firestore.collection('ChatRooms').doc();
    final chatRoom = ChatRoomModel(
      id: chatRef.id,
      members: members,
      lastMessage: '',
      lastUpdated: DateTime.now(),
      eventId: eventId,
    );

    await chatRef.set(chatRoom.toFirestore());
    return chatRef.id;
  }

  /// クラン用の新規チャットルームを作成（今後の拡張）
  Future<String> createChatRoomForClan(String clanId, List<String> members) async {
    final chatRef = _firestore.collection('ChatRooms').doc();
    final chatRoom = ChatRoomModel(
      id: chatRef.id,
      members: members,
      lastMessage: '',
      lastUpdated: DateTime.now(),
      clanId: clanId,
    );

    await chatRef.set(chatRoom.toFirestore());
    return chatRef.id;
  }
}
