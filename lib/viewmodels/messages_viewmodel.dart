import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/chat_service.dart';
import '../models/message_model.dart';

final messagesViewModelProvider = StateNotifierProvider.family<MessagesViewModel, List<MessageModel>, String>((ref, chatRoomId) {
  return MessagesViewModel(ref, chatRoomId);
});

class MessagesViewModel extends StateNotifier<List<MessageModel>> {
  final Ref ref;
  final ChatService _chatService;
  final String chatRoomId;

  MessagesViewModel(this.ref, this.chatRoomId)
      : _chatService = ref.read(chatServiceProvider),
        super([]) {
    _fetchMessages();
  }

  void _fetchMessages() {
    _chatService.getMessages(chatRoomId).listen((messages) {
      state = messages;
    });
  }

  Future<void> sendMessage(String senderId, String text) async {
    await _chatService.sendMessage(chatRoomId, senderId, text);
  }
}
