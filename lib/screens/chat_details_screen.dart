import 'package:flutter/material.dart';

class ChatDetailsScreen extends StatelessWidget {
  final String chatId; // または ChatData 型

  const ChatDetailsScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Details')),
      body: Center(child: Text('Chat ID: $chatId')),
    );
  }
}
