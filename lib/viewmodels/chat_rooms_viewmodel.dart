import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pingpong_mix/utils/log.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';
import '../models/chat_room_model.dart';
import '../services/chat_service.dart';

final chatRoomsViewModelProvider = StateNotifierProvider<ChatRoomsViewModel, List<ChatRoomModel>>((ref) {
  return ChatRoomsViewModel(ref);
});

class ChatRoomsViewModel extends StateNotifier<List<ChatRoomModel>> {
  final Ref ref;
  final ChatService _chatService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatRoomsViewModel(this.ref)
      : _chatService = ref.read(chatServiceProvider),
        super([]) {
    _fetchChatRooms();
  }

  void _fetchChatRooms() {
    final userState = ref.read(userViewModelProvider);

    userState.when(
      data: (user) {
        final userId = user?.userId;
        if (userId == null) return;

        _chatService.getChatRooms(userId).listen((chatRooms) {
          state = chatRooms;
        });
      },
      loading: () {
        // ローディング中は何もしない
      },
      error: (err, stack) {
        print('Error fetching user: $err');
      },
    );
  }

  /// イベント ID に紐づく ChatRoom を作成または取得￥
  Future<String> createChatRoomByEventID(String eventId, List<String> participants, String currentUserId) async {
    try {
      Log.d("チャットルーム検索開始: eventId = $eventId", tag: "ChatRoom");

      final chatQuery = await _firestore.collection('ChatRooms').where('eventId', isEqualTo: eventId).limit(1).get();
      Log.d("chatQuery取得完了");

      if (chatQuery.docs.isNotEmpty) {
        final existingChatRoom = chatQuery.docs.first;
        final chatRoomId = existingChatRoom.id;
        final chatRoomData = existingChatRoom.data();

        Log.d("既存のチャットルームを発見: chatRoomId = $chatRoomId", tag: "ChatRoom");

        List<String> members = List<String>.from(chatRoomData['members']);

        // 現在のユーザーがチャットに参加しているか確認
        if (!members.contains(currentUserId)) {
          Log.d("ユーザー $currentUserId が未参加のため、追加", tag: "ChatRoom");
          members.add(currentUserId);

          try {
            await _firestore.collection('ChatRooms').doc(chatRoomId).update({
              'members': members,
              'lastUpdated': DateTime.now(),
            });
          } catch (updateError) {
            Log.e("チャットルーム更新エラー: $updateError", tag: "ChatRoom");
            throw Exception("チャットルームのメンバー更新に失敗しました。");
          }
        } else {
          Log.d("ユーザー $currentUserId は既に参加済み", tag: "ChatRoom");
        }

        return chatRoomId;
      }

      Log.d("チャットルームが見つからないため、新規作成を実行", tag: "ChatRoom");

      final newChatRef = _firestore.collection('ChatRooms').doc();
      final newChatRoom = ChatRoomModel(
        id: newChatRef.id,
        members: {...participants, currentUserId}.toList(),
        lastMessage: "",
        lastUpdated: DateTime.now(),
        eventId: eventId,
      );

      Log.d("新規チャットルーム作成: chatRoomId = ${newChatRef.id}, members = ${newChatRoom.members}", tag: "ChatRoom");

      try {
        await newChatRef.set(newChatRoom.toFirestore());

        Log.d("新規チャットルームが Firestore に保存されました: chatRoomId = ${newChatRef.id}", tag: "ChatRoom");
      } catch (createError) {
        Log.e("チャットルーム作成エラー: $createError", tag: "ChatRoom");
        throw Exception("チャットルームの作成に失敗しました。");
      }

      return newChatRef.id;
    } catch (e, stackTrace) {
      Log.e("チャットルーム作成中にエラー発生", tag: "ChatRoom", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
