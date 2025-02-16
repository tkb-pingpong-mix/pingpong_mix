import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';
import '../services/chat_service.dart';
import '../models/chat_room_model.dart';

final chatRoomsViewModelProvider = StateNotifierProvider<ChatRoomsViewModel, List<ChatRoomModel>>((ref) {
  return ChatRoomsViewModel(ref);
});

class ChatRoomsViewModel extends StateNotifier<List<ChatRoomModel>> {
  final Ref ref;
  final ChatService _chatService;

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
}
