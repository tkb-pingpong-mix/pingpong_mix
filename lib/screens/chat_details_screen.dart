import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/messages_viewmodel.dart';

class ChatDetailsScreen extends ConsumerWidget {
  final String chatRoomId;
  ChatDetailsScreen({super.key, required this.chatRoomId});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesViewModelProvider(chatRoomId));

    return Scaffold(
      appBar: AppBar(title: Text('チャット詳細')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.text),
                  subtitle: Text(message.sentAt.toString()),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'メッセージを入力'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    ref.read(messagesViewModelProvider(chatRoomId).notifier).sendMessage('userId', _messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
