import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/models/chat_room_model.dart';

class ChatListScreen extends StatelessWidget {
  final List<ChatRoomModel> chatRoomModel = [
    ChatRoomModel(
        id: '1',
        senderName: 'Alice',
        lastMessage: 'Hello!',
        timestamp: DateTime.now()),
    ChatRoomModel(
        id: '2',
        senderName: 'Bob',
        lastMessage: 'Let’s play!',
        timestamp: DateTime.now().subtract(Duration(minutes: 10))),
    // Add more sample messages here
  ];

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: chatRoomModel.length,
        itemBuilder: (context, index) {
          final chat = chatRoomModel[index];
          return ListTile(
            title: Text(chat.senderName),
            subtitle: Text(chat.lastMessage),
            trailing: Text(
              "${chat.timestamp.hour}:${chat.timestamp.minute}",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              // 修正: chat.id を使用
              context.go('/home/chats/detail/${chat.id}');
            },
          );
        },
      ),
    );
  }
}
