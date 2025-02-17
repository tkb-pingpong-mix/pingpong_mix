import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';
import '../viewmodels/messages_viewmodel.dart';

class ChatDetailsScreen extends ConsumerWidget {
  final String chatRoomId;
  ChatDetailsScreen({super.key, required this.chatRoomId});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesViewModelProvider(chatRoomId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'チャット',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('まだメッセージがありません'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == ref.watch(userViewModelProvider).value?.userId;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blueAccent : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(15),
                              topRight: const Radius.circular(15),
                              bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
                              bottomRight: isMe ? Radius.zero : const Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _formatTimestamp(message.sentAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isMe ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _buildMessageInput(context, ref),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'メッセージを入力...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => _sendMessage(ref),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(WidgetRef ref) {
    final user = ref.watch(userViewModelProvider).value;
    if (user == null) return;

    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      ref.read(messagesViewModelProvider(chatRoomId).notifier).sendMessage(user.userId, messageText);
      _messageController.clear();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
