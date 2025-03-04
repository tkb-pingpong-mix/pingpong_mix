import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/chat_rooms_viewmodel.dart';
import 'package:go_router/go_router.dart';
import '../utils/date_time_utils.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRooms = ref.watch(chatRoomsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            context.go('/home/profile');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            final chat = chatRooms[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text(chat.roomName),
                subtitle: Text('${chat.lastMessage} \n ${formatDateTime(chat.lastUpdated)}'),
                onTap: () => context.go('/home/chats/detail/${chat.id}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
